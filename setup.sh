#!/usr/bin/env bash
# =============================================================================
# fix_all.sh — Complete fix for LearnForge FOSSEE submission
#
# Run from your project root (the folder that CONTAINS the frontend/ folder):
#   bash fix_all.sh
#
# Fixes:
#   1. Design not showing  → rewrites CSS variables + global CSS with correct
#                            token names that match the components
#   2. My Bookings → 404  → adds a real My Bookings page
#   3. About → 404        → adds a real About page
#   4. Sign In → 404      → adds a real Sign In page with form
#   5. App.jsx            → routes all pages correctly, no more wildcard 404
#   6. index.html         → Google Fonts + SEO meta tags
# =============================================================================

set -e
F="frontend/src"

echo ""
echo "🔧  Applying all fixes..."
echo ""

mkdir -p \
  "$F/styles" \
  "$F/hooks" \
  "$F/components/Layout" \
  "$F/components/Navbar" \
  "$F/components/WorkshopCard" \
  "$F/components/RegistrationForm" \
  "$F/pages/WorkshopList" \
  "$F/pages/WorkshopDetails" \
  "$F/pages/MyBookings" \
  "$F/pages/About" \
  "$F/pages/SignIn"

w() { cat > "$1"; echo "   ✔  $1"; }

# =============================================================================
# FIX 1 — index.html: Google Fonts + SEO
# =============================================================================
w "frontend/index.html" << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- SEO -->
    <title>LearnForge — Expert-Led Workshops</title>
    <meta name="description" content="Browse and register for expert-led workshops in React, Django, UI/UX and more. Limited spots — secure yours today." />
    <meta name="theme-color" content="#2563eb" />

    <!-- Open Graph -->
    <meta property="og:title"       content="LearnForge — Expert-Led Workshops" />
    <meta property="og:description" content="Browse and register for expert-led workshops. Limited spots — secure yours today." />
    <meta property="og:type"        content="website" />

    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />

    <!-- Google Fonts: DM Sans (body) + DM Serif Display (headings) -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,400;9..40,500;9..40,600;9..40,700&family=DM+Serif+Display&display=swap"
      rel="stylesheet"
    />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# =============================================================================
# FIX 2 — main.jsx: correct CSS import paths
# =============================================================================
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

# =============================================================================
# FIX 3 — variables.css: correct token names + full design system
# =============================================================================
w "$F/styles/variables.css" << 'EOF'
:root {
  /* ── Brand colours ──────────────────────────────────────── */
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
  --color-error:          #dc2626;
  --color-error-bg:       #fef2f2;
  --color-success:        #059669;
  --color-success-bg:     #ecfdf5;
  --color-warning:        #d97706;
  --color-warning-bg:     #fffbeb;

  /* ── Level badge colours ────────────────────────────────── */
  --badge-beginner:     #059669;
  --badge-intermediate: #2563eb;
  --badge-advanced:     #7c3aed;

  /* ── Typography ─────────────────────────────────────────── */
  --font-sans:    'DM Sans', system-ui, -apple-system, sans-serif;
  --font-display: 'DM Serif Display', Georgia, serif;

  --text-xs:   0.75rem;
  --text-sm:   0.875rem;
  --text-base: 1rem;
  --text-lg:   1.125rem;
  --text-xl:   1.25rem;
  --text-2xl:  1.5rem;
  --text-3xl:  1.875rem;
  --text-4xl:  2.25rem;

  /* ── Spacing ────────────────────────────────────────────── */
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

  /* ── Layout ─────────────────────────────────────────────── */
  --max-width:     1200px;
  --navbar-height: 64px;

  /* ── Radii ──────────────────────────────────────────────── */
  --radius-sm:   4px;
  --radius-md:   8px;
  --radius-lg:   12px;
  --radius-xl:   16px;
  --radius-full: 9999px;

  /* ── Shadows ────────────────────────────────────────────── */
  --shadow-sm:    0 1px 3px 0 rgb(0 0 0 / .07), 0 1px 2px -1px rgb(0 0 0 / .07);
  --shadow-md:    0 4px 12px -2px rgb(0 0 0 / .10), 0 2px 6px -2px rgb(0 0 0 / .06);
  --shadow-lg:    0 16px 32px -4px rgb(0 0 0 / .12), 0 4px 8px -2px rgb(0 0 0 / .06);
  --shadow-focus: 0 0 0 3px rgba(37, 99, 235, 0.25);

  /* ── Transitions ────────────────────────────────────────── */
  --ease-fast: 150ms ease;
  --ease-base: 220ms ease;
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
    --color-primary-light: rgba(37, 99, 235, 0.15);
    --shadow-focus: 0 0 0 3px rgba(96, 165, 250, 0.35);
  }
}

/* ── Reduced motion ─────────────────────────────────────────────────────── */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration:        0.01ms !important;
    animation-iteration-count: 1      !important;
    transition-duration:       0.01ms !important;
  }
}
EOF

# =============================================================================
# FIX 4 — global.css: reset, typography, focus ring, skip link, sr-only
# =============================================================================
w "$F/styles/global.css" << 'EOF'
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

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

/* Display font for headings */
h1, h2, h3 {
  font-family: var(--font-display);
  line-height: 1.2;
  color: var(--color-text);
}
h4, h5, h6 {
  font-weight: 700;
  line-height: 1.3;
  color: var(--color-text);
}

a {
  color: var(--color-primary);
  text-decoration: none;
  transition: color var(--ease-fast);
}
a:hover { color: var(--color-primary-hover); }

button { font-family: inherit; cursor: pointer; border: none; background: transparent; }
img    { max-width: 100%; height: auto; display: block; }
ul, ol { list-style: none; }

/* ── Keyboard focus ring ────────────────────────────────────────────────── */
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
  box-shadow: var(--shadow-focus);
  border-radius: var(--radius-sm);
}
:focus:not(:focus-visible) { outline: none; }

/* ── Skip to main content (keyboard / screen reader) ───────────────────── */
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

