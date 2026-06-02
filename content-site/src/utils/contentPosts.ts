export interface BlogPost {
  metadata: {
    permalink: string;
    title: string;
    description: string;
    date: string;
    tags: Array<{label: string; permalink: string}>;
  };
}

export interface BlogGlobalData {
  blogMetadata: {
    feedFiles: string[];
  };
  posts: BlogPost[];
}

export type BlogGlobalDataMap = {[key: string]: BlogGlobalData | undefined};

export interface NewsPublicationItem {
  post: BlogPost;
  sourceLabel: 'News' | 'Publication';
}

export interface ContentPostsCustomFields {
  insightPosts?: BlogPost[];
}

export const fallbackPosts: Record<string, BlogPost[]> = {
  research: [
    {
      metadata: {
        permalink: '/research/randao-white-paper-v1',
        title: 'Truly Random Number Generation',
        description: 'Research on truly random number generation for decentralized applications.',
        date: '2026-04-30',
        tags: [],
      },
    },
    {
      metadata: {
        permalink: '/research/smart-contract-social-recovery-wallet',
        title: 'Digital Asset Ownership',
        description: 'Research on ownership, recovery, and smart-contract security for digital assets.',
        date: '2023-04-01',
        tags: [],
      },
    },
    {
      metadata: {
        permalink: '/research/secure-decentralized-anonymous-e-voting',
        title: 'Secure Digital Voting',
        description: 'Research on privacy, verifiability, and secure digital voting systems.',
        date: '2023-04-01',
        tags: [],
      },
    },
    {
      metadata: {
        permalink: '/research/predicting-road-quality-satellite-imagery',
        title: 'Artificially Intelligent Satellite Imagery Classification',
        description: 'Research on AI-powered satellite imagery classification for road-quality assessment.',
        date: '2021-07-23',
        tags: [],
      },
    },
  ],
  default: [
    {
      metadata: {
        permalink: '/insights/icap-va-entrepreneurial-scientists',
        title: 'ICAP VA: Where Science Meets Business',
        description: 'ICAP VA taught me that tech only matters when it solves real problems for real people.',
        date: '2025-07-01',
        tags: [],
      },
    },
  ],
  newsroom: [
    {
      metadata: {
        permalink: '/newsroom/site-launch',
        title: 'Site Launch',
        description: 'The public home for Allan B. Pedin IV research, writing, appearances, and project updates.',
        date: '2026-04-30',
        tags: [],
      },
    },
  ],
};

export function getBlogPosts(
  contentData: BlogGlobalDataMap | ContentPostsCustomFields,
  instanceId: string,
): BlogPost[] {
  const insightPosts = (contentData as ContentPostsCustomFields).insightPosts;

  if (instanceId === 'default' && Array.isArray(insightPosts) && insightPosts.length) {
    return sortBlogPostsByDate(insightPosts);
  }

  const key = `docusaurus-plugin-content-blog-instance-${instanceId}`;
  const instanceData = (contentData as BlogGlobalDataMap)[key];

  return sortBlogPostsByDate(instanceData?.posts?.length ? instanceData.posts : fallbackPosts[instanceId] ?? []);
}

export function sortBlogPostsByDate(posts: BlogPost[]): BlogPost[] {
  return [...posts].sort(
    (a, b) => Number(new Date(b.metadata.date)) - Number(new Date(a.metadata.date)),
  );
}

export function getNewsPublications(globalData: BlogGlobalDataMap): NewsPublicationItem[] {
  return [
    ...getBlogPosts(globalData, 'newsroom').map((post) => ({post, sourceLabel: 'News' as const})),
    ...getBlogPosts(globalData, 'research').map((post) => ({post, sourceLabel: 'Publication' as const})),
  ].sort(
    (a, b) => Number(new Date(b.post.metadata.date)) - Number(new Date(a.post.metadata.date)),
  );
}

export function formatPostDate(dateStr: string): string {
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
