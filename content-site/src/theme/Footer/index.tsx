import React, {type ReactNode} from 'react';
import {useThemeConfig} from '@docusaurus/theme-common';
import FooterLayout from '@theme/Footer/Layout';
import FooterCopyright from '@theme/Footer/Copyright';
import {FontAwesomeIcon} from '@fortawesome/react-fontawesome';
import {
  faGithub,
  faLinkedin,
  faXTwitter,
  faFacebook,
  faInstagram,
  faYoutube,
  faHackerNews,
  faTiktok,
  faStrava,
} from '@fortawesome/free-brands-svg-icons';
import {links} from '../../../links';

const CrunchbaseIcon = () => (
  <svg role="img" viewBox="0 0 32 32" width="1.5rem" height="1.5rem" xmlns="http://www.w3.org/2000/svg" style={{color: 'var(--ifm-color-primary)'}}>
    <title>Crunchbase</title>
    <path fill="currentColor" d="M23.707 16.68c0 0.017 0.001 0.037 0.001 0.057 0 1.452-1.177 2.629-2.629 2.629s-2.629-1.177-2.629-2.629c0-1.452 1.177-2.629 2.629-2.629 0.477 0 0.925 0.127 1.311 0.35l-0.013-0.007c0.784 0.451 1.309 1.277 1.331 2.226l0 0.003zM23.985 20.136c-0.376 0.325-0.815 0.592-1.294 0.777l-0.030 0.010c-0.494 0.197-1.066 0.312-1.664 0.312-0.96 0-1.851-0.294-2.588-0.797l0.016 0.010v0.475h-1.887v-13.209h1.874v5.136c0.634-0.434 1.403-0.719 2.233-0.786l0.017-0.001h0.337c0.002 0 0.005 0 0.007 0 2.533 0 4.586 2.053 4.586 4.586 0 1.393-0.621 2.64-1.601 3.481l-0.006 0.005zM9.808 19.080c0.321 0.15 0.697 0.237 1.093 0.237 1.060 0 1.974-0.625 2.393-1.527l0.007-0.016h2.074c-0.509 2.035-2.321 3.518-4.48 3.518-2.547 0-4.611-2.064-4.611-4.611s2.065-4.611 4.611-4.611c2.159 0 3.971 1.483 4.473 3.486l0.007 0.032h-2.074c-0.426-0.918-1.34-1.543-2.399-1.543-1.456 0-2.637 1.181-2.637 2.637 0 1.060 0.625 1.974 1.527 2.393l0.016 0.007zM27.997 1.004h-23.993c-1.654 0.007-2.992 1.346-2.999 2.998v23.994c0.007 1.654 1.346 2.992 2.998 2.999h23.994c1.654-0.007 2.992-1.346 2.999-2.998v-23.994c-0.007-1.654-1.346-2.992-2.998-2.999h-0.001z"/>
  </svg>
);

const F6SIcon = () => (
  <svg role="img" viewBox="0 0 800 800" width="1.5rem" height="1.5rem" xmlns="http://www.w3.org/2000/svg" style={{color: 'var(--ifm-color-primary)'}}>
    <title>F6S</title>
    <circle cx="400" cy="400" r="400" fill="currentColor"/>
    <path fill="currentColor" d="M210.697,619.879 206.723,619.879 156.901,619.879 152.927,619.879 152.927,615.905 152.927,184.113 152.927,180.139 156.901,180.139 289.76,180.139 293.734,180.139 293.734,184.113 293.734,233.935 293.734,237.909 289.76,237.909 210.697,237.909 210.697,362.821 256.545,362.821 260.519,362.821 260.519,366.795 260.519,416.617 260.519,420.591 256.545,420.591 210.697,420.591 210.697,615.905"/>
    <path fill="currentColor" d="M372.428,237.909 v 124.912 h 68.517 c 16.582,0 31.127,14.476 31.127,30.977 v 194.721 c 0,16.705 -14.545,31.359 -31.127,31.359 h -95.027 c -16.59,0 -31.143,-14.289 -31.143,-30.578 V 212.296 c 0,-16.829 14.448,-32.156 30.313,-32.156 h 95.858 c 16.582,0 31.127,14.468 31.127,30.961 v 72.657 3.974 h -3.974 -49.822 -3.974 v -3.974 -45.849 z m 0.016,182.68 v 141.519 h 41.875 V 420.589 Z"/>
    <path fill="currentColor" d="M647.073,283.74 v 3.974 h -3.974 -49.822 -3.974 v -3.974 -45.849 h -41.875 v 124.913 l 69.116,0.016 c 16.441,0 30.529,19.672 30.529,35.777 v 189.705 c 0,16.812 -14.266,31.558 -30.529,31.558 h -92.918 c -16.254,0 -30.512,-14.367 -30.512,-30.744 v -106.004 -3.966 l 3.966,-0.007 46.368,-0.083 3.981,-0.007 v 3.981 79.063 h 41.875 V 420.574 l -65.706,0.016 c -16.239,0 -30.484,-14.553 -30.484,-31.143 V 211.282 c 0,-16.599 14.258,-31.16 30.512,-31.16 h 92.918 c 16.263,0 30.529,14.561 30.529,31.16 z"/>
  </svg>
);

