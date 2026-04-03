import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Suspense, lazy } from 'react';
import Layout from './components/Layout/Layout';
import ErrorBoundary from './components/ErrorBoundary/ErrorBoundary';
import StatusMessage from './components/StatusMessage/StatusMessage';
import { WorkshopProvider } from './context/WorkshopContext';
import { ToastProvider } from './components/Toast/ToastContext';

// Lazy-loaded pages — each becomes its own JS chunk
const WorkshopList    = lazy(() => import('./pages/WorkshopList/WorkshopList'));
const WorkshopDetails = lazy(() => import('./pages/WorkshopDetails/WorkshopDetails'));

function App() {
    return (
        <Router>
            <WorkshopProvider>
                <ToastProvider>
                    <ErrorBoundary>
                        <Layout>
                            <Suspense fallback={<StatusMessage type="loading" />}>
                                <Routes>
                                    <Route path="/"             element={<WorkshopList />} />
                                    <Route path="/workshop/:id" element={<WorkshopDetails />} />
                                    <Route
                                        path="*"
                                        element={
                                            <StatusMessage
                                                type="empty"
                                                message="Page not found. The URL you visited doesn't exist."
                                            />
                                        }
                                    />
                                </Routes>
                            </Suspense>
                        </Layout>
                    </ErrorBoundary>
                </ToastProvider>
            </WorkshopProvider>
        </Router>
    );
}

export default App;
