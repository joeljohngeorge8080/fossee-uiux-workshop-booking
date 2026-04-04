import React, { createContext, useContext, useCallback, useReducer, useEffect, useRef } from 'react';
import styles from './Toast.module.css';

const ToastContext = createContext(null);

function toastReducer(state, action) {
    switch (action.type) {
        case 'ADD': return [...state, action.toast];
        case 'REMOVE': return state.filter((t) => t.id !== action.id);
        default: return state;
    }
}

let _nextId = 0;

export function ToastProvider({ children }) {
    const [toasts, dispatch] = useReducer(toastReducer, []);
    const addToast = useCallback((message, type = 'info', duration = 4000) => {
        dispatch({ type: 'ADD', toast: { id: ++_nextId, message, type, duration } });
    }, []);
    const removeToast = useCallback((id) => dispatch({ type: 'REMOVE', id }), []);

    return (
        <ToastContext.Provider value={{ addToast }}>
            {children}
            <ToastList toasts={toasts} onRemove={removeToast} />
        </ToastContext.Provider>
    );
}

// eslint-disable-next-line react-refresh/only-export-components
export function useToast() {
    const ctx = useContext(ToastContext);
    if (!ctx) throw new Error('useToast must be used inside <ToastProvider>');
    return ctx;
}

function ToastList({ toasts, onRemove }) {
    if (toasts.length === 0) return null;
    return (
        <div className={styles.list} role="region" aria-label="Notifications" aria-live="polite" aria-atomic="false">
            {toasts.map((t) => <ToastItem key={t.id} toast={t} onRemove={onRemove} />)}
        </div>
    );
}

function ToastItem({ toast, onRemove }) {
    const timerRef = useRef(null);
    useEffect(() => {
        timerRef.current = setTimeout(() => onRemove(toast.id), toast.duration);
        return () => clearTimeout(timerRef.current);
    }, [toast.id, toast.duration, onRemove]);

    const ICONS = { success: '✅', error: '❌', info: 'ℹ️', warning: '⚠️' };
    return (
        <div className={`${styles.toast} ${styles[toast.type] ?? ''}`} role="alert">
            <span className={styles.icon} aria-hidden="true">{ICONS[toast.type] ?? ICONS.info}</span>
            <p className={styles.message}>{toast.message}</p>
            <button className={styles.close} onClick={() => onRemove(toast.id)} aria-label="Dismiss notification">×</button>
        </div>
    );
}
