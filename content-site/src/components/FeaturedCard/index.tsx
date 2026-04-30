import React from 'react';
import type {FeaturedItem} from '@site/src/data/featured';
import styles from './styles.module.css';

interface FeaturedCardProps {
  item: FeaturedItem;
}

export function FeaturedCard({item}: FeaturedCardProps): React.JSX.Element {
  return (
    <a
      href={item.website}
      target="_blank"
      rel="noreferrer noopener"
      className={styles.featuredCard}
      style={{textDecoration: 'none'}}>
      <img
        src={item.preview}
        alt={`${item.title} preview`}
        className={styles.cardImage}
      />
      <div className={styles.cardBody}>
        <h3 className={styles.cardTitle}>{item.title}</h3>
        <p className={styles.cardOutlet}>{item.outlet}</p>
        <p className={styles.cardDescription}>{item.description}</p>
        <div className={styles.cardTags}>
          {item.tags.map((tag) => (
            <span
              key={tag}
              className={styles.tag}
              style={{
                backgroundColor: `color-mix(in srgb, var(--ifm-color-primary) 15%, transparent)`,
                color: 'var(--ifm-color-primary)',
              }}>
              {tag}
            </span>
          ))}
        </div>
        <div className={styles.cardFooter}>
          <span className={styles.cardDate}>{item.date}</span>
          <span className={styles.externalLink}>
            Visit
            <svg
              width="12"
              height="12"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round">
              <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
              <polyline points="15 3 21 3 21 9" />
              <line x1="10" y1="14" x2="21" y2="3" />
            </svg>
          </span>
        </div>
      </div>
    </a>
  );
}