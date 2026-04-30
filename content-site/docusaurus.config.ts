import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'BrewDogDev',

  url: 'https://BrewDogDev.github.io',
  baseUrl: '/abpiv-personal-brand/',

  projectName: 'abpiv-personal-brand',
  organizationName: 'BrewDogDev',

  trailingSlash: false,

  onBrokenLinks: 'warn',

  future: {
    v4: true,
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

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
          feedOptions: {
            type: ['rss', 'atom'],
            title: 'Insights',
          },
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
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
        feedOptions: {
          type: ['rss', 'atom'],
          title: 'Research',
        },
        onInlineTags: 'warn',
        onInlineAuthors: 'warn',
        onUntruncatedBlogPosts: 'warn',
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
        feedOptions: {
          type: ['rss', 'atom'],
          title: 'Newsroom',
        },
        onInlineTags: 'warn',
        onInlineAuthors: 'warn',
        onUntruncatedBlogPosts: 'warn',
      },
    ],
    ['docusaurus-plugin-plausible', {domain: 'your-domain.com'}],
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
      respectPrefersColorScheme: true,
    },
    navbar: {
title: 'BrewDogDev',
      logo: {
        alt: 'Site Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          to: '/research',
          label: 'Research',
          position: 'left',
        },
        {
          to: '/featured',
          label: 'Featured',
          position: 'left',
        },
        {
          to: '/insights',
          label: 'Insights',
          position: 'left',
        },
        {
          to: '/newsroom',
          label: 'Newsroom',
          position: 'left',
        },
        {
          to: '/about',
          label: 'About',
          position: 'left',
        },
        {
          href: 'https://github.com/BrewDogDev',
          position: 'right',
          className: 'header-github-link',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Content',
          items: [
            {
              to: '/research',
              label: 'Research',
            },
            {
              to: '/featured',
              label: 'Featured',
            },
            {
              to: '/insights',
              label: 'Insights',
            },
            {
              to: '/newsroom',
              label: 'Newsroom',
            },
          ],
        },
        {
          title: 'Feeds',
          items: [
            {
              to: '/research/rss.xml',
              label: 'Research RSS',
            },
            {
              to: '/insights/rss.xml',
              label: 'Insights RSS',
            },
            {
              to: '/newsroom/rss.xml',
              label: 'Newsroom RSS',
            },
          ],
        },
        {
          title: 'Social',
          items: [
            {
              href: 'https://github.com/BrewDogDev',
              label: 'GitHub',
            },
            {
              href: 'https://x.com/TODO: your-x-handle',
              label: 'X (Twitter)',
            },
            {
              href: 'https://linkedin.com/in/TODO: your-linkedin',
              label: 'LinkedIn',
            },
          ],
        },
      ],
      copyright: 'Copyright (c) ' + new Date().getFullYear() + ' BrewDogDev. Built with Docusaurus.',
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;