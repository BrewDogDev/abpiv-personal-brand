import React from 'react';
import Link from '@docusaurus/Link';
import useGlobalData from '@docusaurus/useGlobalData';
import {FeaturedItems} from '@site/src/data/featured';
import {
  type BlogGlobalDataMap,
  formatPostDate,
  getBlogPosts,
  getNewsPublications,
} from '@site/src/utils/contentPosts';
import styles from './styles.module.css';

interface LatestPostsProps {
  instanceId: string;
  sectionTitle: string;
  basePath: string;
  kicker: string;
}

function LatestPostsSection({instanceId, sectionTitle, basePath, kicker}: LatestPostsProps): React.JSX.Element | null {
  const globalData = useGlobalData() as unknown as BlogGlobalDataMap;
  const posts = getBlogPosts(globalData, instanceId).slice(0, 3);

  if (!posts.length) {
    return null;
  }

  return (
    <section className={styles.section} aria-labelledby={`${instanceId}-latest-heading`}>
      <div className={styles.sectionHeader}>
        <p className={styles.kicker}>{kicker}</p>
        <h3 id={`${instanceId}-latest-heading`} className={styles.sectionTitle}>
          {sectionTitle}
        </h3>
      </div>
      <div className={styles.postsGrid}>
        {posts.map((post) => (
          <Link
            key={post.metadata.permalink}
            to={post.metadata.permalink}
            className={styles.postCard}>
            <p className={styles.postMeta}>{formatPostDate(post.metadata.date)}</p>
            <h4 className={styles.postTitle}>{post.metadata.title}</h4>
            {post.metadata.description ? (
              <p className={styles.postDescription}>{post.metadata.description}</p>
            ) : null}
          </Link>
        ))}
      </div>
      <Link to={basePath} className={styles.viewAll}>
        View all
        <span aria-hidden="true">-&gt;</span>
      </Link>
    </section>
  );
}

function LatestNewsPublicationsSection(): React.JSX.Element | null {
  const globalData = useGlobalData() as unknown as BlogGlobalDataMap;
  const items = getNewsPublications(globalData).slice(0, 3);

  if (!items.length) {
    return null;
  }

  return (
    <section className={styles.section} aria-labelledby="news-publications-latest-heading">
      <div className={styles.sectionHeader}>
        <p className={styles.kicker}>News & Publications</p>
        <h3 id="news-publications-latest-heading" className={styles.sectionTitle}>
          News & Publications
        </h3>
      </div>
      <div className={styles.postsGrid}>
        {items.map(({post, sourceLabel}) => (
          <Link
            key={post.metadata.permalink}
            to={post.metadata.permalink}
            className={styles.postCard}>
            <p className={styles.postMeta}>
              {sourceLabel} - {formatPostDate(post.metadata.date)}
            </p>
            <h4 className={styles.postTitle}>{post.metadata.title}</h4>
            {post.metadata.description ? (
              <p className={styles.postDescription}>{post.metadata.description}</p>
            ) : null}
          </Link>
        ))}
      </div>
      <Link to="/news-publications" className={styles.viewAll}>
        View all
        <span aria-hidden="true">-&gt;</span>
      </Link>
    </section>
  );
}

function LatestFeaturedSection(): React.JSX.Element | null {
  const featuredItems = [...FeaturedItems]
    .sort((a, b) => Number(new Date(b.date)) - Number(new Date(a.date)))
    .slice(0, 3);

  if (!featuredItems.length) {
    return null;
  }

  return (
    <section className={styles.section} aria-labelledby="featured-latest-heading">
      <div className={styles.sectionHeader}>
        <p className={styles.kicker}>Featured On</p>
        <h3 id="featured-latest-heading" className={styles.sectionTitle}>
          Featured On
        </h3>
      </div>
      <div className={styles.postsGrid}>
        {featuredItems.map((item) => (
          <a
            key={`${item.website}-${item.date}`}
            href={item.website}
            target="_blank"
            rel="noreferrer noopener"
            className={styles.postCard}>
            <p className={styles.postMeta}>{formatPostDate(item.date)}</p>
            <h4 className={styles.postTitle}>{item.title}</h4>
            <p className={styles.postDescription}>{item.description}</p>
          </a>
        ))}
      </div>
      <Link to="/featured" className={styles.viewAll}>
        View all
        <span aria-hidden="true">-&gt;</span>
      </Link>
    </section>
  );
}

export function LatestPosts(): React.JSX.Element {
  return (
    <section className={styles.latest} aria-labelledby="latest-work-heading">
      <div className={styles.header}>
        <p className={styles.eyebrow}>Latest work</p>
        <h2 id="latest-work-heading" className={styles.heading}>
          Recent work by section
        </h2>
        <p className={styles.intro}>
          A few current pieces from insights, news and publications, and appearances.
        </p>
      </div>

      <LatestPostsSection
        instanceId="default"
        sectionTitle="Insights"
        basePath="/insights"
        kicker="Insights"
      />
      <LatestNewsPublicationsSection />
      <LatestFeaturedSection />
    </section>
  );
}
