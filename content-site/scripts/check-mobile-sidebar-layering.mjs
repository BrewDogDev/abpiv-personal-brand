import {readFileSync} from 'node:fs';
import {join} from 'node:path';

const css = readFileSync(join(process.cwd(), 'src/css/custom.css'), 'utf8');

const globalNavbarBlocks = [...css.matchAll(/(^|\n)\.navbar\s*\{(?<body>[^}]*)\}/g)]
  .map((match) => match.groups?.body ?? '');
const globalBackdropFilter = globalNavbarBlocks.some((body) => body.includes('backdrop-filter'));
const desktopOnlyBackdropFilter =
  /@media\s*\(min-width:\s*997px\)\s*\{[\s\S]*?\.navbar\s*\{[\s\S]*?backdrop-filter:\s*blur\(18px\)/.test(css);

if (globalBackdropFilter) {
  throw new Error(
    'Do not apply backdrop-filter directly to .navbar globally. It makes the mobile sidebar fixed-position relative to the navbar instead of the viewport.',
  );
}

if (!desktopOnlyBackdropFilter) {
  throw new Error('Expected the navbar blur to be scoped to desktop viewports with @media (min-width: 997px).');
}
