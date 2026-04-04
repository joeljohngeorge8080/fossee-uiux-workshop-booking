import React, { useState, useEffect } from 'react';
import WorkshopCard from '../../components/WorkshopCard/WorkshopCard';
import styles from './WorkshopList.module.css';

const WORKSHOPS = [
  { id: 1, title: 'Advanced React Patterns',        date: '2026-05-15', instructor: 'Jane Doe',      level: 'Advanced',     spotsLeft: 3,  excerpt: 'Master advanced React concepts including higher-order components, render props, and custom hooks for scalable applications.' },
  { id: 2, title: 'Python Django Mastery',          date: '2026-05-22', instructor: 'John Smith',    level: 'Intermediate', spotsLeft: 12, excerpt: 'Build robust backend architectures with Django. Learn ORM optimizations, middleware, and class-based views.' },
  { id: 3, title: 'UI/UX Fundamentals for Engineers', date: '2026-06-05', instructor: 'Alice Johnson', level: 'Beginner',     spotsLeft: 20, excerpt: 'Understand basic design principles, typography, and color theory to build better interfaces.' },
  { id: 4, title: 'Fullstack Next.js Development',  date: '2026-06-12', instructor: 'Bob Williams',  level: 'Intermediate', spotsLeft: 8,  excerpt: 'Create high-performance server-side rendered applications with Next.js app router and server actions.' },
];

const WorkshopList = () => {
  const [workshops, setWorkshops] = useState([]);
  const [loading,   setLoading]   = useState(true);

  useEffect(() => {
    const t = setTimeout(() => { setWorkshops(WORKSHOPS); setLoading(false); }, 600);
    return () => clearTimeout(t);
  }, []);

  return (
    <section className={styles.page}>
      <header className={styles.hero}>
        <p className={styles.eyebrow}>Expert-led sessions</p>
        <h1 className={styles.heading}>Upcoming Workshops</h1>
        <p className={styles.subheading}>
          Sharpen your skills with hands-on workshops led by industry practitioners.
          Limited spots — register early.
        </p>
      </header>

      {loading ? (
        <div className={styles.center} role="status" aria-live="polite">
          <span className="spinner" aria-hidden="true" />
          <p>Loading workshops…</p>
        </div>
      ) : workshops.length === 0 ? (
        <div className={styles.center}><p>No workshops scheduled yet — check back soon.</p></div>
      ) : (
        <div className={styles.grid}>
          {workshops.map(w => <WorkshopCard key={w.id} {...w} />)}
        </div>
      )}
    </section>
  );
};

export default WorkshopList;
