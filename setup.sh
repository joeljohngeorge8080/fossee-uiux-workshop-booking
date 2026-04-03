#!/usr/bin/env bash
# =============================================================================
# setup_uiux.sh — LearnForge UI/UX Enhancement (FOSSEE screening task)
#
# PURPOSE: UI/UX improvements only. Zero new architecture.
# Run from your project root (the folder that CONTAINS frontend/):
#   bash setup_uiux.sh
#
# What changes:
#   - variables.css   → richer design tokens, Google Font, dark mode
#   - global.css      → focus rings, skip link, smooth scroll, sr-only
#   - Navbar          → mobile hamburger fixes, active state, accessibility
#   - Layout          → skip-to-content, semantic landmarks
#   - WorkshopCard    → badge colors, urgency chip, hover, responsive
#   - WorkshopList    → loader, empty state, grid breakpoints
#   - WorkshopDetails → sticky form, responsive meta grid, spots urgency
#   - RegistrationForm→ blur validation wired, server error UI, success UI
#   - useFormValidation → stale-closure bug fixed (UI correctness fix)
#
# What does NOT change:
#   - package.json, vite.config.js, index.html, public/
#   - App.jsx routing logic
#   - Mock data shape
#   - No new dependencies, no API layer, no context, no new hooks (except fix)
# =============================================================================

set -e

F="frontend/src"

echo ""
echo "🎨  LearnForge — UI/UX enhancement pass..."
echo ""

mkdir -p \
  "$F/styles" \
  "$F/components/Layout" \
  "$F/components/Navbar" \
  "$F/components/WorkshopCard" \
  "$F/components/RegistrationForm" \
  "$F/pages/WorkshopList" \
  "$F/pages/WorkshopDetails" \
  "$F/hooks"

w() { cat > "$1"; echo "   ✔  $1"; }

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 1 — DESIGN TOKENS  (variables.css)
# Changes: adds Google Font (DM Sans + DM Serif Display), richer palette,
#          badge tokens, --navbar-height, --focus-ring, dark mode, reduced-motion
# ─────────────────────────────────────────────────────────────────────────────
w "$F/styles/variables.css" << 'EOF'
/* Google Fonts — loaded via index.html <link> tag (see instructions below) */
/* Add this inside <head> in frontend/index.html:
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=DM+Serif+Display&display=swap" rel="stylesheet">
*/

:root {
  /* ── Brand palette ──────────────────────────────────── */
  --color-primary:        #2563eb;
  --color-primary-hover:  #1d4ed8;
  --color-primary-light:  #eff6ff;
  --color-background:     #ffffff;
  --color-surface:        #f8fafc;
  --color-surface-alt:    #f1f5f9;
  --color-text:           #0f172a;
  --color-text-muted:     #475569;
  --color-text-light:     #94a3b8;
  --color-border:         #e2e8f0;
  --color-border-focus:   #93c5fd;
  --color-error:          #dc2626;
  --color-error-bg:       #fef2f2;
  --color-success:        #059669;
  --color-success-bg:     #ecfdf5;
  --color-warning:        #d97706;
  --color-warning-bg:     #fffbeb;

  /* ── Level badge colours ────────────────────────────── */
  --badge-beginner:     #059669;   /* emerald  */
  --badge-intermediate: #2563eb;   /* blue     */
  --badge-advanced:     #7c3aed;   /* violet   */

  /* ── Typography ─────────────────────────────────────── */
  --font-sans:    'DM Sans', system-ui, -apple-system, sans-serif;
  --font-display: 'DM Serif Display', Georgia, serif;

  --text-xs:   0.75rem;    /* 12px */
  --text-sm:   0.875rem;   /* 14px */
  --text-base: 1rem;       /* 16px */
  --text-lg:   1.125rem;   /* 18px */
  --text-xl:   1.25rem;    /* 20px */
  --text-2xl:  1.5rem;     /* 24px */
  --text-3xl:  1.875rem;   /* 30px */
  --text-4xl:  2.25rem;    /* 36px */

  /* ── Spacing scale ──────────────────────────────────── */
  --space-1:  0.25rem;
  --space-2:  0.5rem;
  --space-3:  0.75rem;
  --space-4:  1rem;
  --space-5:  1.25rem;
  --space-6:  1.5rem;
  --space-8:  2rem;
  --space-10: 2.5rem;
  --space-12: 3rem;
  --space-16: 4rem;

  /* ── Layout ─────────────────────────────────────────── */
  --max-width:     1200px;
  --navbar-height: 64px;

  /* ── Radii ──────────────────────────────────────────── */
  --radius-sm:  4px;
  --radius-md:  8px;
  --radius-lg:  12px;
  --radius-xl:  16px;
  --radius-full: 9999px;

  /* ── Shadows ────────────────────────────────────────── */
  --shadow-sm:  0 1px 3px 0 rgb(0 0 0 / .07), 0 1px 2px -1px rgb(0 0 0 / .07);
  --shadow-md:  0 4px 12px -2px rgb(0 0 0 / .10), 0 2px 6px -2px rgb(0 0 0 / .06);
  --shadow-lg:  0 16px 32px -4px rgb(0 0 0 / .12), 0 4px 8px -2px rgb(0 0 0 / .06);
  --shadow-focus: 0 0 0 3px var(--color-border-focus);

  /* ── Transitions ────────────────────────────────────── */
  --ease-fast:  150ms ease;
  --ease-base:  220ms ease;
  --ease-slow:  350ms ease;
}

