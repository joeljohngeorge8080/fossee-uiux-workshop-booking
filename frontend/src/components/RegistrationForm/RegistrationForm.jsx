import React, { useState } from 'react';
import useFormValidation from '../../hooks/useFormValidation';
import styles from './RegistrationForm.module.css';

const validateRegistration = (values) => {
    let errors = {};

    if (!values.name.trim()) {
        errors.name = 'Name is required';
    }

    if (!values.email) {
        errors.email = 'Email address is required';
    } else if (!/\S+@\S+\.\S+/.test(values.email)) {
        errors.email = 'Email address is invalid';
    }

    if (!values.experienceLevel) {
        errors.experienceLevel = 'Please select your experience level';
    }

    return errors;
};

const RegistrationForm = ({ workshopId }) => {
    const [isSuccess, setIsSuccess] = useState(false);

    const initialState = {
        name: '',
        email: '',
        phone: '',
        experienceLevel: '',
        comments: ''
    };

    const submitAction = async (values) => {
        // Simulate API call
        return new Promise(resolve => {
            setTimeout(() => {
                console.log(`Submitting registration for workshop ${workshopId}`, values);
                setIsSuccess(true);
                resetForm();
                resolve();
            }, 1000);
        });
    };

    const {
        values,
        errors,
        isSubmitting,
        handleChange,
        handleSubmit,
        resetForm
    } = useFormValidation(initialState, validateRegistration);

    if (isSuccess) {
        return (
            <div className={styles.successMessage} role="alert" aria-live="polite">
                <h3>Registration Successful!</h3>
                <p>Thank you for registering. We've sent a confirmation email to your inbox.</p>
                <button type="button" className={styles.submitBtn} onClick={() => setIsSuccess(false)}>
                    Register Another
                </button>
            </div>
        );
    }

    return (
        <form
            className={styles.formContainer}
            onSubmit={(e) => handleSubmit(e, submitAction)}
            noValidate
        >
            <h3 className={styles.formTitle}>Secure Your Spot</h3>

            <div className={styles.formGroup}>
                <label htmlFor="name" className={styles.label}>Full Name <span className={styles.required}>*</span></label>
                <input
                    id="name"
                    name="name"
                    type="text"
                    value={values.name}
                    onChange={handleChange}
                    className={`${styles.input} ${errors.name ? styles.inputError : ''}`}
                    aria-invalid={errors.name ? "true" : "false"}
                    aria-describedby={errors.name ? "name-error" : undefined}
                    autoComplete="name"
                />
                {errors.name && <span id="name-error" className={styles.errorMessage}>{errors.name}</span>}
            </div>

            <div className={styles.formGroup}>
                <label htmlFor="email" className={styles.label}>Email Address <span className={styles.required}>*</span></label>
                <input
                    id="email"
                    name="email"
                    type="email"
                    value={values.email}
                    onChange={handleChange}
                    className={`${styles.input} ${errors.email ? styles.inputError : ''}`}
                    aria-invalid={errors.email ? "true" : "false"}
                    aria-describedby={errors.email ? "email-error" : undefined}
                    autoComplete="email"
                />
                {errors.email && <span id="email-error" className={styles.errorMessage}>{errors.email}</span>}
            </div>

            <div className={styles.formGroup}>
                <label htmlFor="phone" className={styles.label}>Phone Number</label>
                <input
                    id="phone"
                    name="phone"
                    type="tel"
                    value={values.phone}
                    onChange={handleChange}
                    className={styles.input}
                    autoComplete="tel"
                />
            </div>

            <div className={styles.formGroup}>
                <label htmlFor="experienceLevel" className={styles.label}>Experience Level <span className={styles.required}>*</span></label>
                <select
                    id="experienceLevel"
                    name="experienceLevel"
                    value={values.experienceLevel}
                    onChange={handleChange}
                    className={`${styles.select} ${errors.experienceLevel ? styles.inputError : ''}`}
                    aria-invalid={errors.experienceLevel ? "true" : "false"}
                    aria-describedby={errors.experienceLevel ? "experienceLevel-error" : undefined}
                >
                    <option value="" disabled>Select your level</option>
                    <option value="beginner">Beginner</option>
                    <option value="intermediate">Intermediate</option>
                    <option value="advanced">Advanced</option>
                </select>
                {errors.experienceLevel && <span id="experienceLevel-error" className={styles.errorMessage}>{errors.experienceLevel}</span>}
            </div>

            <div className={styles.formGroup}>
                <label htmlFor="comments" className={styles.label}>Additional Questions/Comments</label>
                <textarea
                    id="comments"
                    name="comments"
                    rows="4"
                    value={values.comments}
                    onChange={handleChange}
                    className={styles.textarea}
                ></textarea>
            </div>

            <button
                type="submit"
                className={styles.submitBtn}
                disabled={isSubmitting}
                aria-busy={isSubmitting}
            >
                {isSubmitting ? 'Processing...' : 'Complete Registration'}
            </button>
        </form>
    );
};

export default RegistrationForm;
