import { useState, useCallback, useRef } from 'react';

const useFormValidation = (initialState, validate) => {
    const [values, setValues] = useState(initialState);
    const [errors, setErrors] = useState({});
    const [touched, setTouched] = useState({});
    const [isSubmitting, setIsSubmitting] = useState(false);

    const validateRef = useRef(validate);
    validateRef.current = validate;

    const valuesRef = useRef(values);
    valuesRef.current = values;

    const handleChange = useCallback((e) => {
        const { name, value } = e.target;
        setValues((prev) => {
            const next = { ...prev, [name]: value };
            const fieldErrors = validateRef.current(next);
            setErrors((prevErrors) => ({ ...prevErrors, [name]: fieldErrors[name] ?? null }));
            return next;
        });
    }, []);

    const handleBlur = useCallback((e) => {
        const { name } = e.target;
        setTouched((prev) => {
            if (prev[name]) return prev;
            const fieldErrors = validateRef.current(valuesRef.current);
            setErrors((prevErrors) => ({ ...prevErrors, [name]: fieldErrors[name] ?? null }));
            return { ...prev, [name]: true };
        });
    }, []);

    const handleSubmit = useCallback((e, submitAction) => {
        e.preventDefault();
        const currentValues = valuesRef.current;
        const validationErrors = validateRef.current(currentValues);
        setErrors(validationErrors);
        setTouched(Object.keys(currentValues).reduce((acc, k) => ({ ...acc, [k]: true }), {}));
        if (Object.keys(validationErrors).length === 0) {
            setIsSubmitting(true);
            submitAction(currentValues).finally(() => setIsSubmitting(false));
        }
    }, []);

    const resetForm = useCallback(() => {
        setValues(initialState);
        setErrors({});
        setTouched({});
    }, [initialState]);

    return { values, errors, touched, isSubmitting, handleChange, handleBlur, handleSubmit, resetForm };
};

export default useFormValidation;