/* ── Dark mode ──────────────────────────────────────────────────────────── */
@media (prefers-color-scheme: dark) {
  :root {
    --color-background:  #0f172a;
    --color-surface:     #1e293b;
    --color-surface-alt: #273549;
    --color-text:        #f1f5f9;
    --color-text-muted:  #94a3b8;
    --color-text-light:  #64748b;
    --color-border:      #334155;
    --color-border-focus:#3b82f6;
    --color-primary-light: rgba(37,99,235,.15);
    --shadow-focus: 0 0 0 3px rgba(59,130,246,.4);
  }
}

/* ── Reduced motion ─────────────────────────────────────────────────────── */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration:       .01ms !important;
    animation-iteration-count: 1   !important;
    transition-duration:      .01ms !important;
    scroll-behavior:           auto !important;
  }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 2 — GLOBAL CSS
# Changes: focus-visible ring, skip link, smooth scroll, sr-only
# ─────────────────────────────────────────────────────────────────────────────
w "$F/styles/global.css" << 'EOF'
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

html {
  font-family: var(--font-sans);
  font-size: 16px;
  line-height: 1.6;
  scroll-behavior: smooth;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  scrollbar-gutter: stable;
}

body {
  background-color: var(--color-background);
  color: var(--color-text);
  transition: background-color var(--ease-base), color var(--ease-base);
}

/* ── Headings use display font ─── */
h1, h2, h3 { font-family: var(--font-display); line-height: 1.2; color: var(--color-text); }
h4, h5, h6 { line-height: 1.3; color: var(--color-text); font-weight: 700; }

a {
  color: var(--color-primary);
  text-decoration: none;
  transition: color var(--ease-fast);
}
a:hover { color: var(--color-primary-hover); }

button { font-family: inherit; cursor: pointer; border: none; background: transparent; }
img    { max-width: 100%; height: auto; display: block; }
ul, ol { list-style: none; }

/* ── Keyboard focus ring (not on mouse click) ──────────────────────────── */
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
  box-shadow: var(--shadow-focus);
  border-radius: var(--radius-sm);
}
:focus:not(:focus-visible) { outline: none; }

/* ── Skip to main (screen readers + keyboard nav) ─────────────────────── */
.skip-to-main {
  position: fixed;
  top: var(--space-4);
  left: var(--space-4);
  z-index: 9999;
  padding: var(--space-2) var(--space-5);
  background: var(--color-primary);
  color: #fff;
  border-radius: var(--radius-md);
  font-weight: 600;
  font-size: var(--text-sm);
  transform: translateY(-150%);
  transition: transform var(--ease-fast);
}
.skip-to-main:focus { transform: translateY(0); }

/* ── Screen-reader only text ──────────────────────────────────────────── */
.sr-only {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden;
  clip: rect(0,0,0,0);
  white-space: nowrap;
  border: 0;
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 3 — main.jsx  (update CSS import paths only)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/main.jsx" << 'EOF'
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';
import './styles/variables.css';
import './styles/global.css';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>
);
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 4 — App.jsx  (unchanged routing, just clean imports)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/App.jsx" << 'EOF'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Suspense, lazy } from 'react';
import Layout from './components/Layout/Layout';

const WorkshopList    = lazy(() => import('./pages/WorkshopList/WorkshopList'));
const WorkshopDetails = lazy(() => import('./pages/WorkshopDetails/WorkshopDetails'));

function App() {
  return (
    <Router>
      <Layout>
        <Suspense fallback={
          <div style={{ display:'flex', justifyContent:'center', padding:'4rem' }}>
            <div className="loader" aria-label="Loading…" />
          </div>
        }>
          <Routes>
            <Route path="/"             element={<WorkshopList />} />
            <Route path="/workshop/:id" element={<WorkshopDetails />} />
            <Route path="*"             element={
              <div style={{ textAlign:'center', padding:'4rem' }}>
                <h2>Page Not Found</h2>
                <p style={{ color:'var(--color-text-muted)', marginTop:'1rem' }}>
                  The page you're looking for doesn't exist.
                </p>
              </div>
            } />
          </Routes>
        </Suspense>
      </Layout>
    </Router>
  );
}

export default App;
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 5 — Layout  (adds skip link, semantic main, navbar-height token)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/components/Layout/Layout.jsx" << 'EOF'
import React from 'react';
import Navbar from '../Navbar/Navbar';
import styles from './Layout.module.css';

const Layout = ({ children }) => (
  <div className={styles.wrapper}>
    <a href="#main-content" className="skip-to-main">Skip to main content</a>

    <header className={styles.header}>
      <Navbar />
    </header>

    <main id="main-content" className={styles.main} tabIndex={-1}>
      {children}
    </main>

    <footer className={styles.footer} role="contentinfo">
      <div className={styles.footerInner}>
        <p>© {new Date().getFullYear()} LearnForge — All rights reserved.</p>
      </div>
    </footer>
  </div>
);

