import type {ReactNode} from 'react';
import Layout from '@theme/Layout';
import {HomeHero} from '@site/src/components/HomeHero';
import {SectionCards} from '@site/src/components/SectionCards';
import {LatestPosts} from '@site/src/components/LatestPosts';

export default function Home(): ReactNode {
  return (
    <Layout title="Home" description="CEO | Redefining the Internet">
      <main style={{padding: '2rem 0'}}>
        <div className="container">
          <HomeHero />
          <SectionCards />
          <LatestPosts />
        </div>
      </main>
    </Layout>
  );
}