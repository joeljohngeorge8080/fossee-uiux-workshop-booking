import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Suspense, lazy } from 'react';
import Layout from './components/Layout/Layout';

const WorkshopList    = lazy(() => import('./pages/WorkshopList/WorkshopList'));
const WorkshopDetails = lazy(() => import('./pages/WorkshopDetails/WorkshopDetails'));

function App() {
  return (
    <Router>
      <Layout>
        <Suspense fallback={
          <div style={{ display:'flex', justifyContent:'center', padding:'4rem' }}>
            <div className="loader" aria-label="Loading…" />
          </div>
        }>
          <Routes>
            <Route path="/"             element={<WorkshopList />} />
            <Route path="/workshop/:id" element={<WorkshopDetails />} />
            <Route path="*"             element={
              <div style={{ textAlign:'center', padding:'4rem' }}>
                <h2>Page Not Found</h2>
                <p style={{ color:'var(--color-text-muted)', marginTop:'1rem' }}>
                  The page you're looking for doesn't exist.
                </p>
              </div>
            } />
          </Routes>
        </Suspense>
      </Layout>
    </Router>
  );
}

export default App;
