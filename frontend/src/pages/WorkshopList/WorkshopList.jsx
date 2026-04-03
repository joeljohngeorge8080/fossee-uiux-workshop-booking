import React, { useState, useEffect } from 'react';
import WorkshopCard from '../../components/WorkshopCard/WorkshopCard';
import styles from './WorkshopList.module.css';

// Mock data, in real app this would be fetched from Django API
const mockWorkshops = [
    {
        id: 1,
        title: 'Advanced React Patterns',
        date: '2026-05-15',
        instructor: 'Jane Doe',
        level: 'Advanced',
        excerpt: 'Master advanced React concepts including higher-order components, render props, and custom hooks for scalable applications.',
    },
    {
        id: 2,
        title: 'Python Django Mastery',
        date: '2026-05-22',
        instructor: 'John Smith',
        level: 'Intermediate',
        excerpt: 'Build robust backend architectures with Django. Learn ORM optimizations, middleware, and class-based views.',
    },
    {
        id: 3,
        title: 'UI/UX Fundamentals for Engineers',
        date: '2026-06-05',
        instructor: 'Alice Johnson',
        level: 'Beginner',
        excerpt: 'Understand basic design principles, typography, and color theory to build better user interfaces and experiences.',
    },
    {
        id: 4,
        title: 'Fullstack Next.js Development',
        date: '2026-06-12',
        instructor: 'Bob Williams',
        level: 'Intermediate',
        excerpt: 'Create high-performance server-side rendered applications utilizing Next.js app router and server actions.',
    }
];

const WorkshopList = () => {
    const [workshops, setWorkshops] = useState([]);
    const [isLoading, setIsLoading] = useState(true);

    // Simulate API fetch delay
    useEffect(() => {
        const fetchWorkshops = () => {
            setTimeout(() => {
                setWorkshops(mockWorkshops);
                setIsLoading(false);
            }, 600);
        };

        fetchWorkshops();
    }, []);

    return (
        <section className={styles.listContainer}>
            <header className={styles.header}>
                <h1 className={styles.mainTitle}>Upcoming Workshops</h1>
                <p className={styles.subtitle}>Enhance your skills with our expert-led sessions. Register today to secure your spot.</p>
            </header>

            {isLoading ? (
                <div className={styles.loaderContainer}>
                    <div className={styles.loader}></div>
                    <p>Loading workshops...</p>
                </div>
            ) : (
                <div className={styles.grid}>
                    {workshops.map(workshop => (
                        <WorkshopCard
                            key={workshop.id}
                            id={workshop.id}
                            title={workshop.title}
                            date={workshop.date}
                            instructor={workshop.instructor}
                            level={workshop.level}
                            excerpt={workshop.excerpt}
                        />
                    ))}
                </div>
            )}
        </section>
    );
};

export default WorkshopList;
