import React from 'react';
import Link from '@docusaurus/Link';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './styles.module.css';

const credibilityChips = [
  'Published AI & Blockchain Researcher',
  'CipherPlay / RANDAO founder',
  'Web3 Thought Leader',
];

const signalStack = [
  {
    label: 'Insight',
    text: 'AI, blockchain, and spatial computing are changing how we interact with the world around us.',
  },
  {
    label: 'Vision',
    text: 'A new age of technology should expand human capability and make systems easier to navigate.',
  },
  {
    label: 'Execution',
    text: 'Bringing that future closer through systems people can use, trust, and build on.',
  },
];

export function HomeHero(): React.JSX.Element {
  const avatarUrl = useBaseUrl('/img/headshot.png');

  return (
    <section className={styles.hero}>
      <div className={styles.systemMap} aria-hidden="true">
        <span className={styles.routeOne} />
        <span className={styles.routeTwo} />
        <span className={styles.routeThree} />
        <span className={`${styles.node} ${styles.nodeMarket}`} />
        <span className={`${styles.node} ${styles.nodeSystem}`} />
        <span className={`${styles.node} ${styles.nodeInstitution}`} />
        <span className={`${styles.node} ${styles.nodeIndividual}`} />
      </div>

      <div className={styles.heroInner}>
        <div className={styles.copy}>
          <p className={styles.eyebrow}>Visionary Operator CEO</p>
          <h1 className={styles.name}>Allan B. Pedin IV</h1>
          <p className={styles.positioning}>
            Expanding individual agency through emerging technologies that help people and systems coordinate.
          </p>
          <p className={styles.supporting}>
            Allan connects published research, infrastructure work, and founder experience to make complex technology
            easier to use, evaluate, and build on.
          </p>

          <div className={styles.credibilityChips} aria-label="Credibility signals">
            {credibilityChips.map((chip) => (
              <span key={chip} className={styles.credibilityChip}>
                {chip}
              </span>
            ))}
          </div>

          <div className={styles.buttons}>
            <Link to="/insights" className={styles.primaryButton}>
              Read insights
              <span aria-hidden="true">-&gt;</span>
            </Link>
            <Link to="/news-publications" className={styles.secondaryButton}>
              News & Publications
            </Link>
          </div>
        </div>

        <aside className={styles.founderSignal} aria-label="Founder signal">
          <div className={styles.portraitWrap}>
            <img
              src={avatarUrl}
              alt="Allan B. Pedin IV"
              className={styles.avatar}
            />
          </div>
          <div className={styles.signalHeader}>Build, explain, earn trust</div>
          <div className={styles.signalStack}>
            {signalStack.map((signal) => (
              <div key={signal.label} className={styles.signalItem}>
                <span>{signal.label}</span>
                <p>{signal.text}</p>
              </div>
            ))}
          </div>
        </aside>
      </div>
    </section>
  );
}
