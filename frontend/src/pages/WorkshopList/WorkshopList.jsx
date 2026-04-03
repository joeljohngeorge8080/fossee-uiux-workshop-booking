import React from 'react';
import WorkshopCard from '../../components/WorkshopCard/WorkshopCard';
import StatusMessage from '../../components/StatusMessage/StatusMessage';
import { useWorkshops } from '../../context/WorkshopContext';
import styles from './WorkshopList.module.css';

const WorkshopList = () => {
    const { workshops, listLoading, listError, retryList } = useWorkshops();

    return (
        <section className={styles.listContainer}>
            <header className={styles.header}>
                <h1 className={styles.mainTitle}>Upcoming Workshops</h1>
                <p className={styles.subtitle}>
                    Enhance your skills with our expert-led sessions. Register today to secure your spot.
                </p>
            </header>

            {listLoading && <StatusMessage type="loading" message="Loading workshops…" />}

            {listError && (
                <StatusMessage
                    type="error"
                    message={`Could not load workshops: ${listError}`}
                    onRetry={retryList}
                />
            )}

            {!listLoading && !listError && workshops?.length === 0 && (
                <StatusMessage type="empty" message="No workshops scheduled yet. Check back soon!" />
            )}

            {!listLoading && !listError && workshops?.length > 0 && (
                <div className={styles.grid}>
                    {workshops.map((workshop) => (
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
