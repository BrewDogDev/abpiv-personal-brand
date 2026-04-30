import React from 'react';
import Link from '@docusaurus/Link';
import styles from './styles.module.css';

const sections = [
  {
    to: '/research',
    title: 'Research',
    description: 'Long-form studies, analyses, and deep dives into topics that matter.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M9 12h6M9 16h6M7 4H4a1 1 0 00-1 1v14a1 1 0 001 1h16a1 1 0 001-1V8" />
        <path d="M12 2v6M16 8l-4-4-4 4" />
      </svg>
    ),
  },
  {
    to: '/featured',
    title: 'Featured',
    description: 'Appearances on podcasts, conferences, interviews, and guest posts.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
      </svg>
    ),
  },
  {
    to: '/insights',
    title: 'Insights',
    description: 'Posts, ideas, and thoughts on technology, design, and building things.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M12 20h9M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4L16.5 3.5z" />
      </svg>
    ),
  },
  {
    to: '/newsroom',
    title: 'Newsroom',
    description: 'Announcements, milestones, and updates on projects and work.',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M4 22h16a2 2 0 002-2V4a2 2 0 00-2-2H8a2 2 0 00-2 2v16a2 2 0 01-2 2zm0 0a2 2 0 01-2-2v-9c0-1.1.9-2 2-2h2" />
        <path d="M18 14h-8M15 18h-5M10 6h8v4h-8V6z" />
      </svg>
    ),
  },
];

export function SectionCards(): React.JSX.Element {
  return (
    <div className={styles.grid}>
      {sections.map((section) => (
        <Link key={section.to} to={section.to} className={styles.card}>
          <div className={styles.icon}>{section.icon}</div>
          <h3 className={styles.title}>{section.title}</h3>
          <p className={styles.description}>{section.description}</p>
          <span className={styles.arrow}>
            Explore
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg>
          </span>
        </Link>
      ))}
    </div>
  );
}