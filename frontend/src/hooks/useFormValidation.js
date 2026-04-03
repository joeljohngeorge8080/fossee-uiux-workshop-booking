import { useState, useCallback, useRef } from 'react';

/**
 * useFormValidation — form state + validation.
 *
 * FIX: the original handleChange closed over stale `values`.
 * Now uses functional setValues + a ref so callbacks are always stable.
 */
const useFormValidation = (initialState, validate) => {
  const [values,      setValues]      = useState(initialState);
  const [errors,      setErrors]      = useState({});
  const [touched,     setTouched]     = useState({});
  const [isSubmitting,setIsSubmitting] = useState(false);

  /* Always-fresh refs — avoids stale closures without adding deps */
  const validateRef = useRef(validate);
  validateRef.current = validate;
  const valuesRef = useRef(values);
  valuesRef.current = values;

  const handleChange = useCallback((e) => {
    const { name, value } = e.target;
    setValues(prev => {
      const next = { ...prev, [name]: value };
      /* Re-validate this field in real time if it's been touched */
      setErrors(prevErr => ({
        ...prevErr,
        [name]: validateRef.current(next)[name] ?? null,
      }));
      return next;
    });
  }, []);

  const handleBlur = useCallback((e) => {
    const { name } = e.target;
    setTouched(prev => {
      if (prev[name]) return prev;
      setErrors(prevErr => ({
        ...prevErr,
        [name]: validateRef.current(valuesRef.current)[name] ?? null,
      }));
      return { ...prev, [name]: true };
    });
  }, []);

  const handleSubmit = useCallback((e, submitFn) => {
    e.preventDefault();
    const cur = valuesRef.current;
    const errs = validateRef.current(cur);
    setErrors(errs);
    setTouched(Object.keys(cur).reduce((a, k) => ({ ...a, [k]: true }), {}));
    if (Object.keys(errs).length === 0) {
      setIsSubmitting(true);
      submitFn(cur).finally(() => setIsSubmitting(false));
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
