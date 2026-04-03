import { useState, useEffect, useCallback, useRef } from 'react';

const useAsync = (asyncFn, immediate = true) => {
    const [state, setState] = useState({ data: null, isLoading: immediate, error: null });
    const isMountedRef = useRef(true);

    useEffect(() => {
        isMountedRef.current = true;
        return () => { isMountedRef.current = false; };
    }, []);

    const execute = useCallback(async () => {
        setState((prev) => ({ ...prev, isLoading: true, error: null }));
        try {
            const data = await asyncFn();
            if (isMountedRef.current) setState({ data, isLoading: false, error: null });
        } catch (err) {
            if (isMountedRef.current) setState({ data: null, isLoading: false, error: err.message ?? 'Unknown error' });
        }
    }, [asyncFn]);

    useEffect(() => { if (immediate) execute(); }, [execute, immediate]);

    return { ...state, retry: execute };
};

export default useAsync;
