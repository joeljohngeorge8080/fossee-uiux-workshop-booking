import React from 'react';
import { Link } from 'react-router-dom';
import styles from './About.module.css';

const TEAM = [
  { name: 'Jane Doe',     role: 'React & Frontend',  avatar: '👩‍💻' },
  { name: 'John Smith',   role: 'Python & Django',    avatar: '👨‍💻' },
  { name: 'Alice Johnson',role: 'UI/UX Design',       avatar: '🎨' },
  { name: 'Bob Williams', role: 'Fullstack & DevOps', avatar: '🛠️' },
];

const VALUES = [
  { icon: '🎯', title: 'Practical Learning',   desc: 'Every workshop is hands-on. You build real things, not just watch slides.' },
  { icon: '📱', title: 'Mobile-First',          desc: 'Designed for students on the go. Our platform works beautifully on any device.' },
  { icon: '♿', title: 'Accessible to All',    desc: 'We follow WCAG 2.1 AA standards so every learner can participate fully.' },
  { icon: '🔓', title: 'Open Knowledge',        desc: 'Rooted in the FOSSEE mission — free and open-source software for education.' },
];

const About = () => (
  <div className={styles.page}>

    {/* ── Hero ── */}
    <section className={styles.hero}>
      <p className={styles.eyebrow}>About LearnForge</p>
      <h1 className={styles.heading}>Built for curious minds</h1>
      <p className={styles.sub}>
        LearnForge is a workshop booking platform developed as part of the FOSSEE initiative
        to make expert-led technical education accessible to every student in India.
      </p>
      <Link to="/" className={styles.primaryBtn}>Browse Workshops →</Link>
    </section>

    {/* ── Values ── */}
    <section aria-labelledby="values-heading">
      <h2 id="values-heading" className={styles.sectionHeading}>What we stand for</h2>
      <div className={styles.valuesGrid}>
        {VALUES.map(({ icon, title, desc }) => (
          <div key={title} className={styles.valueCard}>
            <div className={styles.valueIcon} aria-hidden="true">{icon}</div>
            <h3 className={styles.valueTitle}>{title}</h3>
            <p className={styles.valueDesc}>{desc}</p>
          </div>
        ))}
      </div>
    </section>

    {/* ── Instructors ── */}
    <section aria-labelledby="team-heading">
      <h2 id="team-heading" className={styles.sectionHeading}>Meet our instructors</h2>
      <div className={styles.teamGrid}>
        {TEAM.map(({ name, role, avatar }) => (
          <div key={name} className={styles.teamCard}>
            <div className={styles.teamAvatar} aria-hidden="true">{avatar}</div>
            <h3 className={styles.teamName}>{name}</h3>
            <p className={styles.teamRole}>{role}</p>
          </div>
        ))}
      </div>
    </section>

    {/* ── CTA ── */}
    <section className={styles.cta}>
      <h2>Ready to start learning?</h2>
      <p>Browse upcoming workshops and secure your spot today.</p>
      <Link to="/" className={styles.primaryBtn}>View Workshops →</Link>
    </section>

  </div>
);

export default About;