export default Layout;
EOF

w "$F/components/Layout/Layout.module.css" << 'EOF'
.wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.header {
  position: sticky;
  top: 0;
  z-index: 100;
  height: var(--navbar-height);
  background-color: var(--color-background);
  border-bottom: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
  /* GPU-composited sticky — avoids paint on scroll */
  will-change: transform;
}

.main {
  flex: 1;
  width: 100%;
  max-width: var(--max-width);
  margin: 0 auto;
  padding: var(--space-8) var(--space-4);
  /* No focus outline on programmatic focus from skip link */
  outline: none;
}

.footer {
  border-top: 1px solid var(--color-border);
  background-color: var(--color-surface);
  padding: var(--space-6) var(--space-4);
}

.footerInner {
  max-width: var(--max-width);
  margin: 0 auto;
  text-align: center;
  color: var(--color-text-light);
  font-size: var(--text-sm);
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 6 — Navbar  (Escape-to-close, click-outside, aria-current, focus mgmt)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/components/Navbar/Navbar.jsx" << 'EOF'
import React, { useState, useEffect, useRef, useCallback } from 'react';
import { Link, useLocation } from 'react-router-dom';
import styles from './Navbar.module.css';

const NAV_LINKS = [
  { label: 'Workshops',   path: '/' },
  { label: 'My Bookings', path: '/bookings' },
  { label: 'About',       path: '/about' },
];

const Navbar = () => {
  const [open, setOpen] = useState(false);
  const location  = useLocation();
  const navRef    = useRef(null);
  const btnRef    = useRef(null);

  const close = useCallback(() => setOpen(false), []);

  /* Close on route change */
  useEffect(() => { close(); }, [location.pathname, close]);

  /* Close on Escape — return focus to hamburger */
  useEffect(() => {
    if (!open) return;
    const onKey = (e) => { if (e.key === 'Escape') { close(); btnRef.current?.focus(); } };
    document.addEventListener('keydown', onKey);
    return () => document.removeEventListener('keydown', onKey);
  }, [open, close]);

  /* Close on click outside */
  useEffect(() => {
    if (!open) return;
    const onOutside = (e) => { if (navRef.current && !navRef.current.contains(e.target)) close(); };
    document.addEventListener('mousedown', onOutside);
    return () => document.removeEventListener('mousedown', onOutside);
  }, [open, close]);

  return (
    <nav className={styles.nav} ref={navRef} aria-label="Main navigation">
      <div className={styles.inner}>

        <Link to="/" className={styles.logo} onClick={close}>
          Learn<span className={styles.accent}>Forge</span>
        </Link>

        {/* Hamburger button — visible only on mobile */}
        <button
          ref={btnRef}
          className={`${styles.hamburger} ${open ? styles.hamburgerOpen : ''}`}
          onClick={() => setOpen(p => !p)}
          aria-label={open ? 'Close menu' : 'Open menu'}
          aria-expanded={open}
          aria-controls="nav-links"
        >
          <span className={styles.bar} />
          <span className={styles.bar} />
          <span className={styles.bar} />
        </button>

        {/* Nav links */}
        <ul
          id="nav-links"
          className={`${styles.links} ${open ? styles.linksOpen : ''}`}
          role="list"
        >
          {NAV_LINKS.map(({ label, path }) => {
            const active = location.pathname === path;
            return (
              <li key={label}>
                <Link
                  to={path}
                  className={`${styles.link} ${active ? styles.linkActive : ''}`}
                  onClick={close}
                  aria-current={active ? 'page' : undefined}
                >
                  {label}
                </Link>
              </li>
            );
          })}
          <li>
            <Link to="/login" className={styles.signInBtn} onClick={close}>
              Sign In
            </Link>
          </li>
        </ul>

      </div>
    </nav>
  );
};

export default Navbar;
EOF

w "$F/components/Navbar/Navbar.module.css" << 'EOF'
/* ── Shell ──────────────────────────────────────────────────────────────── */
.nav  { width: 100%; height: 100%; display: flex; align-items: center; }
.inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  max-width: var(--max-width);
  margin: 0 auto;
  padding: 0 var(--space-4);
  height: 100%;
  position: relative;
}

/* ── Logo ───────────────────────────────────────────────────────────────── */
.logo {
  font-family: var(--font-display);
  font-size: var(--text-xl);
  color: var(--color-text);
  letter-spacing: -.3px;
  flex-shrink: 0;
}
.accent { color: var(--color-primary); }

/* ── Hamburger ──────────────────────────────────────────────────────────── */
.hamburger {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 5px;
  width: 32px;
  height: 32px;
  padding: 2px;
  background: none;
  border: none;
  cursor: pointer;
  border-radius: var(--radius-sm);
  transition: background var(--ease-fast);
}
.hamburger:hover { background: var(--color-surface-alt); }

.bar {
  display: block;
  width: 100%;
  height: 2px;
  background-color: var(--color-text);
  border-radius: 2px;
  transition: transform var(--ease-base), opacity var(--ease-base);
  transform-origin: center;
}
.hamburgerOpen .bar:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.hamburgerOpen .bar:nth-child(2) { opacity: 0; transform: scaleX(0); }
.hamburgerOpen .bar:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

