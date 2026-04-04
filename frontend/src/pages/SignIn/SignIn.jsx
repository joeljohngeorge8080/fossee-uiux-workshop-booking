import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import styles from './SignIn.module.css';

const SignIn = () => {
  const [tab,       setTab]       = useState('signin'); /* 'signin' | 'signup' */
  const [email,     setEmail]     = useState('');
  const [password,  setPassword]  = useState('');
  const [name,      setName]      = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [loading,   setLoading]   = useState(false);
  const [error,     setError]     = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (!email || !password) { setError('Please fill in all required fields.'); return; }
    if (tab === 'signup' && !name) { setError('Please enter your name.'); return; }

    setLoading(true);
    /* Simulated auth — replace with real API call */
    await new Promise(r => setTimeout(r, 900));
    setLoading(false);
    setSubmitted(true);
  };

  if (submitted) return (
    <div className={styles.center}>
      <div className={styles.successIcon}>🎉</div>
      <h2>{tab === 'signup' ? 'Account created!' : 'Welcome back!'}</h2>
      <p>{tab === 'signup' ? `Hi ${name}, your account is ready.` : `Signed in as ${email}.`}</p>
      <Link to="/" className={styles.primaryBtn}>Browse Workshops →</Link>
    </div>
  );

  return (
    <div className={styles.page}>
      <div className={styles.card}>

        {/* ── Logo ── */}
        <div className={styles.logoWrap}>
          <Link to="/" className={styles.logo}>Learn<span className={styles.accent}>Forge</span></Link>
          <p className={styles.tagline}>Expert-led workshops for curious minds</p>
        </div>

        {/* ── Tabs ── */}
        <div className={styles.tabs} role="tablist">
          <button
            role="tab"
            className={`${styles.tab} ${tab === 'signin' ? styles.tabActive : ''}`}
            onClick={() => { setTab('signin'); setError(''); }}
            aria-selected={tab === 'signin'}
          >
            Sign In
          </button>
          <button
            role="tab"
            className={`${styles.tab} ${tab === 'signup' ? styles.tabActive : ''}`}
            onClick={() => { setTab('signup'); setError(''); }}
            aria-selected={tab === 'signup'}
          >
            Create Account
          </button>
        </div>

        {/* ── Form ── */}
        <form onSubmit={handleSubmit} className={styles.form} noValidate>
          {error && <div className={styles.errorBanner} role="alert">{error}</div>}

          {tab === 'signup' && (
            <div className={styles.field}>
              <label htmlFor="name" className={styles.label}>Full Name <span className={styles.req}>*</span></label>
              <input
                id="name" type="text" autoComplete="name" required
                value={name} onChange={e => setName(e.target.value)}
                className={styles.input}
                placeholder="Jane Doe"
                disabled={loading}
              />
            </div>
          )}

          <div className={styles.field}>
            <label htmlFor="email" className={styles.label}>Email Address <span className={styles.req}>*</span></label>
            <input
              id="email" type="email" autoComplete="email" required
              value={email} onChange={e => setEmail(e.target.value)}
              className={styles.input}
              placeholder="you@example.com"
              disabled={loading}
            />
          </div>

          <div className={styles.field}>
            <div className={styles.passwordRow}>
              <label htmlFor="password" className={styles.label}>Password <span className={styles.req}>*</span></label>
              {tab === 'signin' && (
                <button type="button" className={styles.forgotLink}>Forgot password?</button>
              )}
            </div>
            <input
              id="password" type="password" autoComplete={tab === 'signup' ? 'new-password' : 'current-password'} required
              value={password} onChange={e => setPassword(e.target.value)}
              className={styles.input}
              placeholder={tab === 'signup' ? 'Min. 8 characters' : '••••••••'}
              disabled={loading}
            />
          </div>

          <button type="submit" className={styles.submitBtn} disabled={loading} aria-busy={loading}>
            {loading
              ? <><span className={styles.spinner} aria-hidden="true" /> {tab === 'signup' ? 'Creating account…' : 'Signing in…'}</>
              : tab === 'signup' ? 'Create Account' : 'Sign In'
            }
          </button>
        </form>

        {/* ── Divider ── */}
        <div className={styles.divider}><span>or continue with</span></div>

        {/* ── Social buttons ── */}
        <div className={styles.socialBtns}>
          <button className={styles.socialBtn} type="button" aria-label="Continue with Google">
            <svg width="18" height="18" viewBox="0 0 48 48" aria-hidden="true">
              <path fill="#FFC107" d="M43.6 20H24v8h11.3C33.6 33 29.3 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3 0 5.8 1.1 7.9 3l5.7-5.7C34.1 6.5 29.3 4 24 4 12.9 4 4 12.9 4 24s8.9 20 20 20c11 0 20-8 20-20 0-1.3-.1-2.7-.4-4z"/>
              <path fill="#FF3D00" d="M6.3 14.7l6.6 4.8C14.7 15.1 19 12 24 12c3 0 5.8 1.1 7.9 3l5.7-5.7C34.1 6.5 29.3 4 24 4 16.3 4 9.7 8.3 6.3 14.7z"/>
              <path fill="#4CAF50" d="M24 44c5.2 0 9.9-1.8 13.6-4.8l-6.3-5.2C29.4 35.6 26.8 36 24 36c-5.2 0-9.6-3-11.4-7.4l-6.6 5.1C9.6 39.6 16.3 44 24 44z"/>
              <path fill="#1976D2" d="M43.6 20H24v8h11.3c-.9 2.5-2.5 4.5-4.6 5.9l6.3 5.2C40.9 36 44 30.5 44 24c0-1.3-.1-2.7-.4-4z"/>
            </svg>
            Google
          </button>
          <button className={styles.socialBtn} type="button" aria-label="Continue with GitHub">
            <svg width="18" height="18" viewBox="0 0 24 24" aria-hidden="true" fill="currentColor">
              <path d="M12 2C6.48 2 2 6.48 2 12c0 4.42 2.87 8.17 6.84 9.5.5.09.68-.22.68-.48v-1.7c-2.78.6-3.37-1.34-3.37-1.34-.46-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.61.07-.61 1 .07 1.53 1.03 1.53 1.03.89 1.52 2.34 1.08 2.91.83.09-.65.35-1.08.63-1.33-2.22-.25-4.55-1.11-4.55-4.94 0-1.09.39-1.98 1.03-2.68-.1-.25-.45-1.27.1-2.64 0 0 .84-.27 2.75 1.02A9.56 9.56 0 0112 6.8c.85.004 1.7.115 2.5.336 1.9-1.29 2.74-1.02 2.74-1.02.55 1.37.2 2.39.1 2.64.64.7 1.03 1.59 1.03 2.68 0 3.84-2.34 4.68-4.57 4.93.36.31.68.92.68 1.85v2.74c0 .27.18.58.69.48A10.01 10.01 0 0022 12c0-5.52-4.48-10-10-10z"/>
            </svg>
            GitHub
          </button>
        </div>

        <p className={styles.footer}>
          {tab === 'signin'
            ? <>New here? <button className={styles.switchLink} onClick={() => { setTab('signup'); setError(''); }}>Create a free account</button></>
            : <>Already have an account? <button className={styles.switchLink} onClick={() => { setTab('signin'); setError(''); }}>Sign in</button></>
          }
        </p>
      </div>
    </div>
  );
};

export default SignIn;
