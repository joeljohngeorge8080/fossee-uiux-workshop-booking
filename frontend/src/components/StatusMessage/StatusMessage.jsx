import React from 'react';
import styles from './StatusMessage.module.css';

const StatusMessage = ({ type, message, onRetry }) => {
    if (type === 'loading') {
        return (
            <div className={styles.container} role="status" aria-live="polite">
                <div className={styles.spinner} aria-hidden="true" />
                <p className={styles.text}>{message ?? 'Loading…'}</p>
            </div>
        );
    }
    if (type === 'error') {
        return (
            <div className={styles.container} role="alert">
                <div className={styles.errorIcon} aria-hidden="true">⚠️</div>
                <p className={styles.text}>{message ?? 'Something went wrong.'}</p>
                {onRetry && <button className={styles.retryBtn} onClick={onRetry}>Try again</button>}
            </div>
        );
    }
    if (type === 'empty') {
        return (
            <div className={styles.container}>
                <p className={styles.text}>{message ?? 'No items found.'}</p>
            </div>
        );
    }
    return null;
};

export default StatusMessage;
