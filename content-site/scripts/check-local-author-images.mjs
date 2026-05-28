import { existsSync, readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const siteRoot = resolve(import.meta.dirname, '..');
const authorsFile = resolve(siteRoot, 'authors.yml');
const authorsYaml = readFileSync(authorsFile, 'utf8');
const imageUrlMatches = [...authorsYaml.matchAll(/image_url:\s*["']?([^"'\n]+)["']?/g)];

if (imageUrlMatches.length === 0) {
  throw new Error('No author image_url entries found in authors.yml.');
}

for (const [, imageUrl] of imageUrlMatches) {
  if (!imageUrl.startsWith('/')) {
    throw new Error(`Author image_url must use a self-hosted root-relative path: ${imageUrl}`);
  }

  const staticAsset = resolve(siteRoot, 'static', imageUrl.slice(1));
  if (!existsSync(staticAsset)) {
    throw new Error(`Author image_url points to a missing static asset: ${imageUrl}`);
  }
}
