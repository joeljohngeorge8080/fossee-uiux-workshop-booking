import React, { useState } from 'react';
import useFormValidation from '../../hooks/useFormValidation';
import { useWorkshops } from '../../context/WorkshopContext';
import { useToast } from '../Toast/ToastContext';
import styles from './RegistrationForm.module.css';

const validateRegistration = (values) => {
    const errors = {};
    if (!values.name.trim())              errors.name = 'Full name is required.';
    else if (values.name.trim().length < 2) errors.name = 'Name must be at least 2 characters.';
    if (!values.email)                    errors.email = 'Email address is required.';
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(values.email)) errors.email = 'Please enter a valid email address.';
    if (values.phone && !/^[+\d\s\-().]{7,20}$/.test(values.phone)) errors.phone = 'Please enter a valid phone number.';
    if (!values.experienceLevel)          errors.experienceLevel = 'Please select your experience level.';
    return errors;
};

const INITIAL_STATE = { name: '', email: '', phone: '', experienceLevel: '', comments: '' };

const RegistrationForm = ({ workshopId }) => {
    const { submitRegistration } = useWorkshops();
    const { addToast } = useToast();
    const [successData, setSuccessData] = useState(null);
    const [serverError, setServerError] = useState(null);

    const submitAction = async (values) => {
        setServerError(null);
        try {
            const result = await submitRegistration(workshopId, values);
            setSuccessData(result);
            resetForm();
            addToast('Registration successful! Check your inbox for confirmation.', 'success');
        } catch (err) {
            const msg = err.message ?? 'Registration failed. Please try again.';
            setServerError(msg);
            addToast(msg, 'error');
            throw err;
        }
    };

    const { values, errors, touched, isSubmitting, handleChange, handleBlur, handleSubmit, resetForm } =
        useFormValidation(INITIAL_STATE, validateRegistration);

    if (successData) {
        return (
            <div className={styles.successMessage} role="alert" aria-live="polite">
                <div className={styles.successIcon} aria-hidden="true">✅</div>
                <h3>You&apos;re registered!</h3>
                <p>A confirmation email is on its way to your inbox.</p>
                {successData.confirmationId && (
                    <p className={styles.confirmationId}>
                        Confirmation ID: <strong>{successData.confirmationId}</strong>
                    </p>
                )}
                <button type="button" className={styles.submitBtn} onClick={() => setSuccessData(null)}>
                    Register Another Person
                </button>
            </div>
        );
    }

    const field = (name, label, type = 'text', required = true) => (
        <div className={styles.formGroup}>
            <label htmlFor={name} className={styles.label}>
                {label}{' '}
                {required
                    ? <span className={styles.required} aria-hidden="true">*</span>
                    : <span className={styles.optional}>(optional)</span>}
            </label>
            <input
                id={name} name={name} type={type}
                value={values[name]}
                onChange={handleChange}
                onBlur={handleBlur}
                className={`${styles.input} ${touched[name] && errors[name] ? styles.inputError : ''}`}
                aria-required={required}
                aria-invalid={!!(touched[name] && errors[name])}
                aria-describedby={touched[name] && errors[name] ? `${name}-error` : undefined}
                autoComplete={name === 'phone' ? 'tel' : name}
                disabled={isSubmitting}
            />
            {touched[name] && errors[name] && (
                <span id={`${name}-error`} className={styles.errorMessage} role="alert">{errors[name]}</span>
            )}
        </div>
    );

    return (
        <form className={styles.formContainer} onSubmit={(e) => handleSubmit(e, submitAction)} noValidate>
            <h3 className={styles.formTitle}>Secure Your Spot</h3>

            {serverError && (
                <div className={styles.serverError} role="alert" aria-live="assertive">{serverError}</div>
            )}

            {field('name',  'Full Name')}
            {field('email', 'Email Address', 'email')}
            {field('phone', 'Phone Number',  'tel', false)}

            <div className={styles.formGroup}>
                <label htmlFor="experienceLevel" className={styles.label}>
                    Experience Level <span className={styles.required} aria-hidden="true">*</span>
                </label>
                <select
                    id="experienceLevel" name="experienceLevel"
                    value={values.experienceLevel}
                    onChange={handleChange}
                    onBlur={handleBlur}
                    className={`${styles.select} ${touched.experienceLevel && errors.experienceLevel ? styles.inputError : ''}`}
                    aria-required="true"
                    aria-invalid={!!(touched.experienceLevel && errors.experienceLevel)}
                    aria-describedby={touched.experienceLevel && errors.experienceLevel ? 'experienceLevel-error' : undefined}
                    disabled={isSubmitting}
                >
                    <option value="" disabled>Select your level</option>
                    <option value="beginner">Beginner</option>
                    <option value="intermediate">Intermediate</option>
                    <option value="advanced">Advanced</option>
                </select>
                {touched.experienceLevel && errors.experienceLevel && (
                    <span id="experienceLevel-error" className={styles.errorMessage} role="alert">
                        {errors.experienceLevel}
                    </span>
                )}
            </div>

            <div className={styles.formGroup}>
                <label htmlFor="comments" className={styles.label}>
                    Questions / Comments <span className={styles.optional}>(optional)</span>
                </label>
                <textarea
                    id="comments" name="comments" rows={4}
                    value={values.comments}
                    onChange={handleChange}
                    className={styles.textarea}
                    disabled={isSubmitting}
                />
            </div>

            <button type="submit" className={styles.submitBtn} disabled={isSubmitting} aria-busy={isSubmitting}>
                {isSubmitting ? 'Processing…' : 'Complete Registration'}
            </button>
        </form>
    );
};

export default RegistrationForm;
