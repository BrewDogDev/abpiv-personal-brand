import React from 'react';
import Link from '@docusaurus/Link';
import styles from './styles.module.css';

const sections = [
  {
    to: '/insights',
    label: 'Insights',
    title: 'Insights',
    description:
      'Short essays on learning from customers, building useful products, and turning technical work into momentum.',
    signal: 'Read the notes',
  },
  {
    to: '/news-publications',
    label: 'News & Publications',
    title: 'News & Publications',
    description:
      'Launch notes, research papers, and public updates from Allan’s work in one place.',
    signal: 'Read news and papers',
  },
  {
    to: '/featured',
    label: 'Featured On',
    title: 'Featured On',
    description:
      'Podcasts, interviews, and conference appearances on RANDAO, randomness, Web3 trust, and founder-led growth.',
    signal: 'Watch the appearances',
  },
];

export function SectionCards(): React.JSX.Element {
  return (
    <section className={styles.section} aria-labelledby="work-paths-heading">
      <div className={styles.header}>
        <p className={styles.eyebrow}>Start here</p>
        <h2 id="work-paths-heading" className={styles.heading}>
          Explore the work
        </h2>
        <p className={styles.intro}>
          Insights, news and publications, and appearances are separated so visitors can find the level of detail they need.
        </p>
      </div>

      <div className={styles.grid}>
        {sections.map((section, index) => (
          <Link key={section.to} to={section.to} className={styles.card}>
            <div className={styles.cardTopline}>
              <span className={styles.cardLabel}>{section.label}</span>
              <span className={styles.index} aria-hidden="true">
                {String(index + 1).padStart(2, '0')}
              </span>
            </div>
            <h3 className={styles.title}>{section.title}</h3>
            <p className={styles.description}>{section.description}</p>
            <span className={styles.signal}>{section.signal}</span>
            <span className={styles.arrow}>
              Explore
              <span aria-hidden="true">-&gt;</span>
            </span>
          </Link>
        ))}
      </div>
    </section>
  );
}
