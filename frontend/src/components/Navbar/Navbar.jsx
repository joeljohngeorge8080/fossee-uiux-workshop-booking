import React, { useState, useEffect, useRef, useCallback } from 'react';
import { Link, useLocation } from 'react-router-dom';
import styles from './Navbar.module.css';

const NAV_LINKS = [
    { name: 'Workshops',   path: '/' },
    { name: 'My Bookings', path: '/bookings' },
    { name: 'About',       path: '/about' },
];

const Navbar = () => {
    const [isOpen, setIsOpen] = useState(false);
    const location = useLocation();
    const navRef = useRef(null);
    const hamburgerRef = useRef(null);
    const closeMenu = useCallback(() => setIsOpen(false), []);

    useEffect(() => { closeMenu(); }, [location.pathname, closeMenu]);

    useEffect(() => {
        if (!isOpen) return;
        const handleKey = (e) => {
            if (e.key === 'Escape') { closeMenu(); hamburgerRef.current?.focus(); }
        };
        document.addEventListener('keydown', handleKey);
        return () => document.removeEventListener('keydown', handleKey);
    }, [isOpen, closeMenu]);

    useEffect(() => {
        if (!isOpen) return;
        const handleOutside = (e) => {
            if (navRef.current && !navRef.current.contains(e.target)) closeMenu();
        };
        document.addEventListener('mousedown', handleOutside);
        return () => document.removeEventListener('mousedown', handleOutside);
    }, [isOpen, closeMenu]);

    return (
        <nav className={styles.navbar} ref={navRef} aria-label="Main navigation">
            <div className={styles.navContainer}>
                <Link to="/" className={styles.logo} onClick={closeMenu}>
                    Learn<span className={styles.accent}>Forge</span>
                </Link>
                <button
                    ref={hamburgerRef}
                    className={`${styles.hamburger} ${isOpen ? styles.active : ''}`}
                    onClick={() => setIsOpen((p) => !p)}
                    aria-label={isOpen ? 'Close navigation menu' : 'Open navigation menu'}
                    aria-expanded={isOpen}
                    aria-controls="nav-menu"
                >
                    <span className={styles.bar} />
                    <span className={styles.bar} />
                    <span className={styles.bar} />
                </button>
                <ul id="nav-menu" className={`${styles.navMenu} ${isOpen ? styles.activeMenu : ''}`} role="list">
                    {NAV_LINKS.map((link) => (
                        <li key={link.name} className={styles.navItem} role="listitem">
                            <Link
                                to={link.path}
                                className={`${styles.navLink} ${location.pathname === link.path ? styles.activeLink : ''}`}
                                onClick={closeMenu}
                                aria-current={location.pathname === link.path ? 'page' : undefined}
                            >
                                {link.name}
                            </Link>
                        </li>
                    ))}
                    <li className={styles.navItem} role="listitem">
                        <Link to="/login" className={styles.loginBtn} onClick={closeMenu}>Sign In</Link>
                    </li>
                </ul>
            </div>
        </nav>
    );
};

export default Navbar;
