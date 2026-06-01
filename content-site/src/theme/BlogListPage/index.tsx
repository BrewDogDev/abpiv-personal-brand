import React, {type ReactNode} from 'react';
import clsx from 'clsx';
import Head from '@docusaurus/Head';
import Link from '@docusaurus/Link';
import {
  HtmlClassNameProvider,
  PageMetadata,
  ThemeClassNames,
} from '@docusaurus/theme-common';
import Layout from '@theme/Layout';
import BlogListPaginator from '@theme/BlogListPaginator';
import BlogListPageStructuredData from '@theme/BlogListPage/StructuredData';
import OriginalBlogListPage from '@theme-original/BlogListPage';
import SearchMetadata from '@theme/SearchMetadata';
import type {Props} from '@theme/BlogListPage';
import {formatPostDate} from '@site/src/utils/contentPosts';
import styles from './styles.module.css';

const signalLabels = ['Strategy', 'Operating principles', 'Technology', 'Founder notes'];

function isInsightsList(props: Props): boolean {
  return props.metadata.blogTitle === 'Insights' && props.metadata.permalink.includes('/insights');
}

function formatReadingTime(readingTime?: number): string | null {
  if (!readingTime) {
    return null;
  }

  return `${Math.max(1, Math.round(readingTime))} min read`;
}

function InsightsBlogListPage(props: Props): ReactNode {
  const {metadata, items} = props;

  return (
    <HtmlClassNameProvider
      className={clsx(
        ThemeClassNames.wrapper.blogPages,
        ThemeClassNames.page.blogListPage,
      )}>
      <PageMetadata title={metadata.blogTitle} description={metadata.blogDescription} />
      <SearchMetadata tag="blog_posts_list" />
      <BlogListPageStructuredData {...props} />
      <Head>
        <meta property="og:title" content="Insights" />
        <meta
          property="og:description"
          content="Thesis-driven writing on strategy, technology, and operating principles from Allan B. Pedin IV."
        />
      </Head>

      <Layout
        title="Insights"
        description="Thesis-driven writing on strategy, technology, and operating principles from Allan B. Pedin IV.">
        <main className={styles.page} data-insights-list="custom">
          <section className={styles.hero}>
            <div className="container">
              <p className={styles.eyebrow}>Insights</p>
              <h1 className={styles.title}>Ideas, strategy, and operating notes</h1>
              <p className={styles.subtitle}>
                Thesis-driven writing on technology, strategy, entrepreneurship, and the operating principles behind
                the work.
              </p>
              <div className={styles.signalRow} aria-label="Insight topics">
                {signalLabels.map((label) => (
                  <span key={label}>{label}</span>
                ))}
              </div>
            </div>
          </section>

          <div className="container">
            {items.length ? (
              <div className={styles.grid}>
                {items.map(({content}) => {
                  const {metadata: postMetadata} = content;
                  const readingTime = formatReadingTime(postMetadata.readingTime);

                  return (
                    <Link
                      key={postMetadata.permalink}
                      to={postMetadata.permalink}
                      className={styles.card}>
                      <div className={styles.cardMeta}>
                        <span>Insight</span>
                        <span>{formatPostDate(postMetadata.date)}</span>
                      </div>
                      <h2 className={styles.cardTitle}>{postMetadata.title}</h2>
                      {postMetadata.description ? (
                        <p className={styles.cardDescription}>{postMetadata.description}</p>
                      ) : null}
                      <div className={styles.cardFooter}>
                        {readingTime ? <span>{readingTime}</span> : <span>Article</span>}
                        <span className={styles.cardAction}>
                          Read
                          <span aria-hidden="true">-&gt;</span>
                        </span>
                      </div>
                    </Link>
                  );
                })}
              </div>
            ) : (
              <p className={styles.empty}>No insights have been posted yet.</p>
            )}

            {metadata.totalPages > 1 ? (
              <div className={styles.pagination}>
                <BlogListPaginator metadata={metadata} />
              </div>
            ) : null}
          </div>
        </main>
      </Layout>
    </HtmlClassNameProvider>
  );
}

export default function BlogListPage(props: Props): ReactNode {
  if (!isInsightsList(props)) {
    return <OriginalBlogListPage {...props} />;
  }

  return <InsightsBlogListPage {...props} />;
}
