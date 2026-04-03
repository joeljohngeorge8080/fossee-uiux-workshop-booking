import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import styles from './Navbar.module.css';

const Navbar = () => {
    const [isOpen, setIsOpen] = useState(false);
    const location = useLocation();

    const toggleMenu = () => {
        setIsOpen(!isOpen);
    };

    const closeMenu = () => {
        setIsOpen(false);
    };

    const navLinks = [
        { name: 'Workshops', path: '/' },
        { name: 'My Bookings', path: '/bookings' },
        { name: 'About', path: '/about' },
    ];

    return (
        <nav className={styles.navbar}>
            <div className={styles.navContainer}>
                <Link to="/" className={styles.logo} onClick={closeMenu}>
                    Learn<span className={styles.accent}>Forge</span>
                </Link>

                {/* Hamburger Menu Icon */}
                <button
                    className={`${styles.hamburger} ${isOpen ? styles.active : ''}`}
                    onClick={toggleMenu}
                    aria-label="Toggle navigation menu"
                    aria-expanded={isOpen}
                >
                    <span className={styles.bar}></span>
                    <span className={styles.bar}></span>
                    <span className={styles.bar}></span>
                </button>

                {/* Navigation Links */}
                <ul className={`${styles.navMenu} ${isOpen ? styles.activeMenu : ''}`}>
                    {navLinks.map((link) => (
                        <li key={link.name} className={styles.navItem}>
                            <Link
                                to={link.path}
                                className={`${styles.navLink} ${location.pathname === link.path ? styles.activeLink : ''}`}
                                onClick={closeMenu}
                            >
                                {link.name}
                            </Link>
                        </li>
                    ))}
                    <li className={styles.navItem}>
                        <Link to="/login" className={styles.loginBtn} onClick={closeMenu}>
                            Sign In
                        </Link>
                    </li>
                </ul>
            </div>
        </nav>
    );
};

export default Navbar;