/* ── Mobile nav menu ────────────────────────────────────────────────────── */
.links {
  display: flex;
  flex-direction: column;
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background-color: var(--color-background);
  border-top: 1px solid var(--color-border);
  box-shadow: var(--shadow-md);
  padding: var(--space-4);
  gap: var(--space-2);
  /* Hidden by default — uses visibility+opacity instead of display:none
     so transitions work and screen readers can still access it */
  opacity: 0;
  visibility: hidden;
  transform: translateY(-6px);
  transition:
    opacity    var(--ease-base),
    transform  var(--ease-base),
    visibility var(--ease-base);
}
.linksOpen {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

/* ── Link items ─────────────────────────────────────────────────────────── */
.link {
  display: block;
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  font-size: var(--text-base);
  font-weight: 500;
  color: var(--color-text-muted);
  transition: background var(--ease-fast), color var(--ease-fast);
  text-align: center;
}
.link:hover { background: var(--color-surface-alt); color: var(--color-text); }
.linkActive  { background: var(--color-primary-light); color: var(--color-primary); font-weight: 600; }

.signInBtn {
  display: block;
  text-align: center;
  padding: var(--space-3) var(--space-6);
  background-color: var(--color-primary);
  color: #fff !important;
  border-radius: var(--radius-md);
  font-weight: 600;
  transition: background var(--ease-fast), transform var(--ease-fast);
}
.signInBtn:hover {
  background-color: var(--color-primary-hover);
  transform: translateY(-1px);
}

/* ── Desktop (≥768px) ──────────────────────────────────────────────────── */
@media (min-width: 768px) {
  .hamburger { display: none; }

  .links {
    position: static;
    flex-direction: row;
    align-items: center;
    background: transparent;
    border: none;
    box-shadow: none;
    padding: 0;
    gap: var(--space-2);
    opacity: 1;
    visibility: visible;
    transform: none;
    height: 100%;
  }

  .link {
    padding: var(--space-2) var(--space-3);
    text-align: left;
  }

  .signInBtn { padding: var(--space-2) var(--space-5); }
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 7 — useFormValidation  (stale-closure fix — UI correctness)
# This is a pure UI fix: real-time field validation was broken because
# handleChange closed over stale state. No new architecture.
# ─────────────────────────────────────────────────────────────────────────────
w "$F/hooks/useFormValidation.js" << 'EOF'
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
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 8 — WorkshopCard  (badge colour fix, urgency chip, hover, responsive)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/components/WorkshopCard/WorkshopCard.jsx" << 'EOF'
import React, { memo } from 'react';
import { Link } from 'react-router-dom';
import styles from './WorkshopCard.module.css';

const LEVEL_COLORS = {
  Beginner:     'var(--badge-beginner)',
  Intermediate: 'var(--badge-intermediate)',
  Advanced:     'var(--badge-advanced)',
};

const fmtDate = (d) =>
  new Date(d).toLocaleDateString('en-US', { day: 'numeric', month: 'short', year: 'numeric' });

const WorkshopCard = memo(({ id, title, date, instructor, excerpt, level, spotsLeft }) => {
  const badgeColor   = LEVEL_COLORS[level] ?? 'var(--badge-intermediate)';
  const almostFull   = spotsLeft !== undefined && spotsLeft > 0 && spotsLeft <= 5;
  const soldOut      = spotsLeft === 0;

  return (
    <article className={styles.card}>
      {/* ── Header ── */}
      <div className={styles.cardHeader}>
        <div className={styles.topRow}>
          <span
            className={styles.badge}
            style={{ '--badge-bg': badgeColor }}
          >
            {level}
          </span>

          {almostFull && (
            <span className={styles.urgency} aria-label={`Only ${spotsLeft} spots left`}>
              🔥 {spotsLeft} left
            </span>
          )}
          {soldOut && (
            <span className={`${styles.urgency} ${styles.soldOut}`} aria-label="Sold out">
              Sold out
            </span>
          )}
        </div>

        <h3 className={styles.title}>{title}</h3>
      </div>

      {/* ── Body ── */}
      <div className={styles.cardBody}>
        <dl className={styles.meta}>
          <div className={styles.metaRow}>
            <dt className="sr-only">Date</dt>
            <dd><span aria-hidden="true">📅</span> {fmtDate(date)}</dd>
          </div>
          <div className={styles.metaRow}>
            <dt className="sr-only">Instructor</dt>
            <dd><span aria-hidden="true">👤</span> {instructor}</dd>
          </div>
        </dl>

        <p className={styles.excerpt}>{excerpt}</p>
      </div>

      {/* ── Footer ── */}
      <div className={styles.cardFooter}>
        <Link
          to={`/workshop/${id}`}
          className={`${styles.btn} ${soldOut ? styles.btnDisabled : ''}`}
          aria-label={`View details for ${title}`}
          aria-disabled={soldOut}
          tabIndex={soldOut ? -1 : undefined}
        >
          {soldOut ? 'Fully Booked' : 'View & Register →'}
        </Link>
      </div>
    </article>
  );
});

WorkshopCard.displayName = 'WorkshopCard';
export default WorkshopCard;
EOF

w "$F/components/WorkshopCard/WorkshopCard.module.css" << 'EOF'
/* ── Card shell ─────────────────────────────────────────────────────────── */
.card {
  display: flex;
  flex-direction: column;
  background: var(--color-background);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  height: 100%;
  transition: transform var(--ease-base), box-shadow var(--ease-base), border-color var(--ease-base);
}
.card:hover {
  transform: translateY(-3px);
  box-shadow: var(--shadow-lg);
  border-color: var(--color-primary);
}

/* ── Header ─────────────────────────────────────────────────────────────── */
.cardHeader {
  padding: var(--space-5) var(--space-5) var(--space-4);
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
}

.topRow {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-2);
  margin-bottom: var(--space-3);
  flex-wrap: wrap;
}

/* Level badge — colour set via inline CSS var */
.badge {
  display: inline-flex;
  align-items: center;
  padding: 0.2rem 0.6rem;
  background-color: var(--badge-bg, var(--badge-intermediate));
  color: #fff;
  font-size: var(--text-xs);
  font-weight: 700;
  letter-spacing: .5px;
  text-transform: uppercase;
  border-radius: var(--radius-full);
  flex-shrink: 0;
}

/* Urgency chip */
.urgency {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  padding: .15rem .55rem;
  border-radius: var(--radius-full);
  font-size: var(--text-xs);
  font-weight: 700;
  color: var(--color-warning);
  background: var(--color-warning-bg);
  border: 1px solid rgba(217,119,6,.25);
  white-space: nowrap;
}
.soldOut {
  color: var(--color-text-muted);
  background: var(--color-surface-alt);
  border-color: var(--color-border);
}

.title {
  font-size: var(--text-lg);
  font-weight: 700;
  color: var(--color-text);
  line-height: 1.3;
}

/* ── Body ───────────────────────────────────────────────────────────────── */
.cardBody { padding: var(--space-5); flex: 1; display: flex; flex-direction: column; gap: var(--space-4); }

.meta { display: flex; flex-direction: column; gap: var(--space-1); }
.metaRow {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  font-size: var(--text-sm);
  color: var(--color-text-muted);
}
.metaRow dd { display: flex; align-items: center; gap: var(--space-2); }

.excerpt {
  font-size: var(--text-sm);
  color: var(--color-text-muted);
  line-height: 1.7;
  flex: 1;
  /* Clamp to 3 lines — avoids cards of wildly different heights */
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* ── Footer ─────────────────────────────────────────────────────────────── */
.cardFooter {
  padding: var(--space-4) var(--space-5);
  border-top: 1px solid var(--color-border);
  background: var(--color-surface);
}

.btn {
  display: block;
  text-align: center;
  padding: var(--space-3) var(--space-4);
  background: var(--color-primary);
  color: #fff !important;
  border-radius: var(--radius-md);
  font-weight: 600;
  font-size: var(--text-sm);
  transition: background var(--ease-fast), transform var(--ease-fast);
}
.btn:hover { background: var(--color-primary-hover); transform: translateY(-1px); }

.btnDisabled {
  background: var(--color-surface-alt);
  color: var(--color-text-muted) !important;
  cursor: not-allowed;
  pointer-events: none;
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 9 — WorkshopList page  (improved header, grid, loader, empty state)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/pages/WorkshopList/WorkshopList.jsx" << 'EOF'
import React, { useState, useEffect } from 'react';
import WorkshopCard from '../../components/WorkshopCard/WorkshopCard';
import styles from './WorkshopList.module.css';

const WORKSHOPS = [
  {
    id: 1, title: 'Advanced React Patterns', date: '2026-05-15',
    instructor: 'Jane Doe', level: 'Advanced', spotsLeft: 3,
    excerpt: 'Master advanced React concepts including higher-order components, render props, and custom hooks for scalable applications.',
  },
  {
    id: 2, title: 'Python Django Mastery', date: '2026-05-22',
    instructor: 'John Smith', level: 'Intermediate', spotsLeft: 12,
    excerpt: 'Build robust backend architectures with Django. Learn ORM optimizations, middleware, and class-based views.',
  },
  {
    id: 3, title: 'UI/UX Fundamentals for Engineers', date: '2026-06-05',
    instructor: 'Alice Johnson', level: 'Beginner', spotsLeft: 20,
    excerpt: 'Understand basic design principles, typography, and color theory to build better interfaces.',
  },
  {
    id: 4, title: 'Fullstack Next.js Development', date: '2026-06-12',
    instructor: 'Bob Williams', level: 'Intermediate', spotsLeft: 8,
    excerpt: 'Create high-performance server-side rendered applications with Next.js app router and server actions.',
  },
];

const WorkshopList = () => {
  const [workshops, setWorkshops] = useState([]);
  const [loading,   setLoading]   = useState(true);

  useEffect(() => {
    const t = setTimeout(() => { setWorkshops(WORKSHOPS); setLoading(false); }, 600);
    return () => clearTimeout(t);
  }, []);

  return (
    <section className={styles.page}>
      {/* ── Page header ── */}
      <header className={styles.hero}>
        <p className={styles.eyebrow}>Expert-led sessions</p>
        <h1 className={styles.heading}>Upcoming Workshops</h1>
        <p className={styles.subheading}>
          Sharpen your skills with hands-on workshops led by industry practitioners.
          Limited spots — register early.
        </p>
      </header>

      {/* ── Content ── */}
      {loading ? (
        <div className={styles.loaderWrap} role="status" aria-live="polite">
          <span className={styles.spinner} aria-hidden="true" />
          <p>Loading workshops…</p>
        </div>
      ) : workshops.length === 0 ? (
        <div className={styles.empty} role="status">
          <p>No workshops scheduled yet — check back soon.</p>
        </div>
      ) : (
        <div className={styles.grid}>
          {workshops.map(w => (
            <WorkshopCard key={w.id} {...w} />
          ))}
        </div>
      )}
    </section>
  );
};

export default WorkshopList;
EOF

w "$F/pages/WorkshopList/WorkshopList.module.css" << 'EOF'
.page { display: flex; flex-direction: column; gap: var(--space-12); }

/* ── Hero header ─────────────────────────────────────────────────────────── */
.hero {
  text-align: center;
  max-width: 640px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.eyebrow {
  font-size: var(--text-xs);
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  color: var(--color-primary);
}

.heading {
  font-size: clamp(var(--text-3xl), 5vw, var(--text-4xl));
  color: var(--color-text);
}

.subheading {
  font-size: var(--text-lg);
  color: var(--color-text-muted);
  line-height: 1.7;
}

/* ── Card grid ──────────────────────────────────────────────────────────── */
.grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--space-6);
}

@media (min-width: 640px)  { .grid { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 1024px) { .grid { grid-template-columns: repeat(3, 1fr); } }

/* ── Loader ─────────────────────────────────────────────────────────────── */
.loaderWrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-4);
  padding: var(--space-16) 0;
  color: var(--color-text-muted);
  font-size: var(--text-sm);
}

.spinner {
  display: block;
  width: 36px;
  height: 36px;
  border: 3px solid var(--color-border);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin .8s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* ── Empty state ─────────────────────────────────────────────────────────── */
.empty {
  text-align: center;
  padding: var(--space-16) 0;
  color: var(--color-text-muted);
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 10 — WorkshopDetails page  (sticky form, responsive grid, urgency)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/pages/WorkshopDetails/WorkshopDetails.jsx" << 'EOF'
import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import RegistrationForm from '../../components/RegistrationForm/RegistrationForm';
import styles from './WorkshopDetails.module.css';

const WORKSHOPS = [
  {
    id: 1, title: 'Advanced React Patterns', date: '2026-05-15',
    instructor: 'Jane Doe', level: 'Advanced', duration: '4 hours',
    price: '$149', spotsLeft: 3,
    description: 'This intensive workshop dives deep into the advanced patterns used in modern React applications. You will learn how to build scalable and maintainable components using techniques like higher-order components, render props, compound components, and custom hooks. The curriculum includes practical exercises on state management optimizations and performance tuning using React Profiler.',
  },
  {
    id: 2, title: 'Python Django Mastery', date: '2026-05-22',
    instructor: 'John Smith', level: 'Intermediate', duration: '6 hours',
    price: '$199', spotsLeft: 12,
    description: 'Elevate your backend engineering skills with our comprehensive Django Mastery workshop. This session covers ORM performance optimizations, custom middleware development, and class-based views for cleaner code. Designed for developers with basic Django knowledge, this hands-on workshop will prepare you to deploy production-ready API backends.',
  },
  {
    id: 3, title: 'UI/UX Fundamentals for Engineers', date: '2026-06-05',
    instructor: 'Alice Johnson', level: 'Beginner', duration: '3 hours',
    price: '$99', spotsLeft: 20,
    description: 'This workshop bridges the gap between engineering and design. Gain a solid foundation in visual hierarchy, typography, color theory, and responsive layout — all taught from an engineer\'s perspective with practical exercises.',
  },
  {
    id: 4, title: 'Fullstack Next.js Development', date: '2026-06-12',
    instructor: 'Bob Williams', level: 'Intermediate', duration: '5 hours',
    price: '$179', spotsLeft: 8,
    description: 'A hands-on fullstack workshop covering Next.js App Router, React Server Components, server actions, and data fetching strategies. You will build a complete production-ready app from scratch during the session.',
  },
];

const fmtDate = (d) =>
  new Date(d).toLocaleDateString('en-US', { weekday:'long', year:'numeric', month:'long', day:'numeric' });

const META_ITEMS = (w) => [
  { icon: '📅', label: 'Date',       value: fmtDate(w.date) },
  { icon: '👤', label: 'Instructor', value: w.instructor },
  { icon: '⏱️', label: 'Duration',  value: w.duration },
  { icon: '💳', label: 'Price',      value: w.price },
];

const LEVEL_COLORS = {
  Beginner:     'var(--badge-beginner)',
  Intermediate: 'var(--badge-intermediate)',
  Advanced:     'var(--badge-advanced)',
};

const WorkshopDetails = () => {
  const { id } = useParams();
  const [workshop, setWorkshop] = useState(null);
  const [loading,  setLoading]  = useState(true);

  useEffect(() => {
    const t = setTimeout(() => {
      setWorkshop(WORKSHOPS.find(w => w.id === Number(id)) ?? null);
      setLoading(false);
    }, 400);
    return () => clearTimeout(t);
  }, [id]);

  /* ── Loading ── */
  if (loading) return (
    <div className={styles.center} role="status">
      <span className={styles.spinner} aria-hidden="true" />
      <p>Loading workshop…</p>
    </div>
  );

  /* ── Not found ── */
  if (!workshop) return (
    <div className={styles.center}>
      <h2>Workshop not found</h2>
      <p style={{ color:'var(--color-text-muted)', marginTop:'var(--space-2)' }}>
        We couldn't find that workshop.
      </p>
      <Link to="/" className={styles.backLink} style={{ marginTop:'var(--space-4)' }}>
        ← Back to workshops
      </Link>
    </div>
  );

  const spotsLow  = workshop.spotsLeft !== undefined && workshop.spotsLeft > 0 && workshop.spotsLeft <= 5;
  const soldOut   = workshop.spotsLeft === 0;

  return (
    <article>
      <Link to="/" className={styles.backLink}>← Back to all workshops</Link>

      <div className={styles.grid}>

        {/* ── Left: Info ── */}
        <section aria-label="Workshop information">
          {/* Title block */}
          <div className={styles.titleBlock}>
            <span
              className={styles.levelBadge}
              style={{ '--badge-bg': LEVEL_COLORS[workshop.level] ?? 'var(--badge-intermediate)' }}
            >
              {workshop.level}
            </span>
            <h1 className={styles.title}>{workshop.title}</h1>
          </div>

          {/* Spots warning */}
          {spotsLow && (
            <div className={styles.spotsWarning} role="status">
              🔥 Only <strong>{workshop.spotsLeft} spots</strong> remaining — register now!
            </div>
          )}
          {soldOut && (
            <div className={`${styles.spotsWarning} ${styles.soldOutBanner}`} role="status">
              This workshop is fully booked.
            </div>
          )}

          {/* Meta cards */}
          <dl className={styles.metaGrid}>
            {META_ITEMS(workshop).map(({ icon, label, value }) => (
              <div key={label} className={styles.metaCard}>
                <span className={styles.metaIcon} aria-hidden="true">{icon}</span>
                <div>
                  <dt className={styles.metaLabel}>{label}</dt>
                  <dd className={styles.metaValue}>{value}</dd>
                </div>
              </div>
            ))}
          </dl>

          {/* Description */}
          <div className={styles.description}>
            <h2>About this workshop</h2>
            <p>{workshop.description}</p>
          </div>
        </section>

        {/* ── Right: Form ── */}
        <aside className={styles.formCol} aria-label="Registration">
          <RegistrationForm workshopId={workshop.id} disabled={soldOut} />
        </aside>

      </div>
    </article>
  );
};

export default WorkshopDetails;
EOF

w "$F/pages/WorkshopDetails/WorkshopDetails.module.css" << 'EOF'
/* ── Back link ──────────────────────────────────────────────────────────── */
.backLink {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  font-size: var(--text-sm);
  font-weight: 500;
  color: var(--color-text-muted);
  margin-bottom: var(--space-6);
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-sm);
  transition: color var(--ease-fast), background var(--ease-fast);
}
.backLink:hover { color: var(--color-primary); background: var(--color-primary-light); }

/* ── Two-column layout ──────────────────────────────────────────────────── */
.grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--space-10);
}
@media (min-width: 1024px) {
  .grid {
    grid-template-columns: 3fr 2fr;
    align-items: start;
  }
}

