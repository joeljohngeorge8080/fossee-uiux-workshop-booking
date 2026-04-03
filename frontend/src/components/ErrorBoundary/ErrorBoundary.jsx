import React from 'react';
import styles from './ErrorBoundary.module.css';

class ErrorBoundary extends React.Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false, error: null };
        this.reset = this.reset.bind(this);
    }

    static getDerivedStateFromError(error) { return { hasError: true, error }; }

    componentDidCatch(error, info) { console.error('[ErrorBoundary]', error, info.componentStack); }

    reset() { this.setState({ hasError: false, error: null }); }

    render() {
        if (this.state.hasError) {
            if (this.props.fallback) return this.props.fallback(this.state.error, this.reset);
            return (
                <div className={styles.container} role="alert">
                    <div className={styles.icon} aria-hidden="true">⚠️</div>
                    <h2 className={styles.title}>Something went wrong</h2>
                    <p className={styles.message}>{this.state.error?.message ?? 'An unexpected error occurred.'}</p>
                    <button className={styles.retryBtn} onClick={this.reset}>Try again</button>
                </div>
            );
        }
        return this.props.children;
    }
}

export default ErrorBoundary;
