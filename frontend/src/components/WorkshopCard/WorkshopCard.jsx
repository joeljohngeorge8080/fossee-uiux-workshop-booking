import React, { memo } from 'react';
import { Link } from 'react-router-dom';
import styles from './WorkshopCard.module.css';

const LEVEL_COLORS = {
    Beginner:     'var(--badge-beginner)',
    Intermediate: 'var(--badge-intermediate)',
    Advanced:     'var(--badge-advanced)',
};

const formatDate = (dateStr) =>
    new Date(dateStr).toLocaleDateString('en-US', { day: 'numeric', month: 'short', year: 'numeric' });

const WorkshopCard = memo(({ id, title, date, instructor, excerpt, level, spotsLeft }) => {
    const badgeColor   = LEVEL_COLORS[level] ?? 'var(--badge-intermediate)';
    const isAlmostFull = spotsLeft !== undefined && spotsLeft <= 5;

    return (
        <article className={styles.card}>
            <div className={styles.cardHeader}>
                <div className={styles.cardHeaderTop}>
                    <span className={styles.levelBadge} style={{ '--badge-color': badgeColor }}>{level}</span>
                    {isAlmostFull && spotsLeft > 0 && (
                        <span className={styles.urgency} aria-label={`Only ${spotsLeft} spot${spotsLeft === 1 ? '' : 's'} remaining`}>
                            {spotsLeft} left
                        </span>
                    )}
                    {spotsLeft === 0 && (
                        <span className={styles.urgency} aria-label="Fully booked">Full</span>
                    )}
                </div>
                <h3 className={styles.title}>{title}</h3>
            </div>
            <div className={styles.cardBody}>
                <dl className={styles.metaData}>
                    <div className={styles.metaRow}>
                        <dt className={styles.srOnly}>Date</dt>
                        <dd className={styles.date}><span aria-hidden="true">📅</span> {formatDate(date)}</dd>
                    </div>
                    <div className={styles.metaRow}>
                        <dt className={styles.srOnly}>Instructor</dt>
                        <dd className={styles.instructor}><span aria-hidden="true">👨‍🏫</span> {instructor}</dd>
                    </div>
                </dl>
                <p className={styles.excerpt}>{excerpt}</p>
            </div>
            <div className={styles.cardFooter}>
                <Link to={`/workshop/${id}`} className={styles.registerBtn} aria-label={`View details and register for ${title}`}>
                    View &amp; Register
                </Link>
            </div>
        </article>
    );
});

WorkshopCard.displayName = 'WorkshopCard';
export default WorkshopCard;