/* ── Title block ────────────────────────────────────────────────────────── */
.titleBlock { margin-bottom: var(--space-5); }

.levelBadge {
  display: inline-block;
  padding: .25rem .75rem;
  background-color: var(--badge-bg, var(--badge-intermediate));
  color: #fff;
  font-size: var(--text-xs);
  font-weight: 700;
  letter-spacing: .5px;
  text-transform: uppercase;
  border-radius: var(--radius-full);
  margin-bottom: var(--space-3);
}

.title {
  font-size: clamp(var(--text-2xl), 4vw, var(--text-4xl));
  line-height: 1.15;
  color: var(--color-text);
}

/* ── Spots warning banner ───────────────────────────────────────────────── */
.spotsWarning {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-3) var(--space-4);
  background: var(--color-warning-bg);
  border: 1px solid rgba(217,119,6,.3);
  border-radius: var(--radius-md);
  font-size: var(--text-sm);
  font-weight: 500;
  color: var(--color-warning);
  margin-bottom: var(--space-6);
}
.soldOutBanner {
  background: var(--color-surface-alt);
  border-color: var(--color-border);
  color: var(--color-text-muted);
}

/* ── Meta grid ──────────────────────────────────────────────────────────── */
.metaGrid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-3);
  margin-bottom: var(--space-8);
}
@media (max-width: 480px) { .metaGrid { grid-template-columns: 1fr; } }

