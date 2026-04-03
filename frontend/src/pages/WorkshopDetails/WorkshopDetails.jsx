import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import RegistrationForm from '../../components/RegistrationForm/RegistrationForm';
import styles from './WorkshopDetails.module.css';

const WORKSHOPS = [
  {
    id: 1, title: 'Advanced React Patterns', date: '2026-05-15',
    instructor: 'Jane Doe', level: 'Advanced', duration: '4 hours',
    price: '$149', spotsLeft: 3,
    description: 'This intensive workshop dives deep into the advanced patterns used in modern React applications. You will learn how to build scalable and maintainable components using techniques like higher-order components, render props, compound components, and custom hooks. The curriculum includes practical exercises on state management optimizations and performance tuning using React Profiler.',
  },
  {
    id: 2, title: 'Python Django Mastery', date: '2026-05-22',
    instructor: 'John Smith', level: 'Intermediate', duration: '6 hours',
    price: '$199', spotsLeft: 12,
    description: 'Elevate your backend engineering skills with our comprehensive Django Mastery workshop. This session covers ORM performance optimizations, custom middleware development, and class-based views for cleaner code. Designed for developers with basic Django knowledge, this hands-on workshop will prepare you to deploy production-ready API backends.',
  },
  {
    id: 3, title: 'UI/UX Fundamentals for Engineers', date: '2026-06-05',
    instructor: 'Alice Johnson', level: 'Beginner', duration: '3 hours',
    price: '$99', spotsLeft: 20,
    description: 'This workshop bridges the gap between engineering and design. Gain a solid foundation in visual hierarchy, typography, color theory, and responsive layout — all taught from an engineer\'s perspective with practical exercises.',
  },
  {
    id: 4, title: 'Fullstack Next.js Development', date: '2026-06-12',
    instructor: 'Bob Williams', level: 'Intermediate', duration: '5 hours',
    price: '$179', spotsLeft: 8,
    description: 'A hands-on fullstack workshop covering Next.js App Router, React Server Components, server actions, and data fetching strategies. You will build a complete production-ready app from scratch during the session.',
  },
];

const fmtDate = (d) =>
  new Date(d).toLocaleDateString('en-US', { weekday:'long', year:'numeric', month:'long', day:'numeric' });

const META_ITEMS = (w) => [
  { icon: '📅', label: 'Date',       value: fmtDate(w.date) },
  { icon: '👤', label: 'Instructor', value: w.instructor },
  { icon: '⏱️', label: 'Duration',  value: w.duration },
  { icon: '💳', label: 'Price',      value: w.price },
];

const LEVEL_COLORS = {
  Beginner:     'var(--badge-beginner)',
  Intermediate: 'var(--badge-intermediate)',
  Advanced:     'var(--badge-advanced)',
};

const WorkshopDetails = () => {
  const { id } = useParams();
  const [workshop, setWorkshop] = useState(null);
  const [loading,  setLoading]  = useState(true);

  useEffect(() => {
    const t = setTimeout(() => {
      setWorkshop(WORKSHOPS.find(w => w.id === Number(id)) ?? null);
      setLoading(false);
    }, 400);
    return () => clearTimeout(t);
  }, [id]);

  /* ── Loading ── */
  if (loading) return (
    <div className={styles.center} role="status">
      <span className={styles.spinner} aria-hidden="true" />
      <p>Loading workshop…</p>
    </div>
  );

  /* ── Not found ── */
  if (!workshop) return (
    <div className={styles.center}>
      <h2>Workshop not found</h2>
      <p style={{ color:'var(--color-text-muted)', marginTop:'var(--space-2)' }}>
        We couldn't find that workshop.
      </p>
      <Link to="/" className={styles.backLink} style={{ marginTop:'var(--space-4)' }}>
        ← Back to workshops
      </Link>
    </div>
  );

  const spotsLow  = workshop.spotsLeft !== undefined && workshop.spotsLeft > 0 && workshop.spotsLeft <= 5;
  const soldOut   = workshop.spotsLeft === 0;

  return (
    <article>
      <Link to="/" className={styles.backLink}>← Back to all workshops</Link>

      <div className={styles.grid}>

        {/* ── Left: Info ── */}
        <section aria-label="Workshop information">
          {/* Title block */}
          <div className={styles.titleBlock}>
            <span
              className={styles.levelBadge}
              style={{ '--badge-bg': LEVEL_COLORS[workshop.level] ?? 'var(--badge-intermediate)' }}
            >
              {workshop.level}
            </span>
            <h1 className={styles.title}>{workshop.title}</h1>
          </div>

          {/* Spots warning */}
          {spotsLow && (
            <div className={styles.spotsWarning} role="status">
              🔥 Only <strong>{workshop.spotsLeft} spots</strong> remaining — register now!
            </div>
          )}
          {soldOut && (
            <div className={`${styles.spotsWarning} ${styles.soldOutBanner}`} role="status">
              This workshop is fully booked.
            </div>
          )}

          {/* Meta cards */}
          <dl className={styles.metaGrid}>
            {META_ITEMS(workshop).map(({ icon, label, value }) => (
              <div key={label} className={styles.metaCard}>
                <span className={styles.metaIcon} aria-hidden="true">{icon}</span>
                <div>
                  <dt className={styles.metaLabel}>{label}</dt>
                  <dd className={styles.metaValue}>{value}</dd>
                </div>
              </div>
            ))}
          </dl>

          {/* Description */}
          <div className={styles.description}>
            <h2>About this workshop</h2>
            <p>{workshop.description}</p>
          </div>
        </section>

        {/* ── Right: Form ── */}
        <aside className={styles.formCol} aria-label="Registration">
          <RegistrationForm workshopId={workshop.id} disabled={soldOut} />
        </aside>

      </div>
    </article>
  );
};

export default WorkshopDetails;
