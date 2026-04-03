import React, { useState } from 'react';
import useFormValidation from '../../hooks/useFormValidation';
import styles from './RegistrationForm.module.css';

/* ── Validation ── */
const validate = (v) => {
  const e = {};
  if (!v.name.trim())         e.name = 'Full name is required.';
  else if (v.name.trim().length < 2) e.name = 'Name must be at least 2 characters.';

  if (!v.email)               e.email = 'Email is required.';
  else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.email))
                              e.email = 'Please enter a valid email.';

  if (v.phone && !/^[+\d\s\-().]{7,20}$/.test(v.phone))
                              e.phone = 'Please enter a valid phone number.';

  if (!v.experienceLevel)     e.experienceLevel = 'Please select your experience level.';
  return e;
};

const INIT = { name:'', email:'', phone:'', experienceLevel:'', comments:'' };

/* ── Component ── */
const RegistrationForm = ({ workshopId, disabled = false }) => {
  const [success,     setSuccess]     = useState(null);   // holds confirmation data
  const [serverError, setServerError] = useState('');

  const submitFn = async (values) => {
    setServerError('');
    /* Simulated API call — replace with real fetch when backend is ready */
    await new Promise(r => setTimeout(r, 900));
    console.log('Registering for workshop', workshopId, values);
    setSuccess({ confirmationId: `WRK-${Date.now()}` });
    resetForm();
  };

  const { values, errors, touched, isSubmitting, handleChange, handleBlur, handleSubmit, resetForm } =
    useFormValidation(INIT, validate);

  /* ── Success state ── */
  if (success) return (
    <div className={styles.success} role="alert" aria-live="polite">
      <div className={styles.successIcon} aria-hidden="true">✅</div>
      <h3>You're registered!</h3>
      <p>A confirmation email is on its way to your inbox.</p>
      {success.confirmationId && (
        <p className={styles.confirmId}>
          Confirmation: <code>{success.confirmationId}</code>
        </p>
      )}
      <button className={styles.btn} onClick={() => setSuccess(null)}>
        Register another person
      </button>
    </div>
  );

  /* ── Disabled (sold-out) state ── */
  if (disabled) return (
    <div className={styles.card}>
      <div className={styles.cardHeader}>
        <h3 className={styles.formTitle}>Registration Closed</h3>
      </div>
      <p className={styles.soldOutMsg}>
        This workshop is fully booked. Join the waitlist or check other upcoming workshops.
      </p>
    </div>
  );

  /* ── Form ── */
  return (
    <form className={styles.card} onSubmit={(e) => handleSubmit(e, submitFn)} noValidate>
      <div className={styles.cardHeader}>
        <h3 className={styles.formTitle}>Secure Your Spot</h3>
      </div>

      <div className={styles.fields}>
        {/* Server-level error */}
        {serverError && (
          <div className={styles.serverError} role="alert">{serverError}</div>
        )}

        {/* Full Name */}
        <Field id="name" label="Full Name" required
          error={touched.name && errors.name}>
          <input
            id="name" name="name" type="text"
            value={values.name}
            onChange={handleChange} onBlur={handleBlur}
            className={`${styles.input} ${touched.name && errors.name ? styles.inputErr : ''}`}
            autoComplete="name" disabled={isSubmitting}
            aria-required="true"
            aria-invalid={!!(touched.name && errors.name)}
            aria-describedby={touched.name && errors.name ? 'name-err' : undefined}
          />
          {touched.name && errors.name && <span id="name-err" className={styles.errMsg} role="alert">{errors.name}</span>}
        </Field>

        {/* Email */}
        <Field id="email" label="Email Address" required
          error={touched.email && errors.email}>
          <input
            id="email" name="email" type="email"
            value={values.email}
            onChange={handleChange} onBlur={handleBlur}
            className={`${styles.input} ${touched.email && errors.email ? styles.inputErr : ''}`}
            autoComplete="email" disabled={isSubmitting}
            aria-required="true"
            aria-invalid={!!(touched.email && errors.email)}
            aria-describedby={touched.email && errors.email ? 'email-err' : undefined}
          />
          {touched.email && errors.email && <span id="email-err" className={styles.errMsg} role="alert">{errors.email}</span>}
        </Field>

        {/* Phone */}
        <Field id="phone" label="Phone Number" hint="Optional">
          <input
            id="phone" name="phone" type="tel"
            value={values.phone}
            onChange={handleChange} onBlur={handleBlur}
            className={`${styles.input} ${touched.phone && errors.phone ? styles.inputErr : ''}`}
            autoComplete="tel" disabled={isSubmitting}
            aria-describedby={touched.phone && errors.phone ? 'phone-err' : undefined}
          />
          {touched.phone && errors.phone && <span id="phone-err" className={styles.errMsg} role="alert">{errors.phone}</span>}
        </Field>

        {/* Experience Level */}
        <Field id="experienceLevel" label="Experience Level" required
          error={touched.experienceLevel && errors.experienceLevel}>
          <select
            id="experienceLevel" name="experienceLevel"
            value={values.experienceLevel}
            onChange={handleChange} onBlur={handleBlur}
            className={`${styles.input} ${styles.select} ${touched.experienceLevel && errors.experienceLevel ? styles.inputErr : ''}`}
            disabled={isSubmitting}
            aria-required="true"
            aria-invalid={!!(touched.experienceLevel && errors.experienceLevel)}
            aria-describedby={touched.experienceLevel && errors.experienceLevel ? 'exp-err' : undefined}
          >
            <option value="" disabled>Select your level</option>
            <option value="beginner">Beginner</option>
            <option value="intermediate">Intermediate</option>
            <option value="advanced">Advanced</option>
          </select>
          {touched.experienceLevel && errors.experienceLevel &&
            <span id="exp-err" className={styles.errMsg} role="alert">{errors.experienceLevel}</span>}
        </Field>

        {/* Comments */}
        <Field id="comments" label="Questions / Comments" hint="Optional">
          <textarea
            id="comments" name="comments" rows={3}
            value={values.comments}
            onChange={handleChange}
            className={`${styles.input} ${styles.textarea}`}
            disabled={isSubmitting}
          />
        </Field>

        {/* Submit */}
        <button
          type="submit"
          className={`${styles.btn} ${styles.submitBtn}`}
          disabled={isSubmitting}
          aria-busy={isSubmitting}
        >
          {isSubmitting ? <><span className={styles.btnSpinner} aria-hidden="true"/>Processing…</> : 'Complete Registration'}
        </button>
      </div>
    </form>
  );
};

/* ── Field wrapper (label + slot + error) ── */
const Field = ({ id, label, required, hint, error, children }) => (
  <div className={`${error ? 'field-error' : ''}`} style={{ display:'flex', flexDirection:'column', gap:'.35rem' }}>
    <label htmlFor={id} style={{ fontSize:'var(--text-sm)', fontWeight:600, color:'var(--color-text)', display:'flex', gap:'.3rem', alignItems:'baseline' }}>
      {label}
      {required && <span aria-hidden="true" style={{ color:'var(--color-error)' }}>*</span>}
      {hint     && <span style={{ color:'var(--color-text-light)', fontWeight:400, fontSize:'var(--text-xs)' }}>({hint})</span>}
    </label>
    {children}
  </div>
);

export default RegistrationForm;