.metaCard {
  display: flex;
  align-items: flex-start;
  gap: var(--space-3);
  padding: var(--space-4);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
}

.metaIcon { font-size: 1.35rem; line-height: 1; flex-shrink: 0; margin-top: 2px; }

.metaLabel {
  display: block;
  font-size: var(--text-xs);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: .5px;
  color: var(--color-text-light);
  margin-bottom: var(--space-1);
}

.metaValue {
  font-size: var(--text-base);
  font-weight: 600;
  color: var(--color-text);
}

/* ── Description ────────────────────────────────────────────────────────── */
.description h2 {
  font-size: var(--text-xl);
  margin-bottom: var(--space-3);
  color: var(--color-text);
}
.description p {
  font-size: var(--text-base);
  line-height: 1.8;
  color: var(--color-text-muted);
}

/* ── Sticky form column ─────────────────────────────────────────────────── */
.formCol {
  position: sticky;
  top: calc(var(--navbar-height) + var(--space-6));
}

/* ── Loading / not-found center ─────────────────────────────────────────── */
.center {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 40vh;
  gap: var(--space-4);
  text-align: center;
  color: var(--color-text-muted);
}

.spinner {
  display: block;
  width: 36px;
  height: 36px;
  border: 3px solid var(--color-border);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin .8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
EOF

# ─────────────────────────────────────────────────────────────────────────────
# SECTION 11 — RegistrationForm  (blur validation, server-error UI, success UI)
# ─────────────────────────────────────────────────────────────────────────────
w "$F/components/RegistrationForm/RegistrationForm.jsx" << 'EOF'
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
EOF

w "$F/components/RegistrationForm/RegistrationForm.module.css" << 'EOF'
/* ── Card shell ─────────────────────────────────────────────────────────── */
.card {
  background: var(--color-background);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
  overflow: hidden;
}

.cardHeader {
  padding: var(--space-5) var(--space-6);
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
}

.formTitle {
  font-size: var(--text-xl);
  color: var(--color-text);
}

.fields {
  padding: var(--space-6);
  display: flex;
  flex-direction: column;
  gap: var(--space-5);
}

/* ── Inputs ─────────────────────────────────────────────────────────────── */
.input {
  width: 100%;
  padding: var(--space-3) var(--space-4);
  border: 1.5px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
  color: var(--color-text);
  font-family: inherit;
  font-size: var(--text-base);
  transition: border-color var(--ease-fast), box-shadow var(--ease-fast);
}
.input:hover:not(:disabled) { border-color: var(--color-text-light); }
.input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(37,99,235,.15);
}
.input:disabled { opacity: .55; cursor: not-allowed; background: var(--color-surface-alt); }

