const UTM = '?utm_source=abpiv&utm_medium=you-are-welcome';

const withUtm = (url: string): string => url.includes('?') ? url.replace('?', '&').replace('&', UTM + '&') : url + UTM;

export const links = {
  github: withUtm('https://github.com/BrewDogDev'),
  linkedin: withUtm('https://www.linkedin.com/in/allan-b-pedin-iv/'),
  x: withUtm('https://x.com/AllanRANDAO'),
  facebook: withUtm('https://www.facebook.com/allan.pedin'),
  instagram: withUtm('https://www.instagram.com/allanpedin/'),
  youtube: withUtm('https://www.youtube.com/@AllanBPedinIV'),
  hackernoon: withUtm('https://hackernoon.com/u/abpiv'),
  hackernews: withUtm('https://news.ycombinator.com/user?id=abpiv'),
  crunchbase: withUtm('https://www.crunchbase.com/person/allan-pedin-09a9'),
  f6s: withUtm('https://www.f6s.com/allan-b.-pedin-iv'),
  strava: withUtm('https://www.strava.com/athletes/194701234'),
  tiktok: withUtm('https://www.tiktok.com/@allanbpediniv'),
  email: 'mailto:allan@abpiv.dev',
  randaoWhitepaper: 'https://randao-whitepaper.ar.io/',
} as const;

export type LinkKey = keyof typeof links;