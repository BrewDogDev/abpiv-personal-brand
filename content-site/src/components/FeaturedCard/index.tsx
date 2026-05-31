import React from 'react';
import type {FeaturedItem} from '@site/src/data/featured';
import {Tags} from '@site/src/data/featuredTags';
import styles from './styles.module.css';

interface FeaturedCardProps {
  item: FeaturedItem;
}

function formatDate(dateStr: string): string {
  try {
    return new Date(dateStr).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  } catch {
    return dateStr;
  }
}

export function FeaturedCard({item}: FeaturedCardProps): React.JSX.Element {
  return (
    <a
      href={item.website}
      target="_blank"
      rel="noreferrer noopener"
      className={styles.featuredCard}
      style={{textDecoration: 'none'}}>
      <div className={styles.imageWrap}>
        <img
          src={item.preview}
          alt={`${item.title} appearance preview`}
          className={styles.cardImage}
        />
      </div>
      <div className={styles.cardBody}>
        <div className={styles.cardMeta}>
          <span>{item.outlet}</span>
          <span>{formatDate(item.date)}</span>
        </div>
        <h3 className={styles.cardTitle}>{item.title}</h3>
        <p className={styles.cardDescription}>{item.description}</p>
        <div className={styles.cardTags}>
          {item.tags.map((tag) => (
            <span key={tag} className={styles.tag}>
              {Tags[tag].label}
            </span>
          ))}
        </div>
        <div className={styles.cardFooter}>
          <span className={styles.externalLink}>
            Watch / listen
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