const HackerNoonIcon = () => (
  <svg role="img" viewBox="0 0 24 24" width="1.5rem" height="1.5rem" xmlns="http://www.w3.org/2000/svg" style={{color: 'var(--ifm-color-primary)'}}>
    <title>HackerNoon</title>
    <path fill="currentColor" d="M5.701 0v6.223H8.85V4.654h1.576v7.842H12V4.654h1.574v1.569h3.15V0zm11.024 6.223v3.136h1.574V6.223zm1.574 3.136v4.705h1.576v-1.568h1.574v-1.568h-1.574V9.359zm0 4.705h-1.574v3.137h1.574zm-1.574 3.137h-3.15v1.569H8.85V17.2H5.7V24h11.024zm-11.024 0v-3.137H4.125v3.137zm-1.576-3.137V9.36H2.551v4.705zm0-4.705h1.576V6.223H4.125z"/>
  </svg>
);

const socialIcons = [
  { href: links.github, icon: faGithub, label: 'GitHub' },
  { href: links.linkedin, icon: faLinkedin, label: 'LinkedIn' },
  { href: links.x, icon: faXTwitter, label: 'X' },
  { href: links.facebook, icon: faFacebook, label: 'Facebook' },
  { href: links.instagram, icon: faInstagram, label: 'Instagram' },
  { href: links.youtube, icon: faYoutube, label: 'YouTube' },
  { href: links.hackernoon, label: 'HackerNoon', customIcon: <HackerNoonIcon /> },
  { href: links.hackernews, icon: faHackerNews, label: 'Hacker News' },
  { href: links.crunchbase, label: 'Crunchbase', customIcon: <CrunchbaseIcon /> },
  { href: links.f6s, label: 'F6S', customIcon: <F6SIcon /> },
  { href: links.strava, icon: faStrava, label: 'Strava' },
  { href: links.tiktok, icon: faTiktok, label: 'TikTok' },
];

function Footer(): ReactNode {
  const {footer} = useThemeConfig();
  if (!footer) {
    return null;
  }
  const {copyright, style} = footer;

  return (
    <FooterLayout
      style={style}
      links={
        <div
          style={{
            display: 'flex',
            justifyContent: 'center',
            flexWrap: 'wrap',
            gap: '1.5rem',
            padding: '1rem 0',
          }}>
          {socialIcons.map((social) => (
            <a
              key={social.href}
              href={social.href}
              target="_blank"
              rel="noopener noreferrer"
              aria-label={social.label}
              style={{
                color: 'var(--ifm-color-primary)',
                fontSize: '1.5rem',
                display: 'flex',
                alignItems: 'center',
              }}>
              {social.customIcon ??
                <FontAwesomeIcon icon={social.icon} />}
            </a>
          ))}
        </div>
      }
      logo={undefined}
      copyright={copyright && <FooterCopyright copyright={copyright} />}
    />
  );
}

export default React.memo(Footer);