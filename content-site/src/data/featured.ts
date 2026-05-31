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
    title: 'Why Blockchains Can\'t Be Random (And Why It Matters for Trust)',
    outlet: 'NDK CYBER - Secure Insights',
    description: 'A practical explanation of why randomness matters in decentralized systems and what builders need to know when evaluating it.',
    preview: 'https://i.ytimg.com/vi/3knbD6F4cUo/hqdefault.jpg',
    website: 'https://www.youtube.com/watch?v=3knbD6F4cUo',
    tags: ['podcast', 'video'],
    date: '2026-01-15',
  },
  {
    title: 'RandAO Builder Spotlight with Allan Pedin',
    outlet: 'Community Labs',
    description: 'Builder conversation on RANDAO, decentralized random number generation, and the tradeoffs behind trustless infrastructure.',
    preview: 'https://i.ytimg.com/vi/LOlYGTt1LIc/hqdefault.jpg',
    website: 'https://www.youtube.com/watch?v=LOlYGTt1LIc',
    tags: ['podcast', 'video'],
    date: '2025-05-10',
  },
  {
    title: 'RandAO Keynote — ETH Denver 2025',
    outlet: 'RandAO',
    description: 'Keynote presentation at ETH Denver 2025 on RANDAO and the future of decentralized applications.',
    preview: 'https://i.ytimg.com/vi/z9hJnxGRxj4/hqdefault.jpg',
    website: 'https://www.youtube.com/watch?v=z9hJnxGRxj4',
    tags: ['keynote', 'video', 'favorite'],
    date: '2025-03-03',
  },
  {
    title: 'A Round Solve Session | Problem: Scale Founder Led Growth',
    outlet: 'A-Round | Leaders at software startups',
    description: 'Problem-solving session on customer learning, sales motion, and scaling founder-led growth.',
    preview: 'https://i.ytimg.com/vi/vdnfdG7SfiU/hqdefault.jpg',
    website: 'https://www.youtube.com/watch?v=vdnfdG7SfiU',
    tags: ['podcast', 'video'],
    date: '2025-12-03',
  },
  {
    title: 'SE02E15 How To Sell When You Sell Random Numbers',
    outlet: 'Colin Davis',
    description: 'A commercialization discussion about explaining technical infrastructure in plain language.',
    preview: 'https://i.ytimg.com/vi/P1aC2AMTdgE/hqdefault.jpg',
    website: 'https://www.youtube.com/watch?v=P1aC2AMTdgE',
    tags: ['podcast', 'video'],
    date: '2026-03-05',
  },
];
