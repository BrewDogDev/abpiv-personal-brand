import {readFileSync} from 'node:fs';
import {join} from 'node:path';

const buildDir = join(process.cwd(), 'build');
const insights = readFileSync(join(buildDir, 'insights.html'), 'utf8');
const research = readFileSync(join(buildDir, 'research.html'), 'utf8');
const newsroom = readFileSync(join(buildDir, 'newsroom.html'), 'utf8');

const insightsMarkers = [
  'Ideas, strategy, and operating notes',
  'data-insights-list="custom"',
  'TAP Is the Strategy for Winning In the Game of Business',
  'Life and business are non-zero-sum, repeated, incomplete-information, asymmetric, multiplayer games. TAP is the strategy for winning them.',
  'Read',
];

const missingMarkers = insightsMarkers.filter((marker) => !insights.includes(marker));

if (missingMarkers.length > 0) {
  throw new Error(`Insights listing is missing custom-list markers:\n- ${missingMarkers.join('\n- ')}`);
}

for (const [name, html] of [
  ['research', research],
  ['newsroom', newsroom],
]) {
  if (html.includes('data-insights-list="custom"') || html.includes('Ideas, strategy, and operating notes')) {
    throw new Error(`${name} listing unexpectedly uses the custom Insights list style.`);
  }
}
