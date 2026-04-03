import React from 'react';
import Navbar from '../Navbar/Navbar';
import styles from './Layout.module.css';

const Layout = ({ children }) => (
    <div className={styles.container}>
        <a href="#main-content" className="skip-to-main">Skip to main content</a>
        <header className={styles.header}>
            <Navbar />
        </header>
        <main id="main-content" className={styles.main} tabIndex={-1}>
            {children}
        </main>
        <footer className={styles.footer} role="contentinfo">
            <div className={styles.footerContent}>
                <p>&copy; {new Date().getFullYear()} LearnForge. All rights reserved.</p>
            </div>
        </footer>
    </div>
);

export default Layout;
