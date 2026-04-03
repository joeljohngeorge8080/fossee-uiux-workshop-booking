import { useState, useCallback, useRef } from 'react';

/**
 * useFormValidation - Handles form state, submission, and validation.
 * Supports both on-submit and real-time on-blur validation.
 *
 * @param {object} initialState - Initial form field values
 * @param {function} validate - Function that returns an errors object
 */
const useFormValidation = (initialState, validate) => {
    const [values, setValues] = useState(initialState);
    const [errors, setErrors] = useState({});
    const [touched, setTouched] = useState({});
    const [isSubmitting, setIsSubmitting] = useState(false);

    // Keep validate stable in refs to avoid stale closure issues
    const validateRef = useRef(validate);
    validateRef.current = validate;

    // Memoized handler: updates field value and clears its error (if any)
    const handleChange = useCallback((e) => {
        const { name, value } = e.target;
        setValues(prev => ({ ...prev, [name]: value }));

        // If this field was already touched, re-validate it in real time
        setTouched(prev => {
            if (!prev[name]) return prev;
            // Run full validate and only surface this field's updated error
            const next = validateRef.current({ ...values, [name]: value });
            setErrors(prevErrors => ({ ...prevErrors, [name]: next[name] || null }));
            return prev;
        });
    }, [values]);

    // Mark field as touched on blur so real-time validation activates
    const handleBlur = useCallback((e) => {
        const { name } = e.target;
        setTouched(prev => {
            if (prev[name]) return prev;
            const next = { ...prev, [name]: true };
            // Validate this field immediately on first blur
            const fieldErrors = validateRef.current(values);
            setErrors(prevErrors => ({ ...prevErrors, [name]: fieldErrors[name] || null }));
            return next;
        });
    }, [values]);

    const handleSubmit = useCallback((e, submitAction) => {
        e.preventDefault();
        const validationErrors = validateRef.current(values);
        setErrors(validationErrors);
        // Mark all fields as touched so errors show
        const allTouched = Object.keys(values).reduce((acc, k) => ({ ...acc, [k]: true }), {});
        setTouched(allTouched);

        if (Object.keys(validationErrors).length === 0) {
            setIsSubmitting(true);
            submitAction(values).finally(() => setIsSubmitting(false));
        }
    }, [values]);

    const resetForm = useCallback(() => {
        setValues(initialState);
        setErrors({});
        setTouched({});
    }, [initialState]);

    return { values, errors, touched, isSubmitting, handleChange, handleBlur, handleSubmit, resetForm };
};

export default useFormValidation;
