import {readFileSync} from 'node:fs';
import {join} from 'node:path';

const files = [
  'src/components/HomeHero/index.tsx',
  'src/components/SectionCards/index.tsx',
  'src/components/LatestPosts/index.tsx',
  'src/pages/featured/index.tsx',
  'src/data/featured.ts',
  'authors.yml',
  'docusaurus.config.ts',
];

const content = files
  .map((file) => readFileSync(join(process.cwd(), file), 'utf8'))
  .join('\n');

const required = [
  'Expanding individual agency',
  'Published AI & Blockchain Researcher',
  'CipherPlay / RANDAO founder',
  'Web3 Thought Leader',
  'News & Publications',
  'Insight',
  'Vision',
  'Execution',
  'CEO & Co-Founder | AI & Blockchain Researcher',
];

const forbidden = [
  'Redefining the Internet to be: Intelligent, Transparent, Inclusive, Decentralized',
  'Tech First Entrepenuer',
  'Web3 trust speaker',
];

const missing = required.filter((phrase) => !content.includes(phrase));
const presentForbidden = forbidden.filter((phrase) => content.includes(phrase));

if (missing.length || presentForbidden.length) {
  if (missing.length) {
    console.error(`Missing public positioning signals:\n- ${missing.join('\n- ')}`);
  }

  if (presentForbidden.length) {
    console.error(`Forbidden legacy phrases still present:\n- ${presentForbidden.join('\n- ')}`);
  }

  process.exit(1);
}
