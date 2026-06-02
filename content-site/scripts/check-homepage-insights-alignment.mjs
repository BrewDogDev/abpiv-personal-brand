import {readFileSync} from 'node:fs';
import {join} from 'node:path';
import {parse} from 'parse5';

const buildDir = join(process.cwd(), 'build');
const homepage = parse(readFileSync(join(buildDir, 'index.html'), 'utf8'));
const insights = parse(readFileSync(join(buildDir, 'insights.html'), 'utf8'));

function getAttr(node, name) {
  return node.attrs?.find((attr) => attr.name === name)?.value;
}

function textContent(node) {
  if (node.nodeName === '#text') {
    return node.value;
  }

  return (node.childNodes ?? []).map(textContent).join('');
}

function findNode(node, predicate) {
  if (predicate(node)) {
    return node;
  }

  for (const child of node.childNodes ?? []) {
    const match = findNode(child, predicate);
    if (match) {
      return match;
    }
  }

  return null;
}

function findNodes(node, predicate, matches = []) {
  if (predicate(node)) {
    matches.push(node);
  }

  for (const child of node.childNodes ?? []) {
    findNodes(child, predicate, matches);
  }

  return matches;
}

function findFirstChild(node, tagName) {
  return findNode(node, (child) => child.tagName === tagName);
}

function isInsightPostLink(node) {
  const href = getAttr(node, 'href') ?? '';

  return (
    node.tagName === 'a' &&
    href.startsWith('/info/insights/') &&
    !href.includes('/tags') &&
    !href.includes('/authors') &&
    !href.includes('/archive')
  );
}

function getLinkedTitles(root, headingTag) {
  return findNodes(root, isInsightPostLink)
    .map((link) => findFirstChild(link, headingTag))
    .filter(Boolean)
    .map((heading) => textContent(heading).replace(/\s+/g, ' ').trim());
}

const homepageInsightsSection = findNode(
  homepage,
  (node) => getAttr(node, 'aria-labelledby') === 'default-latest-heading',
);
const insightsList = findNode(
  insights,
  (node) => node.tagName === 'main' && getAttr(node, 'data-insights-list') === 'custom',
);

if (!homepageInsightsSection) {
  throw new Error('Homepage latest-work Insights section was not found in build/index.html.');
}

if (!insightsList) {
  throw new Error('Custom Insights list was not found in build/insights.html.');
}

const homepageTitles = getLinkedTitles(homepageInsightsSection, 'h4');
const insightsTitles = getLinkedTitles(insightsList, 'h2');
const expectedHomepageTitles = insightsTitles.slice(0, homepageTitles.length);

if (!homepageTitles.length) {
  throw new Error('Homepage latest-work Insights section did not render any insight cards.');
}

if (homepageTitles.length > insightsTitles.length) {
  throw new Error(
    `Homepage rendered ${homepageTitles.length} insight cards, but /insights only rendered ${insightsTitles.length}.`,
  );
}

if (JSON.stringify(homepageTitles) !== JSON.stringify(expectedHomepageTitles)) {
  throw new Error(
    [
      'Homepage Insights cards do not match the top /insights listing.',
      `Expected homepage cards:\n- ${expectedHomepageTitles.join('\n- ')}`,
      `Actual homepage cards:\n- ${homepageTitles.join('\n- ')}`,
    ].join('\n\n'),
  );
}
