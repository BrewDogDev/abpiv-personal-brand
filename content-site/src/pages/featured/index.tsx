import React, {useMemo} from 'react';
import {FeaturedCard} from '@site/src/components/FeaturedCard';
import {FeaturedItems} from '@site/src/data/featured';
import type {FeaturedItem} from '@site/src/data/featured';
import Layout from '@theme/Layout';
import Head from '@docusaurus/Head';
import styles from './styles.module.css';

function sortItems(items: FeaturedItem[]): FeaturedItem[] {
  return [...items].sort((a, b) => {
    const aFav = a.tags.includes('favorite');
    const bFav = b.tags.includes('favorite');
    if (aFav && !bFav) return -1;
    if (!aFav && bFav) return 1;
    return new Date(b.date).getTime() - new Date(a.date).getTime();
  });
}

export default function FeaturedPage(): React.JSX.Element {
  const sorted = useMemo(() => sortItems(FeaturedItems), []);

  return (
    <Layout title="Featured" description="Appearances on other people's platforms.">
      <Head>
        <meta property="og:title" content="Featured" />
        <meta property="og:description" content="Appearances on other people's platforms." />
      </Head>

      <div className="container padding--lg">
        <div className={styles.page}>
          <header className={styles.header}>
            <h1 className={styles.title}>Featured On</h1>
            <p className={styles.subtitle}>
              Appearances on podcasts, conferences, interviews, guest posts, and other people's platforms.
            </p>
            <a href="mailto:todo@example.com" className={styles.cta}>
              Suggest an appearance
              <svg
                width="16"
                height="16"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2">
                <path d="M5 12h14M12 5l7 7-7 7" />
              </svg>
            </a>
          </header>

          <div className={styles.grid}>
            {sorted.map((item) => (
              <FeaturedCard key={`${item.title}-${item.date}`} item={item} />
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
}