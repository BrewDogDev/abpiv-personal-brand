import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join, relative, resolve } from 'node:path';

const siteRoot = resolve(import.meta.dirname, '..');
const ignoredDirs = new Set(['.docusaurus', 'build', 'cloudflare-pages', 'node_modules']);
const textFileExtensions = new Set(['.css', '.js', '.json', '.md', '.mdx', '.mjs', '.ts', '.tsx', '.yml']);

function* walk(dir) {
  for (const entry of readdirSync(dir)) {
    if (ignoredDirs.has(entry)) {
      continue;
    }

    const path = join(dir, entry);
    const stat = statSync(path);

    if (stat.isDirectory()) {
      yield* walk(path);
      continue;
    }

    if ([...textFileExtensions].some((extension) => path.endsWith(extension))) {
      yield path;
    }
  }
}

const invalidMatches = [];

for (const path of walk(siteRoot)) {
  const text = readFileSync(path, 'utf8');
  const matches = text.matchAll(/\bRan(?:d)?DAO\b/g);

  for (const match of matches) {
    invalidMatches.push(`${relative(siteRoot, path)}:${match[0]}`);
  }
}

if (invalidMatches.length > 0) {
  throw new Error(`Use RANDAO brand casing instead of mixed-case variants:\n${invalidMatches.join('\n')}`);
}