.select { cursor: pointer; }
.textarea { resize: vertical; min-height: 80px; }

/* ── Error state ────────────────────────────────────────────────────────── */
.inputErr {
  border-color: var(--color-error) !important;
  background: var(--color-error-bg);
}
.inputErr:focus { box-shadow: 0 0 0 3px rgba(220,38,38,.15) !important; }
.errMsg { font-size: var(--text-xs); color: var(--color-error); font-weight: 500; }

/* Server error banner */
.serverError {
  padding: var(--space-3) var(--space-4);
  background: var(--color-error-bg);
  border: 1px solid rgba(220,38,38,.3);
  border-radius: var(--radius-md);
  color: var(--color-error);
  font-size: var(--text-sm);
  font-weight: 500;
}

/* ── Submit button ──────────────────────────────────────────────────────── */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  padding: var(--space-3) var(--space-6);
  background: var(--color-primary);
  color: #fff;
  border-radius: var(--radius-md);
  font-weight: 600;
  font-size: var(--text-base);
  border: none;
  cursor: pointer;
  transition: background var(--ease-fast), transform var(--ease-fast), opacity var(--ease-fast);
}
.btn:hover:not(:disabled) { background: var(--color-primary-hover); transform: translateY(-1px); }
.btn:disabled { opacity: .65; cursor: not-allowed; transform: none; }

