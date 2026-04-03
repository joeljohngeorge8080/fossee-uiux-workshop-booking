import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Suspense, lazy } from 'react';
import Layout from './components/Layout/Layout';

// Lazy loading pages for performance
const WorkshopList = lazy(() => import('./pages/WorkshopList/WorkshopList'));
const WorkshopDetails = lazy(() => import('./pages/WorkshopDetails/WorkshopDetails'));

function App() {
  return (
    <Router>
      <Layout>
        <Suspense fallback={<div style={{ padding: '2rem', textAlign: 'center' }}>Loading...</div>}>
          <Routes>
            <Route path="/" element={<WorkshopList />} />
            <Route path="/workshop/:id" element={<WorkshopDetails />} />
            <Route path="*" element={<div style={{ padding: '2rem', textAlign: 'center' }}>Page Not Found</div>} />
          </Routes>
        </Suspense>
      </Layout>
    </Router>
  );
}

export default App;
