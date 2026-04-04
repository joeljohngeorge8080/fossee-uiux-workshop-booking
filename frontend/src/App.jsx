import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Suspense, lazy } from 'react';
import Layout from './components/Layout/Layout';

/* Route-level code splitting — each page is a separate JS chunk */
const WorkshopList    = lazy(() => import('./pages/WorkshopList/WorkshopList'));
const WorkshopDetails = lazy(() => import('./pages/WorkshopDetails/WorkshopDetails'));
const MyBookings      = lazy(() => import('./pages/MyBookings/MyBookings'));
const About           = lazy(() => import('./pages/About/About'));
const SignIn          = lazy(() => import('./pages/SignIn/SignIn'));

/* Inline loading fallback — no extra component needed */
const PageLoader = () => (
  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '40vh', gap: '1rem', color: 'var(--color-text-muted)', fontSize: 'var(--text-sm)' }}>
    <span className="spinner" aria-hidden="true" />
    <p>Loading…</p>
  </div>
);

/* 404 page — only for truly unknown URLs */
const NotFound = () => (
  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '50vh', gap: '1rem', textAlign: 'center' }}>
    <div style={{ fontSize: '4rem' }}>🔍</div>
    <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 'var(--text-3xl)' }}>Page not found</h2>
    <p style={{ color: 'var(--color-text-muted)', maxWidth: '360px' }}>
      The page you're looking for doesn't exist. Try browsing our workshops instead.
    </p>
    <a href="/" style={{ marginTop: '1rem', display: 'inline-block', padding: '0.75rem 2rem', background: 'var(--color-primary)', color: '#fff', borderRadius: 'var(--radius-md)', fontWeight: 600 }}>
      Browse Workshops
    </a>
  </div>
);

function App() {
  return (
    <Router>
      <Layout>
        <Suspense fallback={<PageLoader />}>
          <Routes>
            <Route path="/"             element={<WorkshopList />}    />
            <Route path="/workshop/:id" element={<WorkshopDetails />} />
            <Route path="/my-bookings"  element={<MyBookings />}      />
            <Route path="/about"        element={<About />}           />
            <Route path="/sign-in"      element={<SignIn />}          />
            {/* Catch-all — only truly unknown URLs land here */}
            <Route path="*"             element={<NotFound />}        />
          </Routes>
        </Suspense>
      </Layout>
    </Router>
  );
}

export default App;
