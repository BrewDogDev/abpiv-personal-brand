import type {ReactNode} from 'react';
import Layout from '@theme/Layout';
import {HomeHero} from '@site/src/components/HomeHero';
import {SectionCards} from '@site/src/components/SectionCards';
import {LatestPosts} from '@site/src/components/LatestPosts';

export default function Home(): ReactNode {
  return (
    <Layout
      title="Home"
      description="Insights, news and publications, appearances, and project updates from Allan B. Pedin IV.">
      <main>
        <HomeHero />
        <div className="container">
          <SectionCards />
          <LatestPosts />
        </div>
      </main>
    </Layout>
  );
}
