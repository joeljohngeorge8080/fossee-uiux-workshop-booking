import React, { memo } from 'react';
import { Link } from 'react-router-dom';
import styles from './WorkshopCard.module.css';

// Level badge colors are intentionally slightly different per level
// to give the page a bit of visual variety — avoids the "all cards look identical" trap
const LEVEL_COLORS = {
    Beginner: 'var(--badge-beginner)',
    Intermediate: 'var(--badge-intermediate)',
    Advanced: 'var(--badge-advanced)',
};

const formatDate = (dateStr) =>
    new Date(dateStr).toLocaleDateString('en-US', { day: 'numeric', month: 'short', year: 'numeric' });

/**
 * WorkshopCard - Displays a single workshop summary.
 * Wrapped in React.memo: parent re-renders won't re-paint cards whose props haven't changed.
 */
const WorkshopCard = memo(({ id, title, date, instructor, excerpt, level, spotsLeft }) => {
    const badgeColor = LEVEL_COLORS[level] || 'var(--badge-intermediate)';
    const isAlmostFull = spotsLeft !== undefined && spotsLeft <= 5;

    return (
        <article className={styles.card}>
            <div className={styles.cardHeader}>
                <div className={styles.cardHeaderTop}>
                    <span
                        className={styles.levelBadge}
                        style={{ '--badge-color': badgeColor }}
                    >
                        {level}
                    </span>
                    {/* Urgency nudge — only shown when spots are low */}
                    {isAlmostFull && (
                        <span className={styles.urgency} aria-label={`Only ${spotsLeft} spots remaining`}>
                            {spotsLeft} left
                        </span>
                    )}
                </div>
                <h3 className={styles.title}>{title}</h3>
            </div>

            <div className={styles.cardBody}>
                <dl className={styles.metaData}>
                    <div className={styles.metaRow}>
                        <dt className={styles.srOnly}>Date</dt>
                        <dd className={styles.date}>
                            <span aria-hidden="true">📅</span> {formatDate(date)}
                        </dd>
                    </div>
                    <div className={styles.metaRow}>
                        <dt className={styles.srOnly}>Instructor</dt>
                        <dd className={styles.instructor}>
                            <span aria-hidden="true">👨‍🏫</span> {instructor}
                        </dd>
                    </div>
                </dl>

                <p className={styles.excerpt}>{excerpt}</p>
            </div>

            <div className={styles.cardFooter}>
                <Link
                    to={`/workshop/${id}`}
                    className={styles.registerBtn}
                    aria-label={`View details and register for ${title}`}
                >
                    View & Register
                </Link>
            </div>
        </article>
    );
});

WorkshopCard.displayName = 'WorkshopCard';

export default WorkshopCard;