/* ── Utility: screen-reader only text ──────────────────────────────────── */
.sr-only {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* ── Shared spinner used by multiple pages ──────────────────────────────── */
.spinner {
  display: inline-block;
  width: 36px; height: 36px;
  border: 3px solid var(--color-border);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
EOF

# =============================================================================
# FIX 5 — Layout
# =============================================================================
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
.wrapper { display: flex; flex-direction: column; min-height: 100vh; }

.header {
  position: sticky;
  top: 0;
  z-index: 100;
  height: var(--navbar-height);
  background-color: var(--color-background);
  border-bottom: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
  will-change: transform;
}

.main {
  flex: 1;
  width: 100%;
  max-width: var(--max-width);
  margin: 0 auto;
  padding: var(--space-8) var(--space-4);
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

# =============================================================================
# FIX 6 — Navbar (Escape-to-close, click-outside, aria-current)
# =============================================================================
w "$F/components/Navbar/Navbar.jsx" << 'EOF'
import React, { useState, useEffect, useRef, useCallback } from 'react';
import { Link, useLocation } from 'react-router-dom';
import styles from './Navbar.module.css';

const NAV_LINKS = [
  { label: 'Workshops',   path: '/' },
  { label: 'My Bookings', path: '/my-bookings' },
  { label: 'About',       path: '/about' },
];

const Navbar = () => {
  const [open, setOpen]   = useState(false);
  const location          = useLocation();
  const navRef            = useRef(null);
  const btnRef            = useRef(null);
  const close             = useCallback(() => setOpen(false), []);

  /* Close on route change */
  useEffect(() => { close(); }, [location.pathname, close]);

  /* Close on Escape — return focus to hamburger */
  useEffect(() => {
    if (!open) return;
    const onKey = (e) => {
      if (e.key === 'Escape') { close(); btnRef.current?.focus(); }
    };
    document.addEventListener('keydown', onKey);
    return () => document.removeEventListener('keydown', onKey);
  }, [open, close]);

  /* Close on outside click */
  useEffect(() => {
    if (!open) return;
    const onOut = (e) => {
      if (navRef.current && !navRef.current.contains(e.target)) close();
    };
    document.addEventListener('mousedown', onOut);
    return () => document.removeEventListener('mousedown', onOut);
  }, [open, close]);

  return (
    <nav className={styles.nav} ref={navRef} aria-label="Main navigation">
      <div className={styles.inner}>

        <Link to="/" className={styles.logo} onClick={close}>
          Learn<span className={styles.accent}>Forge</span>
        </Link>

        {/* Hamburger — mobile only */}
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

        {/* Links */}
        <ul id="nav-links" className={`${styles.links} ${open ? styles.linksOpen : ''}`} role="list">
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
            <Link to="/sign-in" className={styles.signInBtn} onClick={close}>
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
.nav  { width: 100%; height: 100%; display: flex; align-items: center; background: var(--color-background); }

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

/* Logo */
.logo {
  font-family: var(--font-display);
  font-size: var(--text-xl);
  color: var(--color-text);
  letter-spacing: -.3px;
  flex-shrink: 0;
}
.accent { color: var(--color-primary); }

/* Hamburger */
.hamburger {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 5px;
  width: 36px;
  height: 36px;
  padding: 4px;
  background: none;
  border: none;
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: background var(--ease-fast);
}
.hamburger:hover { background: var(--color-surface-alt); }

.bar {
  display: block;
  width: 100%;
  height: 2px;
  background: var(--color-text);
  border-radius: 2px;
  transition: transform var(--ease-base), opacity var(--ease-base);
  transform-origin: center;
}
.hamburgerOpen .bar:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.hamburgerOpen .bar:nth-child(2) { opacity: 0; transform: scaleX(0); }
.hamburgerOpen .bar:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

/* Mobile nav */
.links {
  display: flex;
  flex-direction: column;
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: var(--color-background);
  border-top: 1px solid var(--color-border);
  box-shadow: var(--shadow-md);
  padding: var(--space-3);
  gap: var(--space-1);
  opacity: 0;
  visibility: hidden;
  transform: translateY(-8px);
  transition: opacity var(--ease-base), transform var(--ease-base), visibility var(--ease-base);
}
.linksOpen { opacity: 1; visibility: visible; transform: translateY(0); }

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
.link:hover  { background: var(--color-surface-alt); color: var(--color-text); }
.linkActive  { background: var(--color-primary-light); color: var(--color-primary); font-weight: 600; }

.signInBtn {
  display: block;
  text-align: center;
  padding: var(--space-3) var(--space-6);
  background: var(--color-primary);
  color: #fff !important;
  border-radius: var(--radius-md);
  font-weight: 600;
  transition: background var(--ease-fast), transform var(--ease-fast);
}
.signInBtn:hover { background: var(--color-primary-hover); transform: translateY(-1px); }

/* Desktop ≥ 768px */
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
    gap: var(--space-1);
    opacity: 1;
    visibility: visible;
    transform: none;
    height: 100%;
  }
  .link { padding: var(--space-2) var(--space-3); text-align: left; }
  .signInBtn { padding: var(--space-2) var(--space-5); }
}
EOF

# =============================================================================
# FIX 7 — WorkshopCard
# =============================================================================
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
  const badgeColor = LEVEL_COLORS[level] ?? 'var(--badge-intermediate)';
  const almostFull = spotsLeft !== undefined && spotsLeft > 0 && spotsLeft <= 5;
  const soldOut    = spotsLeft === 0;

  return (
    <article className={styles.card}>
      <div className={styles.cardHeader}>
        <div className={styles.topRow}>
          <span className={styles.badge} style={{ '--badge-bg': badgeColor }}>{level}</span>
          {almostFull && (
            <span className={styles.urgency} aria-label={`Only ${spotsLeft} spots left`}>
              🔥 {spotsLeft} left
            </span>
          )}
          {soldOut && <span className={`${styles.urgency} ${styles.soldOut}`}>Sold out</span>}
        </div>
        <h3 className={styles.title}>{title}</h3>
      </div>

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

      <div className={styles.cardFooter}>
        <Link
          to={`/workshop/${id}`}
          className={`${styles.btn} ${soldOut ? styles.btnDisabled : ''}`}
          aria-label={`View details for ${title}`}
          aria-disabled={soldOut}
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
.card:hover { transform: translateY(-3px); box-shadow: var(--shadow-lg); border-color: var(--color-primary); }

.cardHeader { padding: var(--space-5); background: var(--color-surface); border-bottom: 1px solid var(--color-border); }

.topRow { display: flex; align-items: center; justify-content: space-between; gap: var(--space-2); margin-bottom: var(--space-3); flex-wrap: wrap; }

.badge {
  display: inline-flex;
  align-items: center;
  padding: .2rem .6rem;
  background-color: var(--badge-bg, var(--badge-intermediate));
  color: #fff;
  font-size: var(--text-xs);
  font-weight: 700;
  letter-spacing: .5px;
  text-transform: uppercase;
  border-radius: var(--radius-full);
}

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
.soldOut { color: var(--color-text-muted); background: var(--color-surface-alt); border-color: var(--color-border); }

.title { font-size: var(--text-lg); font-weight: 700; color: var(--color-text); line-height: 1.3; }

.cardBody { padding: var(--space-5); flex: 1; display: flex; flex-direction: column; gap: var(--space-4); }

.meta { display: flex; flex-direction: column; gap: var(--space-1); }
.metaRow { display: flex; align-items: center; gap: var(--space-2); font-size: var(--text-sm); color: var(--color-text-muted); }
.metaRow dd { display: flex; align-items: center; gap: var(--space-2); }

.excerpt {
  font-size: var(--text-sm);
  color: var(--color-text-muted);
  line-height: 1.7;
  flex: 1;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.cardFooter { padding: var(--space-4) var(--space-5); border-top: 1px solid var(--color-border); background: var(--color-surface); }

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
.btnDisabled { background: var(--color-surface-alt); color: var(--color-text-muted) !important; cursor: not-allowed; pointer-events: none; }
EOF

# =============================================================================
# FIX 8 — RegistrationForm
# =============================================================================
w "$F/hooks/useFormValidation.js" << 'EOF'
import { useState, useCallback, useRef } from 'react';

const useFormValidation = (initialState, validate) => {
  const [values,       setValues]       = useState(initialState);
  const [errors,       setErrors]       = useState({});
  const [touched,      setTouched]      = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const validateRef = useRef(validate);
  validateRef.current = validate;
  const valuesRef = useRef(values);
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
    const cur  = valuesRef.current;
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

w "$F/components/RegistrationForm/RegistrationForm.jsx" << 'EOF'
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
EOF

w "$F/components/RegistrationForm/RegistrationForm.module.css" << 'EOF'
.card { background: var(--color-background); border: 1px solid var(--color-border); border-radius: var(--radius-xl); box-shadow: var(--shadow-md); overflow: hidden; }
.cardHead { padding: var(--space-5) var(--space-6); background: var(--color-surface); border-bottom: 1px solid var(--color-border); }
.formTitle { font-size: var(--text-xl); color: var(--color-text); }
.fields { padding: var(--space-6); display: flex; flex-direction: column; gap: var(--space-5); }
.field { display: flex; flex-direction: column; gap: .35rem; }
.label { font-size: var(--text-sm); font-weight: 600; color: var(--color-text); }
.req  { color: var(--color-error); margin-left: 2px; }
.hint { color: var(--color-text-light); font-weight: 400; font-size: var(--text-xs); }
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
.input:focus { outline: none; border-color: var(--color-primary); box-shadow: 0 0 0 3px rgba(37,99,235,.15); }
.input:disabled { opacity: .55; cursor: not-allowed; background: var(--color-surface-alt); }
.select { cursor: pointer; }
.textarea { resize: vertical; min-height: 80px; }
.inputErr { border-color: var(--color-error) !important; background: var(--color-error-bg); }
.inputErr:focus { box-shadow: 0 0 0 3px rgba(220,38,38,.15) !important; }
.errMsg { font-size: var(--text-xs); color: var(--color-error); font-weight: 500; }
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
.btnSpinner {
  display: inline-block;
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,.35);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin .7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
.success {
  display: flex; flex-direction: column; align-items: center; text-align: center;
  gap: var(--space-3); padding: var(--space-10) var(--space-6);
  background: var(--color-background);
  border: 1px solid var(--color-success); border-radius: var(--radius-xl); box-shadow: var(--shadow-md);
}
.successIcon { font-size: 2.5rem; }
.success h3  { font-size: var(--text-xl); color: var(--color-success); }
.success p   { font-size: var(--text-sm); color: var(--color-text-muted); }
.confirmId   { font-size: var(--text-xs); color: var(--color-text-light); }
.confirmId code { color: var(--color-text); font-size: var(--text-sm); }
.soldMsg { padding: var(--space-6); font-size: var(--text-sm); color: var(--color-text-muted); line-height: 1.7; }
EOF

# =============================================================================
# FIX 9 — WorkshopList page
# =============================================================================
w "$F/pages/WorkshopList/WorkshopList.jsx" << 'EOF'
import React, { useState, useEffect } from 'react';
import WorkshopCard from '../../components/WorkshopCard/WorkshopCard';
import styles from './WorkshopList.module.css';

const WORKSHOPS = [
  { id: 1, title: 'Advanced React Patterns',        date: '2026-05-15', instructor: 'Jane Doe',      level: 'Advanced',     spotsLeft: 3,  excerpt: 'Master advanced React concepts including higher-order components, render props, and custom hooks for scalable applications.' },
  { id: 2, title: 'Python Django Mastery',          date: '2026-05-22', instructor: 'John Smith',    level: 'Intermediate', spotsLeft: 12, excerpt: 'Build robust backend architectures with Django. Learn ORM optimizations, middleware, and class-based views.' },
  { id: 3, title: 'UI/UX Fundamentals for Engineers', date: '2026-06-05', instructor: 'Alice Johnson', level: 'Beginner',     spotsLeft: 20, excerpt: 'Understand basic design principles, typography, and color theory to build better interfaces.' },
  { id: 4, title: 'Fullstack Next.js Development',  date: '2026-06-12', instructor: 'Bob Williams',  level: 'Intermediate', spotsLeft: 8,  excerpt: 'Create high-performance server-side rendered applications with Next.js app router and server actions.' },
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
      <header className={styles.hero}>
        <p className={styles.eyebrow}>Expert-led sessions</p>
        <h1 className={styles.heading}>Upcoming Workshops</h1>
        <p className={styles.subheading}>
          Sharpen your skills with hands-on workshops led by industry practitioners.
          Limited spots — register early.
        </p>
      </header>

      {loading ? (
        <div className={styles.center} role="status" aria-live="polite">
          <span className="spinner" aria-hidden="true" />
          <p>Loading workshops…</p>
        </div>
      ) : workshops.length === 0 ? (
        <div className={styles.center}><p>No workshops scheduled yet — check back soon.</p></div>
      ) : (
        <div className={styles.grid}>
          {workshops.map(w => <WorkshopCard key={w.id} {...w} />)}
        </div>
      )}
    </section>
  );
};

export default WorkshopList;
EOF

w "$F/pages/WorkshopList/WorkshopList.module.css" << 'EOF'
.page { display: flex; flex-direction: column; gap: var(--space-12); }

.hero { text-align: center; max-width: 640px; margin: 0 auto; display: flex; flex-direction: column; gap: var(--space-3); }

.eyebrow { font-size: var(--text-xs); font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: var(--color-primary); }

.heading { font-size: clamp(var(--text-3xl), 5vw, var(--text-4xl)); }

.subheading { font-size: var(--text-lg); color: var(--color-text-muted); line-height: 1.7; }

.grid { display: grid; grid-template-columns: 1fr; gap: var(--space-6); }
@media (min-width: 640px)  { .grid { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 1024px) { .grid { grid-template-columns: repeat(3, 1fr); } }

.center { display: flex; flex-direction: column; align-items: center; gap: var(--space-4); padding: var(--space-16) 0; color: var(--color-text-muted); font-size: var(--text-sm); }
EOF

# =============================================================================
# FIX 10 — WorkshopDetails page
# =============================================================================
w "$F/pages/WorkshopDetails/WorkshopDetails.jsx" << 'EOF'
import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import RegistrationForm from '../../components/RegistrationForm/RegistrationForm';
import styles from './WorkshopDetails.module.css';

const WORKSHOPS = [
  { id: 1, title: 'Advanced React Patterns',        date: '2026-05-15', instructor: 'Jane Doe',      level: 'Advanced',     duration: '4 hours', price: '$149', spotsLeft: 3,  description: 'This intensive workshop dives deep into the advanced patterns used in modern React applications. You will learn higher-order components, render props, compound components, and custom hooks. Includes practical exercises on state management optimizations and React Profiler performance tuning.' },
  { id: 2, title: 'Python Django Mastery',          date: '2026-05-22', instructor: 'John Smith',    level: 'Intermediate', duration: '6 hours', price: '$199', spotsLeft: 12, description: 'Elevate your backend engineering skills with Django. This session covers ORM performance optimizations, custom middleware development, and class-based views for cleaner code. Designed for developers with basic Django knowledge.' },
  { id: 3, title: 'UI/UX Fundamentals for Engineers', date: '2026-06-05', instructor: 'Alice Johnson', level: 'Beginner',     duration: '3 hours', price: '$99',  spotsLeft: 20, description: 'This workshop bridges the gap between engineering and design. Gain a solid foundation in visual hierarchy, typography, color theory, and responsive layout — taught from an engineer\'s perspective.' },
  { id: 4, title: 'Fullstack Next.js Development',  date: '2026-06-12', instructor: 'Bob Williams',  level: 'Intermediate', duration: '5 hours', price: '$179', spotsLeft: 8,  description: 'A hands-on fullstack workshop covering Next.js App Router, React Server Components, server actions, and data fetching strategies. Build a complete production-ready app from scratch during the session.' },
];

const LEVEL_COLORS = { Beginner: 'var(--badge-beginner)', Intermediate: 'var(--badge-intermediate)', Advanced: 'var(--badge-advanced)' };

const fmtDate = (d) => new Date(d).toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });

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

  if (loading) return (
    <div className={styles.center} role="status">
      <span className="spinner" aria-hidden="true" />
      <p>Loading workshop…</p>
    </div>
  );

  if (!workshop) return (
    <div className={styles.center}>
      <div className={styles.notFoundIcon}>🔍</div>
      <h2>Workshop not found</h2>
      <p>We couldn't find that workshop.</p>
      <Link to="/" className={styles.backBtn}>← Browse workshops</Link>
    </div>
  );

  const spotsLow = workshop.spotsLeft !== undefined && workshop.spotsLeft > 0 && workshop.spotsLeft <= 5;
  const soldOut  = workshop.spotsLeft === 0;

  return (
    <article>
      <Link to="/" className={styles.backLink}>← Back to all workshops</Link>

      <div className={styles.grid}>
        <section aria-label="Workshop information">
          <div className={styles.titleBlock}>
            <span className={styles.levelBadge} style={{ '--badge-bg': LEVEL_COLORS[workshop.level] ?? 'var(--badge-intermediate)' }}>
              {workshop.level}
            </span>
            <h1 className={styles.title}>{workshop.title}</h1>
          </div>

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

          <dl className={styles.metaGrid}>
            {[
              { icon: '📅', label: 'Date',       value: fmtDate(workshop.date) },
              { icon: '👤', label: 'Instructor', value: workshop.instructor },
              { icon: '⏱️', label: 'Duration',  value: workshop.duration },
              { icon: '💳', label: 'Price',      value: workshop.price },
            ].map(({ icon, label, value }) => (
              <div key={label} className={styles.metaCard}>
                <span className={styles.metaIcon} aria-hidden="true">{icon}</span>
                <div>
                  <dt className={styles.metaLabel}>{label}</dt>
                  <dd className={styles.metaValue}>{value}</dd>
                </div>
              </div>
            ))}
          </dl>

          <div className={styles.description}>
            <h2>About this workshop</h2>
            <p>{workshop.description}</p>
          </div>
        </section>

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
.backLink { display: inline-flex; align-items: center; gap: var(--space-1); font-size: var(--text-sm); font-weight: 500; color: var(--color-text-muted); margin-bottom: var(--space-6); padding: var(--space-1) var(--space-2); border-radius: var(--radius-sm); transition: color var(--ease-fast), background var(--ease-fast); }
.backLink:hover { color: var(--color-primary); background: var(--color-primary-light); }

.grid { display: grid; grid-template-columns: 1fr; gap: var(--space-10); }
@media (min-width: 1024px) { .grid { grid-template-columns: 3fr 2fr; align-items: start; } }

.titleBlock { margin-bottom: var(--space-5); }

.levelBadge { display: inline-block; padding: .25rem .75rem; background-color: var(--badge-bg, var(--badge-intermediate)); color: #fff; font-size: var(--text-xs); font-weight: 700; letter-spacing: .5px; text-transform: uppercase; border-radius: var(--radius-full); margin-bottom: var(--space-3); }

.title { font-size: clamp(var(--text-2xl), 4vw, var(--text-4xl)); line-height: 1.15; }

.spotsWarning { display: flex; align-items: center; gap: var(--space-2); padding: var(--space-3) var(--space-4); background: var(--color-warning-bg); border: 1px solid rgba(217,119,6,.3); border-radius: var(--radius-md); font-size: var(--text-sm); font-weight: 500; color: var(--color-warning); margin-bottom: var(--space-6); }
.soldOutBanner { background: var(--color-surface-alt); border-color: var(--color-border); color: var(--color-text-muted); }

.metaGrid { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-3); margin-bottom: var(--space-8); }
@media (max-width: 480px) { .metaGrid { grid-template-columns: 1fr; } }

.metaCard { display: flex; align-items: flex-start; gap: var(--space-3); padding: var(--space-4); background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg); }
.metaIcon  { font-size: 1.35rem; line-height: 1; flex-shrink: 0; margin-top: 2px; }
.metaLabel { display: block; font-size: var(--text-xs); font-weight: 600; text-transform: uppercase; letter-spacing: .5px; color: var(--color-text-light); margin-bottom: var(--space-1); }
.metaValue { font-size: var(--text-base); font-weight: 600; color: var(--color-text); }

.description h2 { font-size: var(--text-xl); margin-bottom: var(--space-3); }
.description p  { font-size: var(--text-base); line-height: 1.8; color: var(--color-text-muted); }

.formCol { position: sticky; top: calc(var(--navbar-height) + var(--space-6)); }

.center { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 40vh; gap: var(--space-4); text-align: center; color: var(--color-text-muted); }
.notFoundIcon { font-size: 3rem; }
.backBtn { display: inline-block; margin-top: var(--space-2); padding: var(--space-3) var(--space-6); background: var(--color-primary); color: #fff; border-radius: var(--radius-md); font-weight: 600; transition: background var(--ease-fast); }
.backBtn:hover { background: var(--color-primary-hover); color: #fff; }
EOF

# =============================================================================
# FIX 11 — NEW: My Bookings page
# =============================================================================
w "$F/pages/MyBookings/MyBookings.jsx" << 'EOF'
import React from 'react';
import { Link } from 'react-router-dom';
import styles from './MyBookings.module.css';

/* Simulated booked workshops — in a real app this comes from an API / auth session */
const MY_BOOKINGS = [
  { id: 1, title: 'Advanced React Patterns',  date: '2026-05-15', status: 'Confirmed', level: 'Advanced'     },
  { id: 2, title: 'Python Django Mastery',    date: '2026-05-22', status: 'Confirmed', level: 'Intermediate' },
];

const fmtDate = (d) => new Date(d).toLocaleDateString('en-US', { day: 'numeric', month: 'long', year: 'numeric' });

const MyBookings = () => {
  const isLoggedIn = false; /* flip to true once auth is wired */

  return (
    <div className={styles.page}>
      <header className={styles.hero}>
        <h1 className={styles.heading}>My Bookings</h1>
        <p className={styles.sub}>All your registered workshops in one place.</p>
      </header>

      {!isLoggedIn ? (
        /* ── Not logged in state ── */
        <div className={styles.authPrompt}>
          <div className={styles.authIcon} aria-hidden="true">🔒</div>
          <h2>Sign in to view your bookings</h2>
          <p>Your bookings are saved to your account. Sign in to access them.</p>
          <Link to="/sign-in" className={styles.primaryBtn}>Sign In</Link>
          <p className={styles.orText}>
            Don't have an account?{' '}
            <Link to="/sign-in" className={styles.inlineLink}>Create one — it's free</Link>
          </p>
        </div>
      ) : MY_BOOKINGS.length === 0 ? (
        /* ── Empty state ── */
        <div className={styles.empty}>
          <div className={styles.emptyIcon} aria-hidden="true">📋</div>
          <h2>No bookings yet</h2>
          <p>You haven't registered for any workshops.</p>
          <Link to="/" className={styles.primaryBtn}>Browse Workshops</Link>
        </div>
      ) : (
        /* ── Bookings list ── */
        <ul className={styles.list} aria-label="Your bookings">
          {MY_BOOKINGS.map(b => (
            <li key={b.id} className={styles.bookingCard}>
              <div className={styles.bookingInfo}>
                <span className={`${styles.statusBadge} ${b.status === 'Confirmed' ? styles.confirmed : styles.pending}`}>
                  {b.status === 'Confirmed' ? '✓ Confirmed' : '⏳ Pending'}
                </span>
                <h3 className={styles.bookingTitle}>{b.title}</h3>
                <p className={styles.bookingDate}>📅 {fmtDate(b.date)} · {b.level}</p>
              </div>
              <Link to={`/workshop/${b.id}`} className={styles.viewBtn}>View Details →</Link>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default MyBookings;
EOF

w "$F/pages/MyBookings/MyBookings.module.css" << 'EOF'
.page { display: flex; flex-direction: column; gap: var(--space-10); max-width: 760px; margin: 0 auto; }

.hero { text-align: center; }
.heading { font-size: clamp(var(--text-2xl), 4vw, var(--text-3xl)); margin-bottom: var(--space-2); }
.sub { color: var(--color-text-muted); font-size: var(--text-base); }

/* Auth prompt */
.authPrompt {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: var(--space-4);
  padding: var(--space-12) var(--space-6);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-sm);
}
.authIcon  { font-size: 3rem; }
.authPrompt h2 { font-size: var(--text-xl); }
.authPrompt p  { color: var(--color-text-muted); font-size: var(--text-sm); max-width: 360px; }

/* Empty state */
.empty { display: flex; flex-direction: column; align-items: center; text-align: center; gap: var(--space-4); padding: var(--space-12) var(--space-4); }
.emptyIcon { font-size: 3rem; }
.empty h2 { font-size: var(--text-xl); }
.empty p  { color: var(--color-text-muted); font-size: var(--text-sm); }

/* Buttons */
.primaryBtn {
  display: inline-block;
  padding: var(--space-3) var(--space-8);
  background: var(--color-primary);
  color: #fff !important;
  border-radius: var(--radius-md);
  font-weight: 600;
  font-size: var(--text-base);
  transition: background var(--ease-fast), transform var(--ease-fast);
}
.primaryBtn:hover { background: var(--color-primary-hover); transform: translateY(-1px); }

.orText { font-size: var(--text-sm); color: var(--color-text-muted); }
.inlineLink { color: var(--color-primary); font-weight: 600; }
.inlineLink:hover { text-decoration: underline; }

/* Booking list */
.list { display: flex; flex-direction: column; gap: var(--space-4); }

.bookingCard {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-4);
  padding: var(--space-5) var(--space-6);
  background: var(--color-background);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-sm);
  flex-wrap: wrap;
  transition: box-shadow var(--ease-base), border-color var(--ease-base);
}
.bookingCard:hover { box-shadow: var(--shadow-md); border-color: var(--color-primary); }

.bookingInfo { display: flex; flex-direction: column; gap: var(--space-2); }

.statusBadge { display: inline-block; padding: .2rem .6rem; border-radius: var(--radius-full); font-size: var(--text-xs); font-weight: 700; letter-spacing: .3px; width: fit-content; }
.confirmed   { background: var(--color-success-bg); color: var(--color-success); }
.pending     { background: var(--color-warning-bg); color: var(--color-warning); }

.bookingTitle { font-size: var(--text-lg); font-weight: 700; color: var(--color-text); }
.bookingDate  { font-size: var(--text-sm); color: var(--color-text-muted); }

.viewBtn { padding: var(--space-2) var(--space-5); background: var(--color-primary-light); color: var(--color-primary) !important; border-radius: var(--radius-md); font-weight: 600; font-size: var(--text-sm); white-space: nowrap; transition: background var(--ease-fast); }
.viewBtn:hover { background: var(--color-primary); color: #fff !important; }
EOF

# =============================================================================
# FIX 12 — NEW: About page
# =============================================================================
w "$F/pages/About/About.jsx" << 'EOF'
import React from 'react';
import { Link } from 'react-router-dom';
import styles from './About.module.css';

const TEAM = [
  { name: 'Jane Doe',     role: 'React & Frontend',  avatar: '👩‍💻' },
  { name: 'John Smith',   role: 'Python & Django',    avatar: '👨‍💻' },
  { name: 'Alice Johnson',role: 'UI/UX Design',       avatar: '🎨' },
  { name: 'Bob Williams', role: 'Fullstack & DevOps', avatar: '🛠️' },
];

const VALUES = [
  { icon: '🎯', title: 'Practical Learning',   desc: 'Every workshop is hands-on. You build real things, not just watch slides.' },
  { icon: '📱', title: 'Mobile-First',          desc: 'Designed for students on the go. Our platform works beautifully on any device.' },
  { icon: '♿', title: 'Accessible to All',    desc: 'We follow WCAG 2.1 AA standards so every learner can participate fully.' },
  { icon: '🔓', title: 'Open Knowledge',        desc: 'Rooted in the FOSSEE mission — free and open-source software for education.' },
];

const About = () => (
  <div className={styles.page}>

    {/* ── Hero ── */}
    <section className={styles.hero}>
      <p className={styles.eyebrow}>About LearnForge</p>
      <h1 className={styles.heading}>Built for curious minds</h1>
      <p className={styles.sub}>
        LearnForge is a workshop booking platform developed as part of the FOSSEE initiative
        to make expert-led technical education accessible to every student in India.
      </p>
      <Link to="/" className={styles.primaryBtn}>Browse Workshops →</Link>
    </section>

    {/* ── Values ── */}
    <section aria-labelledby="values-heading">
      <h2 id="values-heading" className={styles.sectionHeading}>What we stand for</h2>
      <div className={styles.valuesGrid}>
        {VALUES.map(({ icon, title, desc }) => (
          <div key={title} className={styles.valueCard}>
            <div className={styles.valueIcon} aria-hidden="true">{icon}</div>
            <h3 className={styles.valueTitle}>{title}</h3>
            <p className={styles.valueDesc}>{desc}</p>
          </div>
        ))}
      </div>
    </section>

    {/* ── Instructors ── */}
    <section aria-labelledby="team-heading">
      <h2 id="team-heading" className={styles.sectionHeading}>Meet our instructors</h2>
      <div className={styles.teamGrid}>
        {TEAM.map(({ name, role, avatar }) => (
          <div key={name} className={styles.teamCard}>
            <div className={styles.teamAvatar} aria-hidden="true">{avatar}</div>
            <h3 className={styles.teamName}>{name}</h3>
            <p className={styles.teamRole}>{role}</p>
          </div>
        ))}
      </div>
    </section>

    {/* ── CTA ── */}
    <section className={styles.cta}>
      <h2>Ready to start learning?</h2>
      <p>Browse upcoming workshops and secure your spot today.</p>
      <Link to="/" className={styles.primaryBtn}>View Workshops →</Link>
    </section>

  </div>
);

export default About;
EOF

w "$F/pages/About/About.module.css" << 'EOF'
.page { display: flex; flex-direction: column; gap: var(--space-16); }

/* Hero */
.hero { display: flex; flex-direction: column; align-items: center; text-align: center; gap: var(--space-5); padding: var(--space-8) 0; }
.eyebrow { font-size: var(--text-xs); font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: var(--color-primary); }
.heading { font-size: clamp(var(--text-3xl), 5vw, var(--text-4xl)); }
.sub { font-size: var(--text-lg); color: var(--color-text-muted); max-width: 600px; line-height: 1.7; }

/* Section heading */
.sectionHeading { font-size: var(--text-2xl); text-align: center; margin-bottom: var(--space-8); }

/* Values grid */
.valuesGrid { display: grid; grid-template-columns: 1fr; gap: var(--space-5); }
@media (min-width: 600px)  { .valuesGrid { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 1024px) { .valuesGrid { grid-template-columns: repeat(4, 1fr); } }

.valueCard { padding: var(--space-6); background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); display: flex; flex-direction: column; gap: var(--space-3); transition: box-shadow var(--ease-base), transform var(--ease-base); }
.valueCard:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }

.valueIcon  { font-size: 2rem; line-height: 1; }
.valueTitle { font-size: var(--text-lg); font-weight: 700; color: var(--color-text); }
.valueDesc  { font-size: var(--text-sm); color: var(--color-text-muted); line-height: 1.7; }

/* Team grid */
.teamGrid { display: grid; grid-template-columns: repeat(2, 1fr); gap: var(--space-5); }
@media (min-width: 768px) { .teamGrid { grid-template-columns: repeat(4, 1fr); } }

.teamCard { display: flex; flex-direction: column; align-items: center; text-align: center; gap: var(--space-3); padding: var(--space-6) var(--space-4); background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-xl); transition: box-shadow var(--ease-base); }
.teamCard:hover { box-shadow: var(--shadow-md); }

.teamAvatar { font-size: 3rem; line-height: 1; width: 72px; height: 72px; display: flex; align-items: center; justify-content: center; background: var(--color-primary-light); border-radius: var(--radius-full); }
.teamName   { font-size: var(--text-base); font-weight: 700; color: var(--color-text); }
.teamRole   { font-size: var(--text-sm); color: var(--color-text-muted); }

/* CTA */
.cta { display: flex; flex-direction: column; align-items: center; text-align: center; gap: var(--space-4); padding: var(--space-12) var(--space-6); background: var(--color-primary-light); border: 1px solid rgba(37,99,235,.2); border-radius: var(--radius-xl); }
.cta h2 { font-size: var(--text-2xl); }
.cta p  { font-size: var(--text-base); color: var(--color-text-muted); }

/* Button */
.primaryBtn { display: inline-block; padding: var(--space-3) var(--space-8); background: var(--color-primary); color: #fff !important; border-radius: var(--radius-md); font-weight: 600; transition: background var(--ease-fast), transform var(--ease-fast); }
.primaryBtn:hover { background: var(--color-primary-hover); transform: translateY(-1px); }
EOF

# =============================================================================
# FIX 13 — NEW: Sign In page
# =============================================================================
w "$F/pages/SignIn/SignIn.jsx" << 'EOF'
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
EOF

w "$F/pages/SignIn/SignIn.module.css" << 'EOF'
.page { display: flex; justify-content: center; align-items: flex-start; padding: var(--space-6) var(--space-4); min-height: 70vh; }

.card {
  width: 100%;
  max-width: 440px;
  background: var(--color-background);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-lg);
  overflow: hidden;
  padding: var(--space-8);
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

/* Logo */
.logoWrap { text-align: center; }
.logo { font-family: var(--font-display); font-size: var(--text-2xl); color: var(--color-text); }
.accent { color: var(--color-primary); }
.tagline { font-size: var(--text-sm); color: var(--color-text-muted); margin-top: var(--space-1); }

/* Tabs */
.tabs {
  display: flex;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: 4px;
  gap: 4px;
}
.tab {
  flex: 1;
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-md);
  font-size: var(--text-sm);
  font-weight: 600;
  color: var(--color-text-muted);
  background: transparent;
  border: none;
  cursor: pointer;
  transition: background var(--ease-fast), color var(--ease-fast);
}
.tabActive { background: var(--color-background); color: var(--color-primary); box-shadow: var(--shadow-sm); }

/* Form */
.form { display: flex; flex-direction: column; gap: var(--space-4); }

.field { display: flex; flex-direction: column; gap: var(--space-2); }
.label { font-size: var(--text-sm); font-weight: 600; color: var(--color-text); }
.req   { color: var(--color-error); }

.passwordRow { display: flex; align-items: baseline; justify-content: space-between; }
.forgotLink  { font-size: var(--text-xs); color: var(--color-primary); background: none; border: none; cursor: pointer; padding: 0; }
.forgotLink:hover { text-decoration: underline; }

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
.input::placeholder { color: var(--color-text-light); }
.input:hover:not(:disabled) { border-color: var(--color-text-light); }
.input:focus { outline: none; border-color: var(--color-primary); box-shadow: 0 0 0 3px rgba(37,99,235,.15); }
.input:disabled { opacity: .55; cursor: not-allowed; }

.errorBanner { padding: var(--space-3) var(--space-4); background: var(--color-error-bg); border: 1px solid rgba(220,38,38,.3); border-radius: var(--radius-md); font-size: var(--text-sm); font-weight: 500; color: var(--color-error); }

.submitBtn {
  width: 100%;
  padding: var(--space-3) var(--space-6);
  background: var(--color-primary);
  color: #fff;
  border: none;
  border-radius: var(--radius-md);
  font-weight: 600;
  font-size: var(--text-base);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  transition: background var(--ease-fast), transform var(--ease-fast), opacity var(--ease-fast);
}
.submitBtn:hover:not(:disabled) { background: var(--color-primary-hover); transform: translateY(-1px); }
.submitBtn:disabled { opacity: .65; cursor: not-allowed; transform: none; }

.spinner {
  display: inline-block;
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,.35);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin .7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* Divider */
.divider { display: flex; align-items: center; gap: var(--space-3); color: var(--color-text-light); font-size: var(--text-sm); }
.divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--color-border); }

/* Social */
.socialBtns { display: flex; gap: var(--space-3); }
.socialBtn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  padding: var(--space-3);
  background: var(--color-surface);
  border: 1.5px solid var(--color-border);
  border-radius: var(--radius-md);
  font-size: var(--text-sm);
  font-weight: 600;
  color: var(--color-text);
  cursor: pointer;
  transition: border-color var(--ease-fast), box-shadow var(--ease-fast);
}
.socialBtn:hover { border-color: var(--color-primary); box-shadow: var(--shadow-sm); }

/* Footer */
.footer { text-align: center; font-size: var(--text-sm); color: var(--color-text-muted); }
.switchLink { background: none; border: none; color: var(--color-primary); font-weight: 600; font-size: var(--text-sm); cursor: pointer; padding: 0; }
.switchLink:hover { text-decoration: underline; }

/* Success */
.center { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 50vh; gap: var(--space-4); text-align: center; }
.successIcon { font-size: 3rem; }
.center h2 { font-size: var(--text-2xl); }
.center p  { color: var(--color-text-muted); }
.primaryBtn { display: inline-block; margin-top: var(--space-2); padding: var(--space-3) var(--space-8); background: var(--color-primary); color: #fff !important; border-radius: var(--radius-md); font-weight: 600; transition: background var(--ease-fast); }
.primaryBtn:hover { background: var(--color-primary-hover); }
EOF

# =============================================================================
# FIX 14 — App.jsx: wire ALL routes, no more wildcard 404 for real pages
# =============================================================================
w "$F/App.jsx" << 'EOF'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Suspense, lazy } from 'react';
import Layout from './components/Layout/Layout';

/* Route-level code splitting — each page is a separate JS chunk */
const WorkshopList    = lazy(() => import('./pages/WorkshopList/WorkshopList'));
const WorkshopDetails = lazy(() => import('./pages/WorkshopDetails/WorkshopDetails'));
const MyBookings      = lazy(() => import('./pages/MyBookings/MyBookings'));
const About           = lazy(() => import('./pages/About/About'));
const SignIn          = lazy(() => import('./pages/SignIn/SignIn'));

/* Inline loading fallback — no extra component needed */
const PageLoader = () => (
  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '40vh', gap: '1rem', color: 'var(--color-text-muted)', fontSize: 'var(--text-sm)' }}>
    <span className="spinner" aria-hidden="true" />
    <p>Loading…</p>
  </div>
);

/* 404 page — only for truly unknown URLs */
const NotFound = () => (
  <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '50vh', gap: '1rem', textAlign: 'center' }}>
    <div style={{ fontSize: '4rem' }}>🔍</div>
    <h2 style={{ fontFamily: 'var(--font-display)', fontSize: 'var(--text-3xl)' }}>Page not found</h2>
    <p style={{ color: 'var(--color-text-muted)', maxWidth: '360px' }}>
      The page you're looking for doesn't exist. Try browsing our workshops instead.
    </p>
    <a href="/" style={{ marginTop: '1rem', display: 'inline-block', padding: '0.75rem 2rem', background: 'var(--color-primary)', color: '#fff', borderRadius: 'var(--radius-md)', fontWeight: 600 }}>
      Browse Workshops
    </a>
  </div>
);

function App() {
  return (
    <Router>
      <Layout>
        <Suspense fallback={<PageLoader />}>
          <Routes>
            <Route path="/"             element={<WorkshopList />}    />
            <Route path="/workshop/:id" element={<WorkshopDetails />} />
            <Route path="/my-bookings"  element={<MyBookings />}      />
            <Route path="/about"        element={<About />}           />
            <Route path="/sign-in"      element={<SignIn />}          />
            {/* Catch-all — only truly unknown URLs land here */}
            <Route path="*"             element={<NotFound />}        />
          </Routes>
        </Suspense>
      </Layout>
    </Router>
  );
}

export default App;
EOF

# =============================================================================
# Done
# =============================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅  All fixes applied!"
echo ""
echo "Files updated / created:"
echo "  frontend/index.html                    SEO + Google Fonts"
echo "  frontend/src/main.jsx                  correct CSS paths"
echo "  frontend/src/styles/variables.css      design tokens"
echo "  frontend/src/styles/global.css         reset + focus ring"
echo "  frontend/src/App.jsx                   ALL routes wired"
echo "  frontend/src/components/Layout/        skip link, semantic HTML"
echo "  frontend/src/components/Navbar/        hamburger, a11y"
echo "  frontend/src/components/WorkshopCard/  badge fix, urgency chip"
echo "  frontend/src/components/RegistrationForm/ blur validation"
echo "  frontend/src/hooks/useFormValidation.js stale-closure fix"
echo "  frontend/src/pages/WorkshopList/       hero, grid, loader"
echo "  frontend/src/pages/WorkshopDetails/    meta grid, sticky form"
echo "  frontend/src/pages/MyBookings/         NEW — bookings page"
echo "  frontend/src/pages/About/              NEW — about page"
echo "  frontend/src/pages/SignIn/             NEW — sign in / sign up"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Run the app:"
echo "  cd frontend"
echo "  npm install"
echo "  npm run dev"
echo "  → open http://localhost:5173"
echo ""
echo "Every nav link now has a real page:"
echo "  /            → Workshop list"
echo "  /workshop/1  → Workshop detail + registration form"
echo "  /my-bookings → My Bookings (login prompt)"
echo "  /about       → About page with team + values"
echo "  /sign-in     → Sign In / Create Account with tabs"
echo ""
