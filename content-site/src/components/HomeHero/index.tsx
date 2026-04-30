import React from 'react';
import Link from '@docusaurus/Link';
import styles from './styles.module.css';

export function HomeHero(): React.JSX.Element {
  return (
    <section className={styles.hero}>
      <h1 className={styles.name}>TODO: Your Name</h1>
      <p className={styles.tagline}>TODO: Your tagline here</p>
      <div className={styles.buttons}>
        <Link to="/insights" className={styles.primaryButton}>
          Read Insights
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M5 12h14M12 5l7 7-7 7" />
          </svg>
        </Link>
        <Link to="/about" className={styles.secondaryButton}>
          About Me
        </Link>
      </div>
    </section>
  );
}