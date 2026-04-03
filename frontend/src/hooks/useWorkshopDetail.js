import { useState, useEffect, useCallback } from 'react';
import { useWorkshops } from '../context/WorkshopContext';

function useWorkshopDetail(id) {
    const { loadWorkshop } = useWorkshops();
    const [workshop, setWorkshop] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState(null);

    const load = useCallback(async () => {
        setIsLoading(true);
        setError(null);
        try {
            const data = await loadWorkshop(id);
            setWorkshop(data);
        } catch (err) {
            setError(err.message ?? 'Could not load workshop details.');
        } finally {
            setIsLoading(false);
        }
    }, [id, loadWorkshop]);

    useEffect(() => { load(); }, [load]);

    return { workshop, isLoading, error, retry: load };
}

export default useWorkshopDetail;
