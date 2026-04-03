import React, { useState, useCallback, useEffect } from 'react';
import { Link, useLocation } from 'react-router-dom';
import styles from './Navbar.module.css';

const NAV_LINKS = [
    { name: 'Workshops', path: '/' },
    { name: 'My Bookings', path: '/bookings' },
    { name: 'About', path: '/about' },
];

const Navbar = () => {
    const [isOpen, setIsOpen] = useState(false);
    const location = useLocation();

    const close = useCallback(() => setIsOpen(false), []);
    const toggle = useCallback(() => setIsOpen(prev => !prev), []);

    // Close menu when route changes (user tapped a link)
    useEffect(() => { close(); }, [location.pathname, close]);

    // Allow Escape key to close the mobile menu (keyboard accessibility)
    useEffect(() => {
        if (!isOpen) return;
        const onKey = (e) => { if (e.key === 'Escape') close(); };
        document.addEventListener('keydown', onKey);
        return () => document.removeEventListener('keydown', onKey);
    }, [isOpen, close]);

    return (
        <nav className={styles.navbar} aria-label="Main navigation">
            <div className={styles.navContainer}>
                <Link to="/" className={styles.logo} aria-label="LearnForge home">
                    Learn<span className={styles.accent}>Forge</span>
                </Link>

                {/* Hamburger — uses aria-controls to associate with the menu */}
                <button
                    className={`${styles.hamburger} ${isOpen ? styles.hamburgerOpen : ''}`}
                    onClick={toggle}
                    aria-label={isOpen ? 'Close navigation menu' : 'Open navigation menu'}
                    aria-expanded={isOpen}
                    aria-controls="main-nav-menu"
                >
                    <span className={styles.bar} />
                    <span className={styles.bar} />
                    <span className={styles.bar} />
                </button>

                <ul
                    id="main-nav-menu"
                    className={`${styles.navMenu} ${isOpen ? styles.navMenuOpen : ''}`}
                    role="list"
                >
                    {NAV_LINKS.map(({ name, path }) => {
                        const isCurrent = location.pathname === path;
                        return (
                            <li key={name}>
                                <Link
                                    to={path}
                                    className={`${styles.navLink} ${isCurrent ? styles.navLinkActive : ''}`}
                                    aria-current={isCurrent ? 'page' : undefined}
                                >
                                    {name}
                                </Link>
                            </li>
                        );
                    })}
                    <li>
                        <Link to="/login" className={styles.signInBtn}>
                            Sign In
                        </Link>
                    </li>
                </ul>
            </div>
        </nav>
    );
};

export default Navbar;
