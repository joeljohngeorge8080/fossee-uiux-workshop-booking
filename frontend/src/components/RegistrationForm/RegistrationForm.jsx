import React, { useState, useCallback, useMemo } from 'react';
import useFormValidation from '../../hooks/useFormValidation';
import styles from './RegistrationForm.module.css';

const INITIAL_STATE = {
    name: '',
    email: '',
    phone: '',
    experienceLevel: '',
    comments: '',
};

// Kept outside component — pure function, no need to recreate on each render
const validateRegistration = (values) => {
    const errors = {};
    if (!values.name.trim()) errors.name = 'Your full name is required.';
    if (!values.email) {
        errors.email = 'Email address is required.';
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(values.email)) {
        errors.email = 'Please enter a valid email address.';
    }
    if (!values.experienceLevel) errors.experienceLevel = 'Please select your experience level.';
    return errors;
};

const RegistrationForm = ({ workshopId, workshopTitle }) => {
    const [isSuccess, setIsSuccess] = useState(false);

    // Memoize so useFormValidation's deps stay stable across renders
    const validate = useMemo(() => validateRegistration, []);

    const submitAction = useCallback(async (values) => {
        // Replace with: await fetch(`/api/workshops/${workshopId}/register/`, {...})
        return new Promise(resolve => {
            setTimeout(() => {
                setIsSuccess(true);
                resetForm();
                resolve();
            }, 1000);
        });
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [workshopId]);

    const {
        values, errors, touched, isSubmitting,
        handleChange, handleBlur, handleSubmit, resetForm,
    } = useFormValidation(INITIAL_STATE, validate);

    if (isSuccess) {
        return (
            <div className={styles.successPanel} role="alert" aria-live="polite">
                <span className={styles.successIcon} aria-hidden="true">✓</span>
                <h3>You're registered!</h3>
                <p>Check your inbox — a confirmation email is on its way.</p>
                <button
                    type="button"
                    className={styles.secondaryBtn}
                    onClick={() => setIsSuccess(false)}
                >
                    Register someone else
                </button>
            </div>
        );
    }

    return (
        <form
            className={styles.form}
            onSubmit={(e) => handleSubmit(e, submitAction)}
            noValidate
            aria-label={workshopTitle ? `Register for ${workshopTitle}` : 'Workshop registration'}
        >
            <h3 className={styles.formTitle}>Secure Your Spot</h3>
            <p className={styles.formHint}>
                Fields marked <span aria-hidden="true" className={styles.req}>*</span>
                <span className={styles.srOnly}> with an asterisk</span> are required.
            </p>

            {/* Full Name */}
            <div className={styles.fieldGroup}>
                <label htmlFor="reg-name" className={styles.label}>
                    Full Name <span className={styles.req} aria-hidden="true">*</span>
                </label>
                <input
                    id="reg-name"
                    name="name"
                    type="text"
                    value={values.name}
                    onChange={handleChange}
                    onBlur={handleBlur}
                    className={`${styles.input} ${touched.name && errors.name ? styles.inputInvalid : ''}`}
                    aria-invalid={!!(touched.name && errors.name)}
                    aria-describedby={touched.name && errors.name ? 'name-err' : undefined}
                    autoComplete="name"
                    placeholder="e.g. Priya Sharma"
                />
                {touched.name && errors.name && (
                    <span id="name-err" className={styles.fieldError} role="alert">{errors.name}</span>
                )}
            </div>

            {/* Email */}
            <div className={styles.fieldGroup}>
                <label htmlFor="reg-email" className={styles.label}>
                    Email Address <span className={styles.req} aria-hidden="true">*</span>
                </label>
                <input
                    id="reg-email"
                    name="email"
                    type="email"
                    value={values.email}
                    onChange={handleChange}
                    onBlur={handleBlur}
                    className={`${styles.input} ${touched.email && errors.email ? styles.inputInvalid : ''}`}
                    aria-invalid={!!(touched.email && errors.email)}
                    aria-describedby={touched.email && errors.email ? 'email-err' : undefined}
                    autoComplete="email"
                    placeholder="you@example.com"
                />
                {touched.email && errors.email && (
                    <span id="email-err" className={styles.fieldError} role="alert">{errors.email}</span>
                )}
            </div>

            {/* Phone — optional, no validation */}
            <div className={styles.fieldGroup}>
                <label htmlFor="reg-phone" className={styles.label}>
                    Phone <span className={styles.optional}>(optional)</span>
                </label>
                <input
                    id="reg-phone"
                    name="phone"
                    type="tel"
                    value={values.phone}
                    onChange={handleChange}
                    onBlur={handleBlur}
                    className={styles.input}
                    autoComplete="tel"
                    placeholder="+91 98765 43210"
                />
            </div>

            {/* Experience Level */}
            <div className={styles.fieldGroup}>
                <label htmlFor="reg-level" className={styles.label}>
                    Experience Level <span className={styles.req} aria-hidden="true">*</span>
                </label>
                <select
                    id="reg-level"
                    name="experienceLevel"
                    value={values.experienceLevel}
                    onChange={handleChange}
                    onBlur={handleBlur}
                    className={`${styles.select} ${touched.experienceLevel && errors.experienceLevel ? styles.inputInvalid : ''}`}
                    aria-invalid={!!(touched.experienceLevel && errors.experienceLevel)}
                    aria-describedby={touched.experienceLevel && errors.experienceLevel ? 'level-err' : undefined}
                >
                    <option value="" disabled>Select your level</option>
                    <option value="beginner">Beginner</option>
                    <option value="intermediate">Intermediate</option>
                    <option value="advanced">Advanced</option>
                </select>
                {touched.experienceLevel && errors.experienceLevel && (
                    <span id="level-err" className={styles.fieldError} role="alert">{errors.experienceLevel}</span>
                )}
            </div>

            {/* Comments */}
            <div className={styles.fieldGroup}>
                <label htmlFor="reg-comments" className={styles.label}>
                    Questions or Comments <span className={styles.optional}>(optional)</span>
                </label>
                <textarea
                    id="reg-comments"
                    name="comments"
                    rows={4}
                    value={values.comments}
                    onChange={handleChange}
                    onBlur={handleBlur}
                    className={styles.textarea}
                    placeholder="Anything you'd like us to know beforehand..."
                />
            </div>

            <button
                type="submit"
                className={styles.submitBtn}
                disabled={isSubmitting}
                aria-busy={isSubmitting}
            >
                {isSubmitting ? (
                    <><span className={styles.spinner} aria-hidden="true" /> Processing…</>
                ) : (
                    'Complete Registration'
                )}
            </button>
        </form>
    );
};

export default RegistrationForm;
