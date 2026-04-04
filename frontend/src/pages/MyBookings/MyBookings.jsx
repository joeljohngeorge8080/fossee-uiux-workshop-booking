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
