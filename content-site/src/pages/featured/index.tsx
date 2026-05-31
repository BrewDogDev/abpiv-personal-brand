import React, {useMemo} from 'react';
import {FeaturedCard} from '@site/src/components/FeaturedCard';
import {FeaturedItems} from '@site/src/data/featured';
import type {FeaturedItem} from '@site/src/data/featured';
import {links} from '@site/links';
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
    <Layout
      title="Featured On"
      description="Podcasts, interviews, talks, and appearances featuring Allan B. Pedin IV.">
      <Head>
        <meta property="og:title" content="Featured On" />
        <meta
          property="og:description"
          content="Podcasts, interviews, talks, and appearances featuring Allan B. Pedin IV."
        />
      </Head>

      <main className={styles.page}>
        <section className={styles.hero}>
          <div className="container">
            <p className={styles.eyebrow}>Featured on</p>
            <h1 className={styles.title}>Talks, interviews, and appearances</h1>
            <p className={styles.subtitle}>
              Conversations on RANDAO, randomness, Web3 trust, founder-led growth, and turning technical work into
              something people can understand and use.
            </p>
            <div className={styles.signalRow} aria-label="Speaking themes">
              <span>RANDAO</span>
              <span>Web3 trust</span>
              <span>Founder-led growth</span>
              <span>Randomness infrastructure</span>
            </div>
            <a href={links.email} className={styles.cta}>
              Invite Allan
              <span aria-hidden="true">-&gt;</span>
            </a>
          </div>
        </section>

        <div className="container">
          <div className={styles.grid}>
            {sorted.map((item) => (
              <FeaturedCard key={`${item.title}-${item.date}`} item={item} />
            ))}
          </div>
        </div>
      </main>
    </Layout>
  );
}
