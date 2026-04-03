import React, { useState, useEffect, useCallback, useMemo } from 'react';
import WorkshopCard from '../../components/WorkshopCard/WorkshopCard';
import styles from './WorkshopList.module.css';

// In production this would be an API call (e.g. /api/workshops/)
const WORKSHOPS = [
    {
        id: 1,
        title: 'Advanced React Patterns',
        date: '2026-05-15',
        instructor: 'Jane Doe',
        level: 'Advanced',
        spotsLeft: 3,
        excerpt: 'Master advanced React concepts including higher-order components, render props, and custom hooks for scalable applications.',
    },
    {
        id: 2,
        title: 'Python Django Mastery',
        date: '2026-05-22',
        instructor: 'John Smith',
        level: 'Intermediate',
        spotsLeft: 14,
        excerpt: 'Build robust backend architectures with Django. Learn ORM optimizations, middleware, and class-based views.',
    },
    {
        id: 3,
        title: 'UI/UX Fundamentals for Engineers',
        date: '2026-06-05',
        instructor: 'Alice Johnson',
        level: 'Beginner',
        spotsLeft: 20,
        excerpt: 'Understand basic design principles, typography, and color theory to build better user interfaces and experiences.',
    },
    {
        id: 4,
        title: 'Fullstack Next.js Development',
        date: '2026-06-12',
        instructor: 'Bob Williams',
        level: 'Intermediate',
        spotsLeft: 8,
        excerpt: 'Create high-performance server-side rendered applications utilizing Next.js app router and server actions.',
    },
];

// Filter options — defined outside component so they're stable references
const LEVEL_FILTERS = ['All', 'Beginner', 'Intermediate', 'Advanced'];

// Skeleton placeholder count matches expected card count for layout stability
const SKELETON_COUNT = 4;

const WorkshopList = () => {
    const [workshops, setWorkshops] = useState([]);
    const [isLoading, setIsLoading] = useState(true);
    const [activeFilter, setActiveFilter] = useState('All');

    useEffect(() => {
        // A real fetch would be: fetch('/api/workshops/').then(r => r.json()).then(...)
        const timer = setTimeout(() => {
            setWorkshops(WORKSHOPS);
            setIsLoading(false);
        }, 700);
        return () => clearTimeout(timer); // cleanup prevents state update on unmount
    }, []);

    // Only re-compute filtered list when data or filter changes
    const visibleWorkshops = useMemo(() => {
        if (activeFilter === 'All') return workshops;
        return workshops.filter(w => w.level === activeFilter);
    }, [workshops, activeFilter]);

    const handleFilterChange = useCallback((level) => {
        setActiveFilter(level);
    }, []);

    return (
        <section className={styles.listContainer}>
            <header className={styles.header}>
                <h1 className={styles.mainTitle}>Upcoming Workshops</h1>
                <p className={styles.subtitle}>
                    Expert-led sessions to sharpen your skills. Find one that fits your level.
                </p>

                {/* Level filter bar — only shows once data is loaded */}
                {!isLoading && (
                    <nav className={styles.filterBar} aria-label="Filter workshops by level">
                        {LEVEL_FILTERS.map(level => (
                            <button
                                key={level}
                                onClick={() => handleFilterChange(level)}
                                className={`${styles.filterBtn} ${activeFilter === level ? styles.filterBtnActive : ''}`}
                                aria-pressed={activeFilter === level}
                            >
                                {level}
                            </button>
                        ))}
                    </nav>
                )}
            </header>

            {isLoading ? (
                // Skeleton grid — same layout as real grid, prevents layout shift
                <div className={styles.grid} aria-busy="true" aria-label="Loading workshops">
                    {Array.from({ length: SKELETON_COUNT }).map((_, i) => (
                        <div key={i} className={styles.skeleton} aria-hidden="true">
                            <div className={styles.skeletonBadge} />
                            <div className={styles.skeletonTitle} />
                            <div className={styles.skeletonLine} />
                            <div className={styles.skeletonLine} style={{ width: '60%' }} />
                            <div className={styles.skeletonBtn} />
                        </div>
                    ))}
                </div>
            ) : visibleWorkshops.length === 0 ? (
                // Empty state — friendly message instead of blank page
                <div className={styles.emptyState} role="status">
                    <p className={styles.emptyIcon}>🔍</p>
                    <h2>No workshops found</h2>
                    <p>There are no <strong>{activeFilter}</strong> workshops scheduled right now.</p>
                    <button className={styles.resetFilter} onClick={() => setActiveFilter('All')}>
                        View all workshops
                    </button>
                </div>
            ) : (
                <div className={styles.grid}>
                    {visibleWorkshops.map(workshop => (
                        <WorkshopCard
                            key={workshop.id}
                            id={workshop.id}
                            title={workshop.title}
                            date={workshop.date}
                            instructor={workshop.instructor}
                            level={workshop.level}
                            excerpt={workshop.excerpt}
                            spotsLeft={workshop.spotsLeft}
                        />
                    ))}
                </div>
            )}
        </section>
    );
};

export default WorkshopList;
