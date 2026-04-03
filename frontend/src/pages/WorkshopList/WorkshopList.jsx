import React, { useState, useEffect, useMemo } from 'react';
import WorkshopCard from '../../components/WorkshopCard/WorkshopCard';
import styles from './WorkshopList.module.css';

const WORKSHOPS = [
  {
    id: 1, title: 'Advanced React Patterns', date: '2026-05-15',
    instructor: 'Jane Doe', level: 'Advanced', spotsLeft: 3,
    excerpt: 'Master advanced React concepts including higher-order components, render props, and custom hooks for scalable applications.',
  },
  {
    id: 2, title: 'Python Django Mastery', date: '2026-05-22',
    instructor: 'John Smith', level: 'Intermediate', spotsLeft: 12,
    excerpt: 'Build robust backend architectures with Django. Learn ORM optimizations, middleware, and class-based views.',
  },
  {
    id: 3, title: 'UI/UX Fundamentals for Engineers', date: '2026-06-05',
    instructor: 'Alice Johnson', level: 'Beginner', spotsLeft: 20,
    excerpt: 'Understand basic design principles, typography, and color theory to build better interfaces.',
  },
  {
    id: 4, title: 'Fullstack Next.js Development', date: '2026-06-12',
    instructor: 'Bob Williams', level: 'Intermediate', spotsLeft: 8,
    excerpt: 'Create high-performance server-side rendered applications with Next.js app router and server actions.',
  },
];

const LEVELS = ['All', 'Beginner', 'Intermediate', 'Advanced'];

const WorkshopList = () => {
  const [workshops, setWorkshops] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [activeLevel, setActiveLevel] = useState('All');

  useEffect(() => {
    const t = setTimeout(() => { setWorkshops(WORKSHOPS); setLoading(false); }, 600);
    return () => clearTimeout(t);
  }, []);

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return workshops.filter(w => {
      const matchesLevel = activeLevel === 'All' || w.level === activeLevel;
      const matchesSearch =
        !q ||
        w.title.toLowerCase().includes(q) ||
        w.instructor.toLowerCase().includes(q) ||
        w.excerpt.toLowerCase().includes(q);
      return matchesLevel && matchesSearch;
    });
  }, [workshops, search, activeLevel]);

  return (
    <section className={styles.page}>
      {/* ── Page header ── */}
      <header className={styles.hero}>
        <p className={styles.eyebrow}>Expert-led sessions</p>
        <h1 className={styles.heading}>Upcoming Workshops</h1>
        <p className={styles.subheading}>
          Sharpen your skills with hands-on workshops led by industry practitioners.
          Limited spots — register early.
        </p>
      </header>

      {/* ── Search & Filter toolbar ── */}
      {!loading && (
        <div className={styles.toolbar} role="search">
          <div className={styles.searchWrap}>
            <span className={styles.searchIcon} aria-hidden="true">🔍</span>
            <input
              id="workshop-search"
              type="search"
              className={styles.searchInput}
              placeholder="Search workshops…"
              value={search}
              onChange={e => setSearch(e.target.value)}
              aria-label="Search workshops by title, instructor, or description"
            />
            {search && (
              <button
                className={styles.clearBtn}
                onClick={() => setSearch('')}
                aria-label="Clear search"
              >
                ✕
              </button>
            )}
          </div>

          <div className={styles.filters} role="group" aria-label="Filter by level">
            {LEVELS.map(level => (
              <button
                key={level}
                className={`${styles.filterBtn} ${activeLevel === level ? styles.filterBtnActive : ''}`}
                onClick={() => setActiveLevel(level)}
                aria-pressed={activeLevel === level}
              >
                {level}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* ── Content ── */}
      {loading ? (
        <div className={styles.loaderWrap} role="status" aria-live="polite">
          <span className={styles.spinner} aria-hidden="true" />
          <p>Loading workshops…</p>
        </div>
      ) : filtered.length === 0 ? (
        <div className={styles.empty} role="status" aria-live="polite">
          <p className={styles.emptyIcon}>🔎</p>
          <p className={styles.emptyTitle}>No workshops found</p>
          <p className={styles.emptyHint}>
            Try adjusting your search or filter to find what you're looking for.
          </p>
          <button
            className={styles.resetBtn}
            onClick={() => { setSearch(''); setActiveLevel('All'); }}
          >
            Reset filters
          </button>
        </div>
      ) : (
        <div className={styles.grid}>
          {filtered.map(w => (
            <WorkshopCard key={w.id} {...w} />
          ))}
        </div>
      )}
    </section>
  );
};

export default WorkshopList;
