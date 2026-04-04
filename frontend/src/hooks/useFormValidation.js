import { useState, useCallback, useRef } from 'react';

const useFormValidation = (initialState, validate) => {
  const [values, setValues] = useState(initialState);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const validateRef = useRef(validate);
  // eslint-disable-next-line react-hooks/refs
  validateRef.current = validate;
  const valuesRef = useRef(values);
  // eslint-disable-next-line react-hooks/refs
  valuesRef.current = values;

  const handleChange = useCallback((e) => {
    const { name, value } = e.target;
    setValues(prev => {
      const next = { ...prev, [name]: value };
      setErrors(err => ({ ...err, [name]: validateRef.current(next)[name] ?? null }));
      return next;
    });
  }, []);

  const handleBlur = useCallback((e) => {
    const { name } = e.target;
    setTouched(prev => {
      if (prev[name]) return prev;
      setErrors(err => ({ ...err, [name]: validateRef.current(valuesRef.current)[name] ?? null }));
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
