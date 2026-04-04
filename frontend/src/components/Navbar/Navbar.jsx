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
