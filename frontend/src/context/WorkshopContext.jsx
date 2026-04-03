import React, { createContext, useContext, useCallback, useReducer, useMemo } from 'react';
import { fetchWorkshops, fetchWorkshop, registerForWorkshop } from '../api/workshops';
import useAsync from '../hooks/useAsync';

const WorkshopContext = createContext(null);

function detailCacheReducer(state, action) {
    switch (action.type) {
        case 'CACHE_WORKSHOP':
            return { ...state, [action.id]: action.workshop };
        case 'DECREMENT_SPOTS':
            if (!state[action.id]) return state;
            return {
                ...state,
                [action.id]: {
                    ...state[action.id],
                    spotsLeft: Math.max(0, (state[action.id].spotsLeft ?? 1) - 1),
                },
            };
        default:
            return state;
    }
}

export function WorkshopProvider({ children }) {
    const fetchList = useCallback(() => fetchWorkshops(), []);
    const { data: workshops, isLoading: listLoading, error: listError, retry: retryList } = useAsync(fetchList);
    const [detailCache, dispatch] = useReducer(detailCacheReducer, {});

    const loadWorkshop = useCallback(
        async (id) => {
            if (detailCache[id]) return detailCache[id];
            const workshop = await fetchWorkshop(id);
            dispatch({ type: 'CACHE_WORKSHOP', id, workshop });
            return workshop;
        },
        [detailCache],
    );

    const submitRegistration = useCallback(async (workshopId, formData) => {
        const result = await registerForWorkshop(workshopId, formData);
        dispatch({ type: 'DECREMENT_SPOTS', id: workshopId });
        return result;
    }, []);

    const value = useMemo(
        () => ({ workshops, listLoading, listError, retryList, detailCache, loadWorkshop, submitRegistration }),
        [workshops, listLoading, listError, retryList, detailCache, loadWorkshop, submitRegistration],
    );

    return <WorkshopContext.Provider value={value}>{children}</WorkshopContext.Provider>;
}

export function useWorkshops() {
    const ctx = useContext(WorkshopContext);
    if (!ctx) throw new Error('useWorkshops must be used inside <WorkshopProvider>');
    return ctx;
}
