const {mkdirSync, readdirSync, readFileSync, writeFileSync} = require('node:fs');
const path = require('node:path');

const sources = [
  {
    contentDir: 'newsroom',
    routeBasePath: '/newsroom',
    sourceLabel: 'News',
  },
  {
    contentDir: 'research',
    routeBasePath: '/research',
    sourceLabel: 'Publication',
  },
];

function cleanFrontMatterValue(value) {
  const trimmed = value.trim();

  if (
    (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed.slice(1, -1);
  }

  return trimmed;
}

function parseFrontMatter(raw) {
  const match = raw.match(/^---\r?\n([\s\S]*?)\r?\n---/);

  if (!match) {
    return {};
  }

  return match[1].split(/\r?\n/).reduce((metadata, line) => {
    const lineMatch = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);

    if (lineMatch) {
      metadata[lineMatch[1]] = cleanFrontMatterValue(lineMatch[2]);
    }

    return metadata;
  }, {});
}

function slugFromFile(fileName) {
  return fileName
    .replace(/\.mdx?$/, '')
    .replace(/^\d{4}-\d{2}-\d{2}-/, '');
}

function normalizePermalink(routeBasePath, slug) {
  const normalizedSlug = slug.replace(/^\/+/, '');
  return `${routeBasePath}/${normalizedSlug}`;
}

function parsePostDate(date) {
  if (/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    return new Date(`${date}T00:00:00.000Z`);
  }

  return new Date(date);
}

function readFeedItems(siteDir) {
  return sources.flatMap((source) => {
    const sourceDir = path.join(siteDir, source.contentDir);

    return readdirSync(sourceDir)
      .filter((fileName) => fileName.endsWith('.md') || fileName.endsWith('.mdx'))
      .map((fileName) => {
        const raw = readFileSync(path.join(sourceDir, fileName), 'utf8');
        const metadata = parseFrontMatter(raw);
        const slug = metadata.slug || slugFromFile(fileName);
        const date = metadata.date || '1970-01-01';

        return {
          title: metadata.title || slug,
          description: metadata.description || '',
          date,
          parsedDate: parsePostDate(date),
          permalink: normalizePermalink(source.routeBasePath, slug),
          sourceLabel: source.sourceLabel,
        };
      });
  }).sort((a, b) => Number(b.parsedDate) - Number(a.parsedDate));
}

function escapeXml(value) {
  return String(value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

function joinSiteUrl(siteConfig, pathname) {
  const siteUrl = siteConfig.url.replace(/\/$/, '');
  const baseUrl = siteConfig.baseUrl === '/' ? '' : siteConfig.baseUrl.replace(/\/$/, '');
  const normalizedPath = pathname.startsWith('/') ? pathname : `/${pathname}`;

  return `${siteUrl}${baseUrl}${normalizedPath}`;
}

function buildRss({items, siteConfig, title, description, feedPath}) {
  const feedUrl = joinSiteUrl(siteConfig, `/${feedPath}`);
  const pageUrl = joinSiteUrl(siteConfig, '/news-publications');
  const lastBuildDate = items[0]?.parsedDate.toUTCString() || new Date().toUTCString();
  const itemXml = items.map((item) => {
    const itemUrl = joinSiteUrl(siteConfig, item.permalink);

    return [
      '    <item>',
      `      <title>${escapeXml(item.title)}</title>`,
      `      <link>${escapeXml(itemUrl)}</link>`,
      `      <guid isPermaLink="true">${escapeXml(itemUrl)}</guid>`,
      `      <description>${escapeXml(item.description)}</description>`,
      `      <category>${escapeXml(item.sourceLabel)}</category>`,
      `      <pubDate>${item.parsedDate.toUTCString()}</pubDate>`,
      '    </item>',
    ].join('\n');
  }).join('\n');

  return [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">',
    '  <channel>',
    `    <title>${escapeXml(title)}</title>`,
    `    <link>${escapeXml(pageUrl)}</link>`,
    `    <description>${escapeXml(description)}</description>`,
    `    <language>en</language>`,
    `    <lastBuildDate>${lastBuildDate}</lastBuildDate>`,
    `    <atom:link href="${escapeXml(feedUrl)}" rel="self" type="application/rss+xml" />`,
    itemXml,
    '  </channel>',
    '</rss>',
    '',
  ].join('\n');
}

module.exports = function newsPublicationsFeedPlugin(context, pluginOptions) {
  const options = {
    feedPath: 'news-publications/rss.xml',
    title: 'News & Publications',
    description: 'Research papers, launch notes, and project milestones from Allan B. Pedin IV.',
    ...pluginOptions,
  };

  return {
    name: 'news-publications-feed',
    async postBuild({outDir, siteConfig}) {
      const items = readFeedItems(context.siteDir);
      const outputPath = path.join(outDir, options.feedPath);

      mkdirSync(path.dirname(outputPath), {recursive: true});
      writeFileSync(
        outputPath,
        buildRss({
          items,
          siteConfig,
          title: options.title,
          description: options.description,
          feedPath: options.feedPath,
        }),
      );
    },
  };
};
