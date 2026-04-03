import React from 'react';
import Navbar from '../Navbar/Navbar';
import styles from './Layout.module.css';

const Layout = ({ children }) => {
    return (
        <div className={styles.container}>
            <header className={styles.header}>
                <Navbar />
            </header>
            <main className={styles.main}>
                {children}
            </main>
            <footer className={styles.footer}>
                <div className={styles.footerContent}>
                    <p>&copy; {new Date().getFullYear()} Workshop Booking Platform.</p>
                </div>
            </footer>
        </div>
    );
};

export default Layout;
