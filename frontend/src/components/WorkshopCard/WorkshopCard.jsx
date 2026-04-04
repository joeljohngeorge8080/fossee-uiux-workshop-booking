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