.submitBtn { width: 100%; }

/* ── Button spinner ─────────────────────────────────────────────────────── */
.btnSpinner {
  display: inline-block;
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255,255,255,.35);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin .7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Success state ──────────────────────────────────────────────────────── */
.success {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: var(--space-3);
  padding: var(--space-10) var(--space-6);
  background: var(--color-background);
  border: 1px solid var(--color-success);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
}
.successIcon { font-size: 2.5rem; line-height: 1; }
.success h3  { font-size: var(--text-xl); color: var(--color-success); }
.success p   { font-size: var(--text-sm); color: var(--color-text-muted); }
.confirmId   { font-size: var(--text-xs); color: var(--color-text-light); }
.confirmId code { color: var(--color-text); font-size: var(--text-sm); }

/* ── Sold-out state ─────────────────────────────────────────────────────── */
.soldOutMsg {
  padding: var(--space-6);
  font-size: var(--text-sm);
  color: var(--color-text-muted);
  line-height: 1.7;
}
EOF

# ─────────────────────────────────────────────────────────────────────────────
# Done!
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "✅  UI/UX refactor applied — $(find frontend/src -name '*.jsx' -o -name '*.css' -o -name '*.js' | wc -l | tr -d ' ') files updated."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ONE MANUAL STEP — add Google Fonts to frontend/index.html"
echo "  Inside the <head> tag, add:"
echo ""
echo '  <link rel="preconnect" href="https://fonts.googleapis.com">'
echo '  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
echo '  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,400&family=DM+Serif+Display&display=swap" rel="stylesheet">'
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  cd frontend && npm run dev"
echo ""
