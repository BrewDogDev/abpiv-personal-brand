import React, {useMemo} from 'react';
import Link from '@docusaurus/Link';
import Head from '@docusaurus/Head';
import useGlobalData from '@docusaurus/useGlobalData';
import useBaseUrl from '@docusaurus/useBaseUrl';
import Layout from '@theme/Layout';
import {
  type BlogGlobalDataMap,
  formatPostDate,
  getNewsPublications,
} from '@site/src/utils/contentPosts';
import styles from './styles.module.css';

export default function NewsPublicationsPage(): React.JSX.Element {
  const globalData = useGlobalData() as unknown as BlogGlobalDataMap;
  const items = useMemo(() => getNewsPublications(globalData), [globalData]);
  const feedUrl = useBaseUrl('/news-publications/rss.xml');

  return (
    <Layout
      title="News & Publications"
      description="Research papers, launch notes, and public updates from Allan B. Pedin IV.">
      <Head>
        <meta property="og:title" content="News & Publications" />
        <meta
          property="og:description"
          content="Research papers, launch notes, and public updates from Allan B. Pedin IV."
        />
        <link rel="alternate" type="application/rss+xml" title="News & Publications" href={feedUrl} />
      </Head>

      <main className={styles.page}>
        <section className={styles.hero}>
          <div className="container">
            <p className={styles.eyebrow}>News & Publications</p>
            <h1 className={styles.title}>Public updates and published work</h1>
            <p className={styles.subtitle}>
              Research papers, launch notes, and project milestones in one place, with direct links into the source
              material.
            </p>
            <div className={styles.signalRow} aria-label="News and publication types">
              <span>News</span>
              <span>Publications</span>
              <span>Research papers</span>
              <span>Project updates</span>
            </div>
          </div>
        </section>

        <div className="container">
          {items.length ? (
            <div className={styles.grid}>
              {items.map(({post, sourceLabel}) => (
                <Link
                  key={post.metadata.permalink}
                  to={post.metadata.permalink}
                  className={styles.card}>
                  <div className={styles.cardMeta}>
                    <span>{sourceLabel}</span>
                    <span>{formatPostDate(post.metadata.date)}</span>
                  </div>
                  <h2 className={styles.cardTitle}>{post.metadata.title}</h2>
                  {post.metadata.description ? (
                    <p className={styles.cardDescription}>{post.metadata.description}</p>
                  ) : null}
                  <span className={styles.cardAction}>
                    Read
                    <span aria-hidden="true">-&gt;</span>
                  </span>
                </Link>
              ))}
            </div>
          ) : (
            <p className={styles.empty}>No news or publications have been posted yet.</p>
          )}
        </div>
      </main>
    </Layout>
  );
}
