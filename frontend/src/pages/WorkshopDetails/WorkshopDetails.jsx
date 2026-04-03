import React from 'react';
import { useParams, Link } from 'react-router-dom';
import RegistrationForm from '../../components/RegistrationForm/RegistrationForm';
import StatusMessage from '../../components/StatusMessage/StatusMessage';
import useWorkshopDetail from '../../hooks/useWorkshopDetail';
import styles from './WorkshopDetails.module.css';

const WorkshopDetails = () => {
    const { id } = useParams();
    const { workshop, isLoading, error, retry } = useWorkshopDetail(id);

    if (isLoading) return <StatusMessage type="loading" message="Loading workshop details…" />;
    if (error)     return <StatusMessage type="error"   message={error} onRetry={retry} />;

    if (!workshop) {
        return (
            <div className={styles.notFoundContainer}>
                <h2>Workshop Not Found</h2>
                <p>We could not locate the workshop you are looking for.</p>
                <Link to="/" className={styles.backLink}>&larr; Back to Workshops</Link>
            </div>
        );
    }

    const formattedDate = new Date(workshop.date).toLocaleDateString('en-US', {
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
    });

    return (
        <article className={styles.detailsContainer}>
            <Link to="/" className={styles.backLink}>&larr; Back to all workshops</Link>

            <div className={styles.contentGrid}>
                <section className={styles.infoSection} aria-label="Workshop information">
                    <div className={styles.header}>
                        <span className={styles.levelBadge}>{workshop.level}</span>
                        <h1 className={styles.title}>{workshop.title}</h1>
                    </div>

                    <dl className={styles.metaDataList}>
                        {[
                            { icon: '📅', label: 'Date',       value: formattedDate },
                            { icon: '👨‍🏫', label: 'Instructor', value: workshop.instructor },
                            { icon: '⏱️', label: 'Duration',   value: workshop.duration },
                            { icon: '🏷️', label: 'Price',      value: workshop.price },
                        ].map(({ icon, label, value }) => (
                            <div key={label} className={styles.metaItem}>
                                <span className={styles.icon} aria-hidden="true">{icon}</span>
                                <div><dt><strong>{label}</strong></dt><dd>{value}</dd></div>
                            </div>
                        ))}

                        {workshop.spotsLeft !== undefined && (
                            <div className={styles.metaItem}>
                                <span className={styles.icon} aria-hidden="true">🪑</span>
                                <div>
                                    <dt><strong>Spots Left</strong></dt>
                                    <dd className={workshop.spotsLeft <= 5 ? styles.urgentText : undefined}>
                                        {workshop.spotsLeft === 0 ? 'Fully Booked' : `${workshop.spotsLeft} remaining`}
                                    </dd>
                                </div>
                            </div>
                        )}
                    </dl>

                    <div className={styles.description}>
                        <h2>About this workshop</h2>
                        <p>{workshop.description}</p>
                    </div>
                </section>

                <aside className={styles.formSection} aria-label="Registration">
                    <RegistrationForm workshopId={workshop.id} />
                </aside>
            </div>
        </article>
    );
};

export default WorkshopDetails;
