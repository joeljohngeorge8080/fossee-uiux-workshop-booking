import React, { useState } from 'react';
import useFormValidation from '../../hooks/useFormValidation';
import styles from './RegistrationForm.module.css';

const validate = (v) => {
  const e = {};
  if (!v.name.trim())           e.name = 'Full name is required.';
  else if (v.name.trim().length < 2) e.name = 'Name must be at least 2 characters.';
  if (!v.email)                 e.email = 'Email is required.';
  else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.email)) e.email = 'Enter a valid email address.';
  if (v.phone && !/^[+\d\s\-().]{7,20}$/.test(v.phone)) e.phone = 'Enter a valid phone number.';
  if (!v.experienceLevel)       e.experienceLevel = 'Please select your experience level.';
  return e;
};

const INIT = { name: '', email: '', phone: '', experienceLevel: '', comments: '' };

const RegistrationForm = ({ workshopId, disabled = false }) => {
  const [success, setSuccess] = useState(null);

  const submitFn = async (values) => {
    await new Promise(r => setTimeout(r, 900));
    console.log('Registering for workshop', workshopId, values);
    setSuccess({ confirmationId: `WRK-${Date.now()}` });
    resetForm();
  };

  const { values, errors, touched, isSubmitting, handleChange, handleBlur, handleSubmit, resetForm } =
    useFormValidation(INIT, validate);

  if (success) return (
    <div className={styles.success} role="alert">
      <div className={styles.successIcon}>✅</div>
      <h3>You're registered!</h3>
      <p>A confirmation email is on its way.</p>
      <p className={styles.confirmId}>ID: <code>{success.confirmationId}</code></p>
      <button className={styles.btn} onClick={() => setSuccess(null)}>Register another person</button>
    </div>
  );

  if (disabled) return (
    <div className={styles.card}>
      <div className={styles.cardHead}><h3 className={styles.formTitle}>Registration Closed</h3></div>
      <p className={styles.soldMsg}>This workshop is fully booked. Check other upcoming workshops.</p>
    </div>
  );

  return (
    <form className={styles.card} onSubmit={(e) => handleSubmit(e, submitFn)} noValidate>
      <div className={styles.cardHead}>
        <h3 className={styles.formTitle}>Secure Your Spot</h3>
      </div>

      <div className={styles.fields}>
        {/* Name */}
        <div className={styles.field}>
          <label htmlFor="name" className={styles.label}>
            Full Name <span className={styles.req}>*</span>
          </label>
          <input
            id="name" name="name" type="text" autoComplete="name"
            value={values.name} onChange={handleChange} onBlur={handleBlur}
            disabled={isSubmitting}
            className={`${styles.input} ${touched.name && errors.name ? styles.inputErr : ''}`}
            aria-required="true" aria-invalid={!!(touched.name && errors.name)}
            aria-describedby={touched.name && errors.name ? 'name-err' : undefined}
          />
          {touched.name && errors.name && <span id="name-err" className={styles.errMsg} role="alert">{errors.name}</span>}
        </div>

        {/* Email */}
        <div className={styles.field}>
          <label htmlFor="email" className={styles.label}>
            Email Address <span className={styles.req}>*</span>
          </label>
          <input
            id="email" name="email" type="email" autoComplete="email"
            value={values.email} onChange={handleChange} onBlur={handleBlur}
            disabled={isSubmitting}
            className={`${styles.input} ${touched.email && errors.email ? styles.inputErr : ''}`}
            aria-required="true" aria-invalid={!!(touched.email && errors.email)}
            aria-describedby={touched.email && errors.email ? 'email-err' : undefined}
          />
          {touched.email && errors.email && <span id="email-err" className={styles.errMsg} role="alert">{errors.email}</span>}
        </div>

        {/* Phone */}
        <div className={styles.field}>
          <label htmlFor="phone" className={styles.label}>
            Phone <span className={styles.hint}>(optional)</span>
          </label>
          <input
            id="phone" name="phone" type="tel" autoComplete="tel"
            value={values.phone} onChange={handleChange} onBlur={handleBlur}
            disabled={isSubmitting}
            className={`${styles.input} ${touched.phone && errors.phone ? styles.inputErr : ''}`}
          />
          {touched.phone && errors.phone && <span className={styles.errMsg} role="alert">{errors.phone}</span>}
        </div>

        {/* Experience */}
        <div className={styles.field}>
          <label htmlFor="experienceLevel" className={styles.label}>
            Experience Level <span className={styles.req}>*</span>
          </label>
          <select
            id="experienceLevel" name="experienceLevel"
            value={values.experienceLevel} onChange={handleChange} onBlur={handleBlur}
            disabled={isSubmitting}
            className={`${styles.input} ${styles.select} ${touched.experienceLevel && errors.experienceLevel ? styles.inputErr : ''}`}
            aria-required="true"
          >
            <option value="" disabled>Select your level</option>
            <option value="beginner">Beginner</option>
            <option value="intermediate">Intermediate</option>
            <option value="advanced">Advanced</option>
          </select>
          {touched.experienceLevel && errors.experienceLevel && (
            <span className={styles.errMsg} role="alert">{errors.experienceLevel}</span>
          )}
        </div>

        {/* Comments */}
        <div className={styles.field}>
          <label htmlFor="comments" className={styles.label}>
            Questions / Comments <span className={styles.hint}>(optional)</span>
          </label>
          <textarea
            id="comments" name="comments" rows={3}
            value={values.comments} onChange={handleChange}
            className={`${styles.input} ${styles.textarea}`}
            disabled={isSubmitting}
          />
        </div>

        <button type="submit" className={`${styles.btn} ${styles.submitBtn}`} disabled={isSubmitting} aria-busy={isSubmitting}>
          {isSubmitting
            ? <><span className={styles.btnSpinner} aria-hidden="true" /> Processing…</>
            : 'Complete Registration'}
        </button>
      </div>
    </form>
  );
};

export default RegistrationForm;
