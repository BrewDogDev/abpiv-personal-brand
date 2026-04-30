export type TagType =
  | 'podcast'
  | 'interview'
  | 'article'
  | 'guest-post'
  | 'talk'
  | 'keynote'
  | 'video'
  | 'panel'
  | 'newsletter'
  | 'book'
  | 'favorite';

export interface Tag {
  label: string;
  description: string;
  color: string;
}

export const Tags: Record<TagType, Tag> = {
  podcast: {
    label: 'Podcast',
    description: 'Appeared as a guest on a podcast episode.',
    color: '#3b82f6',
  },
  interview: {
    label: 'Interview',
    description: 'Interviewed by a publication or platform.',
    color: '#8b5cf6',
  },
  article: {
    label: 'Article',
    description: 'Quoted or referenced in a third-party article.',
    color: '#10b981',
  },
  'guest-post': {
    label: 'Guest Post',
    description: 'Wrote a guest post for another publication.',
    color: '#f59e0b',
  },
  talk: {
    label: 'Talk',
    description: 'Delivered a talk at a conference or event.',
    color: '#ef4444',
  },
  keynote: {
    label: 'Keynote',
    description: 'Gave a keynote speech.',
    color: '#ec4899',
  },
  video: {
    label: 'Video',
    description: 'Appeared in a video (YouTube, course, etc.).',
    color: '#06b6d4',
  },
  panel: {
    label: 'Panel',
    description: 'Participated in a panel discussion.',
    color: '#84cc16',
  },
  newsletter: {
    label: 'Newsletter',
    description: 'Featured in a newsletter or newsletter interview.',
    color: '#f97316',
  },
  book: {
    label: 'Book',
    description: 'Authored or contributed to a book.',
    color: '#a855f7',
  },
  favorite: {
    label: 'Favorite',
    description: 'A personal favorite or highlight.',
    color: '#eab308',
  },
};