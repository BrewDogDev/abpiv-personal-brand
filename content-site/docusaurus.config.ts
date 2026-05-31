import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';
import { links } from './links';

const isProduction = process.env.NODE_ENV === 'production';
const siteUrl = process.env.SITE_URL || 'https://allanbpediniv.com';
const plausibleSiteDomain = process.env.PLAUSIBLE_SITE_DOMAIN || new URL(siteUrl).hostname;

const config: Config = {
  title: 'Allan B. Pedin IV',

  favicon: 'img/headshot.png',

  url: siteUrl,
  baseUrl: '/info/',

  projectName: 'abpiv-personal-brand',
  organizationName: 'abpiv',

  trailingSlash: false,

  onBrokenLinks: 'warn',

  future: {
    v4: true,
    faster: false,
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  customFields: {},

  clientModules: ['./src/clientModules/mobileSidebarFallback.js'],

  headTags: isProduction
    ? [
        {
          tagName: 'script',
          attributes: {},
          innerHTML:
            'window.plausible=window.plausible||function(){(plausible.q=plausible.q||[]).push(arguments)},plausible.init=plausible.init||function(options){plausible.o=options||{}};plausible.init({endpoint:"/_analytics/api/event"});',
        },
      ]
    : [],

  scripts: isProduction
    ? [
        {
          src: '/_analytics/js/script.js',
          defer: true,
          'data-domain': plausibleSiteDomain,
          'data-api': '/_analytics/api/event',
        },
      ]
    : [],

  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: 'none',
          path: 'docs',
          sidebarPath: 'docs/sidebars.js',
        },
        blog: {
          id: 'default',
          routeBasePath: '/insights',
          path: './insights',
          blogTitle: 'Insights',
          blogDescription: 'Posts and ideas -- blog-style.',
          showReadingTime: true,
          authorsMapPath: '../authors.yml',
          feedOptions: {
            type: null,
            title: 'Insights',
          },
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'ignore',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  plugins: [
    [
      '@docusaurus/plugin-content-blog',
      {
        id: 'research',
        routeBasePath: '/research',
        path: './research',
        blogTitle: 'Research',
        blogDescription: 'Long-form studies and analyses.',
        showReadingTime: true,
        blogSidebarTitle: 'All research',
        blogSidebarCount: 'ALL',
        authorsMapPath: '../authors.yml',
        feedOptions: {
          type: null,
          title: 'Research',
        },
        onInlineTags: 'warn',
        onInlineAuthors: 'warn',
        onUntruncatedBlogPosts: 'ignore',
      },
    ],
    [
      '@docusaurus/plugin-content-blog',
      {
        id: 'newsroom',
        routeBasePath: '/newsroom',
        path: './newsroom',
        blogTitle: 'Newsroom',
        blogDescription: 'Announcements and milestones.',
        authorsMapPath: '../authors.yml',
        feedOptions: {
          type: null,
          title: 'Newsroom',
        },
        onInlineTags: 'warn',
        onInlineAuthors: 'warn',
        onUntruncatedBlogPosts: 'ignore',
      },
    ],
    [
      './plugins/news-publications-feed',
      {
        feedPath: 'news-publications/rss.xml',
        title: 'News & Publications',
        description: 'Research papers, launch notes, and project milestones from Allan B. Pedin IV.',
      },
    ],
    [
      '@easyops-cn/docusaurus-search-local',
      {
        hashed: true,
        indexBlog: true,
        indexPages: true,
        blogRouteBasePath: ['/research', '/insights', '/newsroom'],
      },
    ],
  ],

  themeConfig: {
    image: 'img/social-card.png',
    colorMode: {
      defaultMode: 'dark',
      disableSwitch: true,
      respectPrefersColorScheme: false,
    },
    navbar: {
      title: 'ABPIV',
      logo: {
        alt: 'Allan B. Pedin IV',
        src: 'img/headshot.png',
        srcDark: 'img/headshot.png',
      },
      items: [
        {
          to: '/insights',
          label: 'Insights',
          position: 'left',
        },
        {
          to: '/news-publications',
          label: 'News & Publications',
          position: 'left',
        },
        {
          to: '/featured',
          label: 'Featured On',
          position: 'left',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Navigation',
          items: [
            { to: '/insights', label: 'Insights' },
            { to: '/news-publications', label: 'News & Publications' },
            { to: '/featured', label: 'Featured On' },
          ],
        },
        {
          title: 'RSS Feed',
          items: [
            { to: '/news-publications/rss.xml', label: 'News & Publications' },
          ],
        },
      ],
      copyright: 'Copyright (c) ' + new Date().getFullYear() + ' Allan B. Pedin IV.',
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
