import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import RegistrationForm from '../../components/RegistrationForm/RegistrationForm';
import styles from './WorkshopDetails.module.css';

// Mock data
const mockWorkshops = [
    {
        id: 1,
        title: 'Advanced React Patterns',
        date: '2026-05-15',
        instructor: 'Jane Doe',
        level: 'Advanced',
        description: 'This intensive workshop dives deep into the advanced patterns used in modern React applications. You will learn how to build scalable and maintainable components using techniques like higher-order components, render props, compound components, and custom hooks. The curriculum includes practical exercises on state management optimizations and performance tuning using React Profiler. By the end of this session, you will be equipped to tackle complex application architectures with confidence.',
        duration: '4 hours',
        price: '$149'
    },
    {
        id: 2,
        title: 'Python Django Mastery',
        date: '2026-05-22',
        instructor: 'John Smith',
        level: 'Intermediate',
        description: 'Elevate your backend engineering skills with our comprehensive Django Mastery workshop. This session goes beyond the basics to cover ORM performance optimizations, custom middleware development, and the utilization of class-based views for cleaner code. Designed for developers with basic Django knowledge, this hands-on workshop will prepare you to deploy production-ready API backends effectively.',
        duration: '6 hours',
        price: '$199'
    },
    // Adding default fallback mock data
    {
        id: 'unknown',
        title: 'Workshop Not Found',
        description: 'We could not locate the workshop you are looking for.'
    }
];

const WorkshopDetails = () => {
    const { id } = useParams();
    const [workshop, setWorkshop] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        // Simulate API fetch based on ID
        setTimeout(() => {
            const found = mockWorkshops.find(w => w.id === parseInt(id));
            setWorkshop(found || mockWorkshops[mockWorkshops.length - 1]);
            setIsLoading(false);
        }, 500);
    }, [id]);

    if (isLoading) {
        return (
            <div className={styles.loadingContainer}>
                <div className={styles.loader}></div>
                <p>Loading workshop details...</p>
            </div>
        );
    }

    if (workshop.id === 'unknown') {
        return (
            <div className={styles.notFoundContainer}>
                <h2>{workshop.title}</h2>
                <p>{workshop.description}</p>
                <Link to="/" className={styles.backLink}>&larr; Back to Workshops</Link>
            </div>
        );
    }

    return (
        <article className={styles.detailsContainer}>
            <Link to="/" className={styles.backLink}>&larr; Back to all workshops</Link>

            <div className={styles.contentGrid}>

                {/* Left Column: Details */}
                <section className={styles.infoSection}>
                    <div className={styles.header}>
                        <span className={styles.levelBadge}>{workshop.level}</span>
                        <h1 className={styles.title}>{workshop.title}</h1>
                    </div>

                    <div className={styles.metaDataList}>
                        <div className={styles.metaItem}>
                            <span className={styles.icon} aria-hidden="true">📅</span>
                            <div>
                                <strong>Date</strong>
                                <p>{new Date(workshop.date).toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</p>
                            </div>
                        </div>

                        <div className={styles.metaItem}>
                            <span className={styles.icon} aria-hidden="true">👨‍🏫</span>
                            <div>
                                <strong>Instructor</strong>
                                <p>{workshop.instructor}</p>
                            </div>
                        </div>

                        <div className={styles.metaItem}>
                            <span className={styles.icon} aria-hidden="true">⏱️</span>
                            <div>
                                <strong>Duration</strong>
                                <p>{workshop.duration}</p>
                            </div>
                        </div>

                        <div className={styles.metaItem}>
                            <span className={styles.icon} aria-hidden="true">🏷️</span>
                            <div>
                                <strong>Price</strong>
                                <p>{workshop.price}</p>
                            </div>
                        </div>
                    </div>

                    <div className={styles.description}>
                        <h2>About this workshop</h2>
                        <p>{workshop.description}</p>
                    </div>
                </section>

                {/* Right Column: Registration Form */}
                <aside className={styles.formSection}>
                    <RegistrationForm workshopId={workshop.id} workshopTitle={workshop.title} />
                </aside>

            </div>
        </article>
    );
};

export default WorkshopDetails;
