import React from 'react';
import Link from '@docusaurus/Link';
import useGlobalData from '@docusaurus/useGlobalData';

interface BlogPost {
  metadata: {
    permalink: string;
    title: string;
    description: string;
    date: string;
    tags: Array<{label: string; permalink: string}>;
  };
}

interface BlogGlobalData {
  blogMetadata: {
    feedFiles: string[];
  };
  posts: BlogPost[];
}

interface LatestPostsProps {
  instanceId: string;
  sectionTitle: string;
  basePath: string;
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

function LatestPostsSection({instanceId, sectionTitle, basePath}: LatestPostsProps): React.JSX.Element | null {
  const globalData = useGlobalData() as unknown as {[key: string]: BlogGlobalData | undefined};
  const key = `docusaurus-plugin-content-blog-instance-${instanceId}`;
  const instanceData = globalData[key];

  if (!instanceData?.posts?.length) {
    return null;
  }

  const posts = instanceData.posts.slice(0, 3);

  return (
    <div>
      <h2 className="text--trend" style={{fontSize: '1.5rem', fontWeight: 600, marginBottom: '1rem'}}>
        {sectionTitle}
      </h2>
      <div style={{display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1rem'}}>
        {posts.map((post) => (
          <Link
            key={post.metadata.permalink}
            to={post.metadata.permalink}
            style={{textDecoration: 'none'}}>
            <div
              style={{
                padding: '1rem',
                border: '1px solid var(--ifm-color-emphasis-200)',
                borderRadius: 'var(--ifm-border-radius)',
                transition: 'border-color 0.2s, box-shadow 0.2s',
              }}>
              <h3 style={{fontSize: '0.95rem', fontWeight: 600, margin: '0 0 0.25rem', color: 'var(--ifm-color-primary)'}}>
                {post.metadata.title}
              </h3>
              <p style={{fontSize: '0.8rem', color: 'var(--ifm-color-emphasis-500)', margin: 0}}>
                {formatDate(post.metadata.date)}
              </p>
            </div>
          </Link>
        ))}
      </div>
      <Link to={basePath} style={{display: 'inline-flex', alignItems: 'center', gap: '0.25rem', marginTop: '1rem', fontSize: '0.875rem', color: 'var(--ifm-color-primary)', textDecoration: 'none', fontWeight: 500}}>
        View all
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M5 12h14M12 5l7 7-7 7" />
        </svg>
      </Link>
    </div>
  );
}

export function LatestPosts(): React.JSX.Element {
  return (
    <div style={{marginBottom: '3rem'}}>
      <LatestPostsSection instanceId="research" sectionTitle="Latest from Research" basePath="/research" />
      <div style={{marginTop: '2rem'}}>
        <LatestPostsSection instanceId="default" sectionTitle="Latest from Insights" basePath="/insights" />
      </div>
      <div style={{marginTop: '2rem'}}>
        <LatestPostsSection instanceId="newsroom" sectionTitle="Latest from Newsroom" basePath="/newsroom" />
      </div>
    </div>
  );
}