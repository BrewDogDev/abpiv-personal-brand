import type {TagType} from './featuredTags';

export interface FeaturedItem {
  title: string;
  outlet: string;
  description: string;
  preview: string;
  website: string;
  tags: TagType[];
  date: string;
}

export const FeaturedItems: FeaturedItem[] = [
  {
    title: 'TODO: Add a featured appearance title',
    outlet: 'TODO: Publication name',
    description: 'TODO: Brief description of the appearance.',
    preview: '/img/featured/placeholder.png',
    website: 'https://example.com',
    tags: ['podcast'],
    date: '2026-01-01',
  },
];