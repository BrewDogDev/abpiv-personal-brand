/* @ds-bundle: {"format":3,"namespace":"ABPIVDesignSystem_6ac998","components":[],"sourceHashes":{"ui_kits/site/App.jsx":"943e2af99c0e","ui_kits/site/components.jsx":"6c248eb25eca","ui_kits/site/data.js":"6e8daaebc670","ui_kits/social/animations.jsx":"f1df49708690","ui_kits/social/primitives.jsx":"a2e153408fd9","ui_kits/social/scenes.jsx":"7fcc308429c5"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.ABPIVDesignSystem_6ac998 = window.ABPIVDesignSystem_6ac998 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// ui_kits/site/App.jsx
try { (() => {
// ui_kits/site — App
const {
  useState: useStateApp
} = React;
function App() {
  const [active, setActive] = useStateApp("Insights");
  const goWork = tab => {
    setActive(tab);
    const el = document.getElementById("work");
    if (el) window.scrollTo({
      top: el.offsetTop - 64,
      behavior: "smooth"
    });
  };
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement(Nav, {
    active: active,
    onNav: goWork
  }), /*#__PURE__*/React.createElement(Hero, null), /*#__PURE__*/React.createElement(Thesis, null), /*#__PURE__*/React.createElement(Work, {
    active: active,
    onTab: setActive
  }), /*#__PURE__*/React.createElement(SubscribeBand, null), /*#__PURE__*/React.createElement(Footer, {
    onNav: goWork
  }));
}
ReactDOM.createRoot(document.getElementById("root")).render(/*#__PURE__*/React.createElement(App, null));
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/App.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/components.jsx
try { (() => {
// ui_kits/site — components
const {
  useState
} = React;
const D = window.ABPIV_DATA;
function Chip({
  children,
  amber
}) {
  return /*#__PURE__*/React.createElement("span", {
    className: "chip" + (amber ? " amber" : "")
  }, /*#__PURE__*/React.createElement("span", {
    className: "dot"
  }), children);
}
function Nav({
  active,
  onNav
}) {
  return /*#__PURE__*/React.createElement("div", {
    className: "nav"
  }, /*#__PURE__*/React.createElement("div", {
    className: "wrap nav-inner"
  }, /*#__PURE__*/React.createElement("a", {
    className: "brand",
    href: "#top"
  }, D.brand.name), /*#__PURE__*/React.createElement("div", {
    className: "nav-links"
  }, D.nav.map(n => /*#__PURE__*/React.createElement("a", {
    key: n,
    className: "nav-link" + (active === n ? " active" : ""),
    href: "#",
    onClick: e => {
      e.preventDefault();
      onNav(n);
    }
  }, n)), /*#__PURE__*/React.createElement("a", {
    className: "nav-cta",
    href: "#start",
    onClick: e => {
      e.preventDefault();
      onNav("Featured On");
    }
  }, "Start here"))));
}
function HeroRoutes() {
  // thin cyan route lines that draw in, resolving to a single amber node
  return /*#__PURE__*/React.createElement("svg", {
    className: "hero-routes",
    viewBox: "0 0 1080 560",
    preserveAspectRatio: "xMidYMid slice",
    "aria-hidden": "true"
  }, /*#__PURE__*/React.createElement("g", {
    fill: "none",
    stroke: "var(--cyan-line)",
    strokeWidth: "1",
    opacity: "0.45"
  }, /*#__PURE__*/React.createElement("path", {
    className: "rt",
    d: "M-20 120 H320 Q470 120 470 240 H760"
  }), /*#__PURE__*/React.createElement("path", {
    className: "rt rt2",
    d: "M-20 300 H760"
  }), /*#__PURE__*/React.createElement("path", {
    className: "rt rt3",
    d: "M-20 470 H320 Q470 470 470 240 H760"
  })), /*#__PURE__*/React.createElement("circle", {
    cx: "760",
    cy: "240",
    r: "4.5",
    fill: "var(--amber)"
  }, /*#__PURE__*/React.createElement("animate", {
    attributeName: "opacity",
    values: "1;0.45;1",
    dur: "2.6s",
    begin: "1.6s",
    repeatCount: "indefinite"
  })), /*#__PURE__*/React.createElement("circle", {
    cx: "-20",
    cy: "120",
    r: "3",
    fill: "var(--cyan)"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "-20",
    cy: "300",
    r: "3",
    fill: "var(--cyan)"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "-20",
    cy: "470",
    r: "3",
    fill: "var(--cyan)"
  }));
}
function Hero() {
  return /*#__PURE__*/React.createElement("header", {
    className: "hero",
    id: "top"
  }, /*#__PURE__*/React.createElement(HeroRoutes, null), /*#__PURE__*/React.createElement("div", {
    className: "wrap hero-grid"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "eyebrow"
  }, D.hero.eyebrow), /*#__PURE__*/React.createElement("h1", null, D.hero.h1a, /*#__PURE__*/React.createElement("span", {
    className: "accent"
  }, D.hero.h1accent)), /*#__PURE__*/React.createElement("p", {
    className: "lede"
  }, D.hero.lede), /*#__PURE__*/React.createElement("div", {
    className: "hero-cta"
  }, /*#__PURE__*/React.createElement("a", {
    className: "btn btn-primary",
    href: "#work"
  }, "Read insights ", /*#__PURE__*/React.createElement("span", {
    className: "arr"
  }, "\u2192")), /*#__PURE__*/React.createElement("a", {
    className: "btn btn-ghost",
    href: "#work"
  }, "Explore the work")), /*#__PURE__*/React.createElement("div", {
    className: "proof-row"
  }, D.hero.proof.map((p, i) => /*#__PURE__*/React.createElement(Chip, {
    key: p,
    amber: i === 1
  }, p)))), /*#__PURE__*/React.createElement("div", {
    className: "portrait"
  }, /*#__PURE__*/React.createElement("img", {
    src: "../../assets/headshot.png",
    alt: "Allan B. Pedin IV"
  }), /*#__PURE__*/React.createElement("div", {
    className: "portrait-cap"
  }, /*#__PURE__*/React.createElement("div", {
    className: "nm"
  }, "Allan B. Pedin IV"), /*#__PURE__*/React.createElement("div", {
    className: "rl"
  }, "Founder \xB7 Researcher")))));
}
function Thesis() {
  return /*#__PURE__*/React.createElement("section", {
    className: "section",
    id: "thesis"
  }, /*#__PURE__*/React.createElement("div", {
    className: "wrap"
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-head"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "eyebrow"
  }, D.thesis.eyebrow), /*#__PURE__*/React.createElement("h2", null, "A new age of technology", /*#__PURE__*/React.createElement("br", null), "should expand what people can do."))), /*#__PURE__*/React.createElement("div", {
    className: "thesis"
  }, D.thesis.pillars.map(p => /*#__PURE__*/React.createElement("div", {
    className: "pillar",
    key: p.n
  }, /*#__PURE__*/React.createElement("span", {
    className: "n"
  }, p.n), /*#__PURE__*/React.createElement("h3", null, p.t), /*#__PURE__*/React.createElement("p", null, p.p))))));
}
function Work({
  active,
  onTab
}) {
  const items = D.work[active];
  return /*#__PURE__*/React.createElement("section", {
    className: "section",
    id: "work"
  }, /*#__PURE__*/React.createElement("div", {
    className: "wrap"
  }, /*#__PURE__*/React.createElement("div", {
    className: "section-head"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "eyebrow"
  }, "Explore the work"), /*#__PURE__*/React.createElement("h2", null, "Recent work by section"), /*#__PURE__*/React.createElement("p", {
    className: "lede"
  }, D.workIntro[active])), /*#__PURE__*/React.createElement("a", {
    className: "btn btn-ghost",
    href: "#"
  }, "View all ", /*#__PURE__*/React.createElement("span", {
    className: "arr"
  }, "\u2192"))), /*#__PURE__*/React.createElement("div", {
    className: "tabs"
  }, D.nav.map(n => /*#__PURE__*/React.createElement("button", {
    key: n,
    className: "tab" + (active === n ? " active" : ""),
    onClick: () => onTab(n)
  }, n))), /*#__PURE__*/React.createElement("div", {
    className: "cards"
  }, items.map((c, i) => /*#__PURE__*/React.createElement("article", {
    className: "card",
    key: i
  }, /*#__PURE__*/React.createElement("span", {
    className: "meta"
  }, c.meta), /*#__PURE__*/React.createElement("h4", null, c.t), /*#__PURE__*/React.createElement("p", null, c.p), /*#__PURE__*/React.createElement("span", {
    className: "more"
  }, "Explore ", /*#__PURE__*/React.createElement("span", {
    className: "arr"
  }, "\u2192")))))));
}
function SubscribeBand() {
  const [val, setVal] = useState("");
  const [done, setDone] = useState(false);
  return /*#__PURE__*/React.createElement("section", {
    className: "band",
    id: "start"
  }, /*#__PURE__*/React.createElement("div", {
    className: "wrap band-inner"
  }, /*#__PURE__*/React.createElement("h3", null, "Insight, vision, and execution \u2014 delivered as Allan publishes."), /*#__PURE__*/React.createElement("div", null, done ? /*#__PURE__*/React.createElement(Chip, null, "Subscribed \u2014 thank you") : /*#__PURE__*/React.createElement("form", {
    className: "field",
    onSubmit: e => {
      e.preventDefault();
      if (val.includes("@")) setDone(true);
    }
  }, /*#__PURE__*/React.createElement("input", {
    type: "email",
    placeholder: "you@email.com",
    value: val,
    onChange: e => setVal(e.target.value)
  }), /*#__PURE__*/React.createElement("button", {
    className: "btn btn-primary",
    type: "submit"
  }, "Subscribe")))));
}
function Footer({
  onNav
}) {
  return /*#__PURE__*/React.createElement("footer", {
    className: "footer"
  }, /*#__PURE__*/React.createElement("div", {
    className: "wrap"
  }, /*#__PURE__*/React.createElement("div", {
    className: "footer-top"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "brand-lg"
  }, "Allan B. Pedin ", /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--cyan)"
    }
  }, "IV")), /*#__PURE__*/React.createElement("p", {
    className: "tag"
  }, "Build, explain, earn trust.")), /*#__PURE__*/React.createElement("div", {
    className: "footer-cols"
  }, D.footer.cols.map(col => /*#__PURE__*/React.createElement("div", {
    className: "footer-col",
    key: col.h
  }, /*#__PURE__*/React.createElement("h5", null, col.h), col.links.map(l => /*#__PURE__*/React.createElement("a", {
    key: l,
    href: "#",
    onClick: e => {
      e.preventDefault();
      if (D.nav.includes(l)) onNav(l);
    }
  }, l)))))), /*#__PURE__*/React.createElement("div", {
    className: "footer-bottom"
  }, /*#__PURE__*/React.createElement("span", null, D.footer.copyright), /*#__PURE__*/React.createElement("span", null, "allanbpediniv.com"))));
}
Object.assign(window, {
  Nav,
  Hero,
  Thesis,
  Work,
  SubscribeBand,
  Footer,
  Chip
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/components.jsx", error: String((e && e.message) || e) }); }

// ui_kits/site/data.js
try { (() => {
// ui_kits/site — content (sourced verbatim from allanbpediniv.com/info; do not invent)
window.ABPIV_DATA = {
  brand: {
    name: "ABPIV",
    full: "Allan B. Pedin IV"
  },
  nav: ["Insights", "News & Publications", "Featured On"],
  hero: {
    eyebrow: "Visionary Operator CEO",
    h1a: "Expanding individual agency through emerging technologies that help people and ",
    h1accent: "coordinate.",
    lede: "Allan connects published research, infrastructure work, and founder experience to make complex technology easier to use, evaluate, and build on.",
    proof: ["Published AI & Blockchain Researcher", "CipherPlay / RANDAO founder", "Web3 Thought Leader"]
  },
  thesis: {
    eyebrow: "Build, explain, earn trust",
    pillars: [{
      n: "01",
      t: "Insight",
      p: "AI, blockchain, and spatial computing are changing how we interact with the world around us."
    }, {
      n: "02",
      t: "Vision",
      p: "A new age of technology should expand human capability and make systems easier to navigate."
    }, {
      n: "03",
      t: "Execution",
      p: "Bringing that future closer through systems people can use, trust, and build on."
    }]
  },
  work: {
    Insights: [{
      meta: "Insights · Jul 1, 2025",
      t: "ICAP, Virginia, and Entrepreneurial Scientists",
      p: "A reflection on learning from customers and building around problems people actually feel."
    }, {
      meta: "Insights",
      t: "Turning technical work into momentum",
      p: "Short essays on learning from customers and building useful products."
    }, {
      meta: "Insights",
      t: "Building products people trust",
      p: "Notes on shipping infrastructure that holds up under real scrutiny."
    }],
    "News & Publications": [{
      meta: "News · Apr 30, 2026",
      t: "Site Launch",
      p: "The public home for Allan B. Pedin IV research, writing, appearances, and project updates."
    }, {
      meta: "Publication · Apr 30, 2026",
      t: "Truly Random Number Generation",
      p: "Research on truly random number generation for decentralized applications."
    }, {
      meta: "Publication · Apr 1, 2023",
      t: "Digital Asset Ownership",
      p: "Research on ownership, recovery, and smart-contract security for digital assets."
    }],
    "Featured On": [{
      meta: "Podcast · Mar 5, 2026",
      t: "How To Sell When You Sell Random Numbers",
      p: "A commercialization discussion about explaining technical infrastructure in plain language."
    }, {
      meta: "Talk · Jan 15, 2026",
      t: "Why Blockchains Can't Be Random (And Why It Matters for Trust)",
      p: "A practical explanation of why randomness matters in decentralized systems."
    }, {
      meta: "Session · Dec 3, 2025",
      t: "A Round Solve Session — Problem: Scale Founder-Led Growth",
      p: "Problem-solving on customer learning, sales motion, and scaling founder-led growth."
    }]
  },
  workIntro: {
    Insights: "Short essays on learning from customers, building useful products, and turning technical work into momentum.",
    "News & Publications": "Launch notes, research papers, and public updates from Allan's work in one place.",
    "Featured On": "Podcasts, interviews, and conference appearances on RANDAO, randomness, Web3 trust, and founder-led growth."
  },
  footer: {
    cols: [{
      h: "Explore",
      links: ["Insights", "News & Publications", "Featured On"]
    }, {
      h: "Connect",
      links: ["LinkedIn", "X / @AllanRANDAO", "GitHub", "YouTube"]
    }, {
      h: "Featured",
      links: ["HackerNoon", "Crunchbase", "F6S"]
    }],
    copyright: "Copyright © 2026 Allan B. Pedin IV."
  }
};
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/site/data.js", error: String((e && e.message) || e) }); }

// ui_kits/social/animations.jsx
try { (() => {
/* BEGIN USAGE */
// animations.jsx
// Reusable animation starter: Stage, Timeline, Sprite, easing helpers.
// Exports (to window): Stage, Sprite, PlaybackBar, TextSprite, ImageSprite, RectSprite,
//   useTime, useTimeline, useSprite, Easing, interpolate, animate, clamp.
//
// Usage (in an HTML file that loads React + Babel):
//
//   <Stage width={1280} height={720} duration={10} background="#f6f4ef">
//     <MyScene />
//   </Stage>
//
// <Stage> auto-scales to the viewport and provides the scrubber, play/pause,
// ←/→ seek, space, and 0-to-reset controls, and persists the playhead.
// Inside <Stage>, any child can call useTime() to read the current
// playhead (seconds). Or wrap content in <Sprite start={1} end={4}>...</Sprite>
// to only render during that window -- children receive a `localTime` and
// `progress` via the useSprite() hook. Use Easing + interpolate()/animate()
// for tweens; TextSprite / ImageSprite / RectSprite have built-in entry/exit.
// Build YOUR scenes by composing Sprites inside a Stage.
/* END USAGE */
// ─────────────────────────────────────────────────────────────────────────────

// ── Easing functions (hand-rolled, Popmotion-style) ─────────────────────────
// All easings take t ∈ [0,1] and return eased t ∈ [0,1] (may overshoot for back/elastic).
const Easing = {
  linear: t => t,
  // Quad
  easeInQuad: t => t * t,
  easeOutQuad: t => t * (2 - t),
  easeInOutQuad: t => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t,
  // Cubic
  easeInCubic: t => t * t * t,
  easeOutCubic: t => --t * t * t + 1,
  easeInOutCubic: t => t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1,
  // Quart
  easeInQuart: t => t * t * t * t,
  easeOutQuart: t => 1 - --t * t * t * t,
  easeInOutQuart: t => t < 0.5 ? 8 * t * t * t * t : 1 - 8 * --t * t * t * t,
  // Expo
  easeInExpo: t => t === 0 ? 0 : Math.pow(2, 10 * (t - 1)),
  easeOutExpo: t => t === 1 ? 1 : 1 - Math.pow(2, -10 * t),
  easeInOutExpo: t => {
    if (t === 0) return 0;
    if (t === 1) return 1;
    if (t < 0.5) return 0.5 * Math.pow(2, 20 * t - 10);
    return 1 - 0.5 * Math.pow(2, -20 * t + 10);
  },
  // Sine
  easeInSine: t => 1 - Math.cos(t * Math.PI / 2),
  easeOutSine: t => Math.sin(t * Math.PI / 2),
  easeInOutSine: t => -(Math.cos(Math.PI * t) - 1) / 2,
  // Back (overshoot)
  easeOutBack: t => {
    const c1 = 1.70158,
      c3 = c1 + 1;
    return 1 + c3 * Math.pow(t - 1, 3) + c1 * Math.pow(t - 1, 2);
  },
  easeInBack: t => {
    const c1 = 1.70158,
      c3 = c1 + 1;
    return c3 * t * t * t - c1 * t * t;
  },
  easeInOutBack: t => {
    const c1 = 1.70158,
      c2 = c1 * 1.525;
    return t < 0.5 ? Math.pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2) / 2 : (Math.pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2;
  },
  // Elastic
  easeOutElastic: t => {
    const c4 = 2 * Math.PI / 3;
    if (t === 0) return 0;
    if (t === 1) return 1;
    return Math.pow(2, -10 * t) * Math.sin((t * 10 - 0.75) * c4) + 1;
  }
};

// ── Core interpolation helpers ──────────────────────────────────────────────

// Clamp a value to [min, max]
const clamp = (v, min, max) => Math.max(min, Math.min(max, v));

// interpolate([0, 0.5, 1], [0, 100, 50], ease?) -> fn(t)
// Popmotion-style: linearly maps t across input keyframes to output values,
// with optional easing per segment (single fn or array of fns).
function interpolate(input, output, ease = Easing.linear) {
  return t => {
    if (t <= input[0]) return output[0];
    if (t >= input[input.length - 1]) return output[output.length - 1];
    for (let i = 0; i < input.length - 1; i++) {
      if (t >= input[i] && t <= input[i + 1]) {
        const span = input[i + 1] - input[i];
        const local = span === 0 ? 0 : (t - input[i]) / span;
        const easeFn = Array.isArray(ease) ? ease[i] || Easing.linear : ease;
        const eased = easeFn(local);
        return output[i] + (output[i + 1] - output[i]) * eased;
      }
    }
    return output[output.length - 1];
  };
}

// animate({from, to, start, end, ease})(t) — simpler single-segment tween.
// Returns `from` before `start`, `to` after `end`.
function animate({
  from = 0,
  to = 1,
  start = 0,
  end = 1,
  ease = Easing.easeInOutCubic
}) {
  return t => {
    if (t <= start) return from;
    if (t >= end) return to;
    const local = (t - start) / (end - start);
    return from + (to - from) * ease(local);
  };
}

// ── Timeline context ────────────────────────────────────────────────────────

const TimelineContext = React.createContext({
  time: 0,
  duration: 10,
  playing: false
});
const useTime = () => React.useContext(TimelineContext).time;
const useTimeline = () => React.useContext(TimelineContext);

// ── Sprite ──────────────────────────────────────────────────────────────────
// Renders children only when the playhead is inside [start, end]. Provides
// a sub-context with `localTime` (seconds since start) and `progress` (0..1).
//
//   <Sprite start={2} end={5}>
//     {({ localTime, progress }) => <Thing x={progress * 100} />}
//   </Sprite>
//
// Or as a plain wrapper — children can call useSprite() themselves.

const SpriteContext = React.createContext({
  localTime: 0,
  progress: 0,
  duration: 0
});
const useSprite = () => React.useContext(SpriteContext);
function Sprite({
  start = 0,
  end = Infinity,
  children,
  keepMounted = false
}) {
  const {
    time
  } = useTimeline();
  const visible = time >= start && time <= end;
  if (!visible && !keepMounted) return null;
  const duration = end - start;
  const localTime = Math.max(0, time - start);
  const progress = duration > 0 && isFinite(duration) ? clamp(localTime / duration, 0, 1) : 0;
  const value = {
    localTime,
    progress,
    duration,
    visible
  };
  return /*#__PURE__*/React.createElement(SpriteContext.Provider, {
    value: value
  }, typeof children === 'function' ? children(value) : children);
}

// ── Sample sprite components ────────────────────────────────────────────────

// TextSprite: fades/slides text in on entry, holds, then fades out on exit.
// Props: text, x, y, size, color, font, entryDur, exitDur, align
function TextSprite({
  text,
  x = 0,
  y = 0,
  size = 48,
  color = '#111',
  font = 'Inter, system-ui, sans-serif',
  weight = 600,
  entryDur = 0.45,
  exitDur = 0.35,
  entryEase = Easing.easeOutBack,
  exitEase = Easing.easeInCubic,
  align = 'left',
  letterSpacing = '-0.01em'
}) {
  const {
    localTime,
    duration
  } = useSprite();
  const exitStart = Math.max(0, duration - exitDur);
  let opacity = 1;
  let ty = 0;
  if (localTime < entryDur) {
    const t = entryEase(clamp(localTime / entryDur, 0, 1));
    opacity = t;
    ty = (1 - t) * 16;
  } else if (localTime > exitStart) {
    const t = exitEase(clamp((localTime - exitStart) / exitDur, 0, 1));
    opacity = 1 - t;
    ty = -t * 8;
  }
  const translateX = align === 'center' ? '-50%' : align === 'right' ? '-100%' : '0';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: x,
      top: y,
      transform: `translate(${translateX}, ${ty}px)`,
      opacity,
      fontFamily: font,
      fontSize: size,
      fontWeight: weight,
      color,
      letterSpacing,
      whiteSpace: 'pre',
      lineHeight: 1.1,
      willChange: 'transform, opacity'
    }
  }, text);
}

// ImageSprite: scales + fades in; optional Ken Burns drift during hold.
function ImageSprite({
  src,
  x = 0,
  y = 0,
  width = 400,
  height = 300,
  entryDur = 0.6,
  exitDur = 0.4,
  kenBurns = false,
  kenBurnsScale = 1.08,
  radius = 12,
  fit = 'cover',
  placeholder = null // {label: string} for striped placeholder
}) {
  const {
    localTime,
    duration
  } = useSprite();
  const exitStart = Math.max(0, duration - exitDur);
  let opacity = 1;
  let scale = 1;
  if (localTime < entryDur) {
    const t = Easing.easeOutCubic(clamp(localTime / entryDur, 0, 1));
    opacity = t;
    scale = 0.96 + 0.04 * t;
  } else if (localTime > exitStart) {
    const t = Easing.easeInCubic(clamp((localTime - exitStart) / exitDur, 0, 1));
    opacity = 1 - t;
    scale = (kenBurns ? kenBurnsScale : 1) + 0.02 * t;
  } else if (kenBurns) {
    const holdSpan = exitStart - entryDur;
    const holdT = holdSpan > 0 ? (localTime - entryDur) / holdSpan : 0;
    scale = 1 + (kenBurnsScale - 1) * holdT;
  }
  const content = placeholder ? /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      height: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: 'repeating-linear-gradient(135deg, #e9e6df 0 10px, #dcd8cf 10px 20px)',
      color: '#6b6458',
      fontFamily: 'JetBrains Mono, ui-monospace, monospace',
      fontSize: 13,
      letterSpacing: '0.04em',
      textTransform: 'uppercase'
    }
  }, placeholder.label || 'image') : /*#__PURE__*/React.createElement("img", {
    src: src,
    alt: "",
    style: {
      width: '100%',
      height: '100%',
      objectFit: fit,
      display: 'block'
    }
  });
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: x,
      top: y,
      width,
      height,
      opacity,
      transform: `scale(${scale})`,
      transformOrigin: 'center',
      borderRadius: radius,
      overflow: 'hidden',
      willChange: 'transform, opacity'
    }
  }, content);
}

// RectSprite: simple rectangle that animates position/size/color via props.
// Useful demo primitive — takes a `render` fn for per-frame customization.
function RectSprite({
  x = 0,
  y = 0,
  width = 100,
  height = 100,
  color = '#111',
  radius = 8,
  entryDur = 0.4,
  exitDur = 0.3,
  render // optional: (ctx) => style overrides
}) {
  const spriteCtx = useSprite();
  const {
    localTime,
    duration
  } = spriteCtx;
  const exitStart = Math.max(0, duration - exitDur);
  let opacity = 1;
  let scale = 1;
  if (localTime < entryDur) {
    const t = Easing.easeOutBack(clamp(localTime / entryDur, 0, 1));
    opacity = clamp(localTime / entryDur, 0, 1);
    scale = 0.4 + 0.6 * t;
  } else if (localTime > exitStart) {
    const t = Easing.easeInQuad(clamp((localTime - exitStart) / exitDur, 0, 1));
    opacity = 1 - t;
    scale = 1 - 0.15 * t;
  }
  const overrides = render ? render(spriteCtx) : {};
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: x,
      top: y,
      width,
      height,
      background: color,
      borderRadius: radius,
      opacity,
      transform: `scale(${scale})`,
      transformOrigin: 'center',
      willChange: 'transform, opacity',
      ...overrides
    }
  });
}
function Stage({
  width = 1280,
  height = 720,
  duration = 10,
  background = '#f6f4ef',
  fps = 60,
  loop = true,
  autoplay = true,
  persistKey = 'animstage',
  children
}) {
  const [time, setTime] = React.useState(() => {
    try {
      const v = parseFloat(localStorage.getItem(persistKey + ':t') || '0');
      return isFinite(v) ? clamp(v, 0, duration) : 0;
    } catch {
      return 0;
    }
  });
  const [playing, setPlaying] = React.useState(autoplay);
  const [hoverTime, setHoverTime] = React.useState(null);
  const [scale, setScale] = React.useState(1);
  const stageRef = React.useRef(null);
  const canvasRef = React.useRef(null);
  const rafRef = React.useRef(null);
  const lastTsRef = React.useRef(null);

  // Persist playhead
  React.useEffect(() => {
    try {
      localStorage.setItem(persistKey + ':t', String(time));
    } catch {}
  }, [time, persistKey]);

  // Auto-scale to fit viewport
  React.useEffect(() => {
    if (!stageRef.current) return;
    const el = stageRef.current;
    const measure = () => {
      const barH = 44; // playback bar height
      const s = Math.min(el.clientWidth / width, (el.clientHeight - barH) / height);
      setScale(Math.max(0.05, s));
    };
    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(el);
    window.addEventListener('resize', measure);
    return () => {
      ro.disconnect();
      window.removeEventListener('resize', measure);
    };
  }, [width, height]);

  // Animation loop
  React.useEffect(() => {
    if (!playing) {
      lastTsRef.current = null;
      return;
    }
    const step = ts => {
      if (lastTsRef.current == null) lastTsRef.current = ts;
      const dt = (ts - lastTsRef.current) / 1000;
      lastTsRef.current = ts;
      setTime(t => {
        let next = t + dt;
        if (next >= duration) {
          if (loop) next = next % duration;else {
            next = duration;
            setPlaying(false);
          }
        }
        return next;
      });
      rafRef.current = requestAnimationFrame(step);
    };
    rafRef.current = requestAnimationFrame(step);
    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
      lastTsRef.current = null;
    };
  }, [playing, duration, loop]);

  // Keyboard: space = play/pause, ← → = seek
  React.useEffect(() => {
    const onKey = e => {
      if (e.target && (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA')) return;
      if (e.code === 'Space') {
        e.preventDefault();
        setPlaying(p => !p);
      } else if (e.code === 'ArrowLeft') {
        setTime(t => clamp(t - (e.shiftKey ? 1 : 0.1), 0, duration));
      } else if (e.code === 'ArrowRight') {
        setTime(t => clamp(t + (e.shiftKey ? 1 : 0.1), 0, duration));
      } else if (e.key === '0' || e.code === 'Home') {
        setTime(0);
      }
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [duration]);
  const displayTime = hoverTime != null ? hoverTime : time;
  const ctxValue = React.useMemo(() => ({
    time: displayTime,
    duration,
    playing,
    setTime,
    setPlaying
  }), [displayTime, duration, playing]);
  return /*#__PURE__*/React.createElement("div", {
    ref: stageRef,
    style: {
      position: 'absolute',
      inset: 0,
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      background: '#0a0a0a',
      fontFamily: 'Inter, system-ui, sans-serif'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      width: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      overflow: 'hidden',
      minHeight: 0
    }
  }, /*#__PURE__*/React.createElement("div", {
    ref: canvasRef,
    style: {
      width,
      height,
      background,
      position: 'relative',
      transform: `scale(${scale})`,
      transformOrigin: 'center',
      flexShrink: 0,
      boxShadow: '0 20px 60px rgba(0,0,0,0.4)',
      overflow: 'hidden'
    }
  }, /*#__PURE__*/React.createElement(TimelineContext.Provider, {
    value: ctxValue
  }, children))), /*#__PURE__*/React.createElement(PlaybackBar, {
    time: displayTime,
    actualTime: time,
    duration: duration,
    playing: playing,
    onPlayPause: () => setPlaying(p => !p),
    onReset: () => {
      setTime(0);
    },
    onSeek: t => setTime(t),
    onHover: t => setHoverTime(t)
  }));
}

// ── Playback bar ────────────────────────────────────────────────────────────
// Play/pause, return-to-begin, scrub track, time display.
// Uses fixed-width time fields so layout doesn't thrash.

function PlaybackBar({
  time,
  duration,
  playing,
  onPlayPause,
  onReset,
  onSeek,
  onHover
}) {
  const trackRef = React.useRef(null);
  const [dragging, setDragging] = React.useState(false);
  const timeFromEvent = React.useCallback(e => {
    const rect = trackRef.current.getBoundingClientRect();
    const x = clamp((e.clientX - rect.left) / rect.width, 0, 1);
    return x * duration;
  }, [duration]);
  const onTrackMove = e => {
    if (!trackRef.current) return;
    const t = timeFromEvent(e);
    if (dragging) {
      onSeek(t);
    } else {
      onHover(t);
    }
  };
  const onTrackLeave = () => {
    if (!dragging) onHover(null);
  };
  const onTrackDown = e => {
    setDragging(true);
    const t = timeFromEvent(e);
    onSeek(t);
    onHover(null);
  };
  React.useEffect(() => {
    if (!dragging) return;
    const onUp = () => setDragging(false);
    const onMove = e => {
      if (!trackRef.current) return;
      const t = timeFromEvent(e);
      onSeek(t);
    };
    window.addEventListener('mouseup', onUp);
    window.addEventListener('mousemove', onMove);
    return () => {
      window.removeEventListener('mouseup', onUp);
      window.removeEventListener('mousemove', onMove);
    };
  }, [dragging, timeFromEvent, onSeek]);
  const pct = duration > 0 ? time / duration * 100 : 0;
  const fmt = t => {
    const total = Math.max(0, t);
    const m = Math.floor(total / 60);
    const s = Math.floor(total % 60);
    const cs = Math.floor(total * 100 % 100);
    return `${String(m).padStart(1, '0')}:${String(s).padStart(2, '0')}.${String(cs).padStart(2, '0')}`;
  };
  const mono = 'JetBrains Mono, ui-monospace, SFMono-Regular, monospace';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      gap: 12,
      padding: '8px 16px',
      background: 'rgba(20,20,20,0.92)',
      borderTop: '1px solid rgba(255,255,255,0.08)',
      width: '100%',
      maxWidth: 680,
      alignSelf: 'center',
      borderRadius: 8,
      color: '#f6f4ef',
      fontFamily: 'Inter, system-ui, sans-serif',
      userSelect: 'none',
      flexShrink: 0
    }
  }, /*#__PURE__*/React.createElement(IconButton, {
    onClick: onReset,
    title: "Return to start (0)"
  }, /*#__PURE__*/React.createElement("svg", {
    width: "14",
    height: "14",
    viewBox: "0 0 14 14",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M3 2v10M12 2L5 7l7 5V2z",
    stroke: "currentColor",
    strokeWidth: "1.5",
    strokeLinejoin: "round",
    strokeLinecap: "round"
  }))), /*#__PURE__*/React.createElement(IconButton, {
    onClick: onPlayPause,
    title: "Play/pause (space)"
  }, playing ? /*#__PURE__*/React.createElement("svg", {
    width: "14",
    height: "14",
    viewBox: "0 0 14 14",
    fill: "none"
  }, /*#__PURE__*/React.createElement("rect", {
    x: "3",
    y: "2",
    width: "3",
    height: "10",
    fill: "currentColor"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "8",
    y: "2",
    width: "3",
    height: "10",
    fill: "currentColor"
  })) : /*#__PURE__*/React.createElement("svg", {
    width: "14",
    height: "14",
    viewBox: "0 0 14 14",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M3 2l9 5-9 5V2z",
    fill: "currentColor"
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: mono,
      fontSize: 12,
      fontVariantNumeric: 'tabular-nums',
      width: 64,
      textAlign: 'right',
      color: '#f6f4ef'
    }
  }, fmt(time)), /*#__PURE__*/React.createElement("div", {
    ref: trackRef,
    onMouseMove: onTrackMove,
    onMouseLeave: onTrackLeave,
    onMouseDown: onTrackDown,
    style: {
      flex: 1,
      height: 22,
      position: 'relative',
      cursor: 'pointer',
      display: 'flex',
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      right: 0,
      height: 4,
      background: 'rgba(255,255,255,0.12)',
      borderRadius: 2
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 0,
      width: `${pct}%`,
      height: 4,
      background: 'oklch(72% 0.12 250)',
      borderRadius: 2
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: `${pct}%`,
      top: '50%',
      width: 12,
      height: 12,
      marginLeft: -6,
      marginTop: -6,
      background: '#fff',
      borderRadius: 6,
      boxShadow: '0 2px 4px rgba(0,0,0,0.4)'
    }
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: mono,
      fontSize: 12,
      fontVariantNumeric: 'tabular-nums',
      width: 64,
      textAlign: 'left',
      color: 'rgba(246,244,239,0.55)'
    }
  }, fmt(duration)));
}
function IconButton({
  children,
  onClick,
  title
}) {
  const [hover, setHover] = React.useState(false);
  return /*#__PURE__*/React.createElement("button", {
    onClick: onClick,
    title: title,
    onMouseEnter: () => setHover(true),
    onMouseLeave: () => setHover(false),
    style: {
      width: 28,
      height: 28,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      background: hover ? 'rgba(255,255,255,0.12)' : 'rgba(255,255,255,0.04)',
      border: '1px solid rgba(255,255,255,0.1)',
      borderRadius: 6,
      color: '#f6f4ef',
      cursor: 'pointer',
      padding: 0,
      transition: 'background 120ms'
    }
  }, children);
}
Object.assign(window, {
  Easing,
  interpolate,
  animate,
  clamp,
  TimelineContext,
  useTime,
  useTimeline,
  Sprite,
  SpriteContext,
  useSprite,
  TextSprite,
  ImageSprite,
  RectSprite,
  Stage,
  PlaybackBar
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/social/animations.jsx", error: String((e && e.message) || e) }); }

// ui_kits/social/primitives.jsx
try { (() => {
// ui_kits/social — primitives for the marketing animation
// (composes the animations.jsx engine: Sprite, useSprite, useTime, Easing, clamp)

const SANS = "Schibsted Grotesk, sans-serif";
const MONO = "IBM Plex Mono, monospace";

// Entry fade-up + scene-exit fade, driven by the parent Sprite's clock.
function Anim({
  at = 0,
  dur = 0.6,
  exitDur = 0.45,
  y = 26,
  ease,
  children,
  style
}) {
  const {
    localTime,
    duration
  } = useSprite();
  const entry = (ease || Easing.easeOutCubic)(clamp((localTime - at) / dur, 0, 1));
  const exitStart = duration - exitDur;
  let exitO = 1,
    exitY = 0;
  if (localTime > exitStart) {
    const t = Easing.easeInCubic(clamp((localTime - exitStart) / exitDur, 0, 1));
    exitO = 1 - t;
    exitY = -t * 16;
  }
  return /*#__PURE__*/React.createElement("div", {
    style: {
      opacity: entry * exitO,
      transform: `translateY(${(1 - entry) * y + exitY}px)`,
      willChange: "transform,opacity",
      ...style
    }
  }, children);
}

// A path that "draws" itself (stroke-dashoffset) over [at, at+dur].
function RouteLine({
  d,
  at = 0,
  dur = 1.1,
  color = "var(--cyan-line)",
  width = 1.5,
  ease,
  exitDur = 0.45,
  dash
}) {
  const {
    localTime,
    duration
  } = useSprite();
  const prog = (ease || Easing.easeOutCubic)(clamp((localTime - at) / dur, 0, 1));
  const exitStart = duration - exitDur;
  let o = 1;
  if (localTime > exitStart) o = 1 - clamp((localTime - exitStart) / exitDur, 0, 1);
  return /*#__PURE__*/React.createElement("path", {
    d: d,
    fill: "none",
    stroke: color,
    strokeWidth: width,
    strokeLinecap: "round",
    pathLength: "1",
    strokeDasharray: dash || "1",
    strokeDashoffset: 1 - prog,
    style: {
      opacity: o
    }
  });
}

// A node dot that pops in at `at`, with optional infinite pulse.
function Node({
  cx,
  cy,
  r = 5,
  color = "var(--cyan)",
  at = 0,
  pulse = false
}) {
  const {
    localTime,
    duration
  } = useSprite();
  const p = Easing.easeOutBack(clamp((localTime - at) / 0.4, 0, 1));
  const exitStart = duration - 0.45;
  let o = 1;
  if (localTime > exitStart) o = 1 - clamp((localTime - exitStart) / 0.45, 0, 1);
  const pr = pulse ? r * (1 + 0.18 * Math.sin((localTime - at) * 3.2)) : r;
  return /*#__PURE__*/React.createElement("circle", {
    cx: cx,
    cy: cy,
    r: pr * p,
    fill: color,
    style: {
      opacity: o
    }
  });
}
const Eyebrow = ({
  children,
  color = "var(--cyan)"
}) => /*#__PURE__*/React.createElement("div", {
  style: {
    display: "flex",
    alignItems: "center",
    gap: 16,
    fontFamily: MONO,
    fontWeight: 500,
    fontSize: 22,
    letterSpacing: "0.2em",
    textTransform: "uppercase",
    color
  }
}, /*#__PURE__*/React.createElement("span", {
  style: {
    width: 44,
    height: 1.5,
    background: color,
    opacity: 0.75
  }
}), children);
Object.assign(window, {
  Anim,
  RouteLine,
  Node,
  Eyebrow,
  SANS,
  MONO
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/social/primitives.jsx", error: String((e && e.message) || e) }); }

// ui_kits/social/scenes.jsx
try { (() => {
// ui_kits/social — the marketing animation scenes (canvas 1080×1350)
const W = 1080,
  H = 1350,
  MX = 110;

// ── Persistent faint system-map background with slow vertical parallax ──
function BackgroundField() {
  const time = useTime();
  const drift = Math.sin(time * 0.35) * 14;
  return /*#__PURE__*/React.createElement("svg", {
    width: W,
    height: H,
    style: {
      position: "absolute",
      inset: 0
    },
    "aria-hidden": "true"
  }, /*#__PURE__*/React.createElement("defs", null, /*#__PURE__*/React.createElement("radialGradient", {
    id: "lift",
    cx: "50%",
    cy: "34%",
    r: "75%"
  }, /*#__PURE__*/React.createElement("stop", {
    offset: "0%",
    stopColor: "rgba(44,200,220,0.10)"
  }), /*#__PURE__*/React.createElement("stop", {
    offset: "55%",
    stopColor: "rgba(44,200,220,0.0)"
  }))), /*#__PURE__*/React.createElement("rect", {
    width: W,
    height: H,
    fill: "url(#lift)"
  }), /*#__PURE__*/React.createElement("g", {
    stroke: "rgba(120,160,200,0.07)",
    strokeWidth: "1"
  }, [MX, 360, 540, 720, W - MX].map(x => /*#__PURE__*/React.createElement("line", {
    key: x,
    x1: x,
    y1: "0",
    x2: x,
    y2: H,
    transform: `translate(${drift * (x > 540 ? 1 : -1) * 0.3} 0)`
  }))), /*#__PURE__*/React.createElement("g", {
    stroke: "rgba(120,160,200,0.05)",
    strokeWidth: "1"
  }, [300, 700, 1050].map(y => /*#__PURE__*/React.createElement("line", {
    key: y,
    x1: "0",
    y1: y,
    x2: W,
    y2: y
  }))));
}

// ── Persistent brand tag + scene progress dashes ──
function Chrome() {
  const time = useTime();
  const dur = useTimeline().duration;
  const bounds = [0, 4.2, 8.6, 12.4, dur];
  const scene = bounds.findIndex((b, i) => time >= b && time < bounds[i + 1]);
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      left: MX,
      top: 70,
      display: "flex",
      alignItems: "center",
      gap: 12,
      opacity: 0.85
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: SANS,
      fontWeight: 800,
      fontSize: 26,
      letterSpacing: "0.04em",
      color: "var(--fg-0)"
    }
  }, "ABPIV")), /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      right: MX,
      top: 78,
      display: "flex",
      gap: 8
    }
  }, [0, 1, 2, 3].map(i => /*#__PURE__*/React.createElement("span", {
    key: i,
    style: {
      width: i === scene ? 26 : 12,
      height: 4,
      borderRadius: 2,
      background: i === scene ? "var(--cyan)" : "rgba(120,160,200,0.22)",
      transition: "width 300ms"
    }
  }))));
}

// ── Scene 1 — Hook ──
function SceneHook() {
  return /*#__PURE__*/React.createElement(Sprite, {
    start: 0,
    end: 4.2
  }, /*#__PURE__*/React.createElement("svg", {
    width: W,
    height: H,
    style: {
      position: "absolute",
      inset: 0
    }
  }, /*#__PURE__*/React.createElement(RouteLine, {
    d: `M0 560 H${MX + 230} Q${MX + 360} 560 ${MX + 360} 700 H${W}`,
    at: 0.1,
    dur: 1.4,
    width: 1.4
  }), /*#__PURE__*/React.createElement(RouteLine, {
    d: `M0 760 H${W}`,
    at: 0.35,
    dur: 1.2,
    color: "rgba(95,230,244,0.35)",
    width: 1.2
  }), /*#__PURE__*/React.createElement(Node, {
    cx: MX + 360,
    cy: 700,
    r: 5.5,
    color: "var(--amber)",
    at: 1.3,
    pulse: true
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      left: MX,
      top: 430,
      right: MX
    }
  }, /*#__PURE__*/React.createElement(Anim, {
    at: 0.15,
    dur: 0.6
  }, /*#__PURE__*/React.createElement(Eyebrow, null, "Visionary Operator CEO")), /*#__PURE__*/React.createElement(Anim, {
    at: 0.45,
    dur: 0.7,
    y: 34,
    style: {
      marginTop: 34
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: SANS,
      fontWeight: 800,
      fontSize: 104,
      lineHeight: 0.97,
      letterSpacing: "-0.035em",
      color: "var(--fg-0)"
    }
  }, "Expanding", /*#__PURE__*/React.createElement("br", null), "individual")), /*#__PURE__*/React.createElement(Anim, {
    at: 0.85,
    dur: 0.7,
    y: 34
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: SANS,
      fontWeight: 800,
      fontSize: 104,
      lineHeight: 1.0,
      letterSpacing: "-0.035em",
      color: "var(--amber)"
    }
  }, "agency.")), /*#__PURE__*/React.createElement(Anim, {
    at: 1.5,
    dur: 0.7,
    y: 22,
    style: {
      marginTop: 40
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: SANS,
      fontWeight: 400,
      fontSize: 38,
      lineHeight: 1.45,
      color: "var(--fg-1)",
      maxWidth: 760
    }
  }, "Through emerging technologies that help people and systems coordinate."))));
}

// ── Scene 2 — Proof ──
const PROOF = ["Published AI & Blockchain Researcher", "CipherPlay / RANDAO founder", "Web3 Thought Leader"];
function SceneProof() {
  const rowY = [700, 880, 1060];
  return /*#__PURE__*/React.createElement(Sprite, {
    start: 4.2,
    end: 8.6
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      left: MX,
      top: 410,
      right: MX
    }
  }, /*#__PURE__*/React.createElement(Anim, {
    at: 0.1,
    dur: 0.6
  }, /*#__PURE__*/React.createElement(Eyebrow, null, "In public \xB7 on the record")), /*#__PURE__*/React.createElement(Anim, {
    at: 0.3,
    dur: 0.7,
    y: 28,
    style: {
      marginTop: 28
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: SANS,
      fontWeight: 700,
      fontSize: 72,
      lineHeight: 1.0,
      letterSpacing: "-0.03em",
      color: "var(--fg-0)"
    }
  }, "The signal,", /*#__PURE__*/React.createElement("br", null), "not the noise."))), /*#__PURE__*/React.createElement("svg", {
    width: W,
    height: H,
    style: {
      position: "absolute",
      inset: 0
    }
  }, rowY.map((y, i) => /*#__PURE__*/React.createElement(RouteLine, {
    key: i,
    d: `M${MX} ${y} H${W - MX}`,
    at: 0.9 + i * 0.28,
    dur: 0.8,
    color: "rgba(95,230,244,0.4)",
    width: 1.2,
    dash: "1"
  })), rowY.map((y, i) => /*#__PURE__*/React.createElement(Node, {
    key: i,
    cx: MX,
    cy: y,
    r: 6,
    at: 0.9 + i * 0.28,
    color: i === 1 ? "var(--amber)" : "var(--cyan)"
  }))), PROOF.map((p, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      position: "absolute",
      left: MX + 36,
      top: rowY[i] - 44,
      right: MX
    }
  }, /*#__PURE__*/React.createElement(Anim, {
    at: 1.0 + i * 0.28,
    dur: 0.6,
    y: 16
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: "flex",
      alignItems: "baseline",
      gap: 22
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: MONO,
      fontWeight: 500,
      fontSize: 22,
      color: i === 1 ? "var(--amber)" : "var(--cyan)"
    }
  }, `0${i + 1}`), /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: SANS,
      fontWeight: 600,
      fontSize: 40,
      letterSpacing: "-0.02em",
      color: "var(--fg-0)"
    }
  }, p))))));
}

// ── Scene 3 — Thesis ──
const PILLARS = [["01", "Insight"], ["02", "Vision"], ["03", "Execution"]];
function SceneThesis() {
  const colW = (W - MX * 2 - 48) / 3;
  const baseY = 800;
  return /*#__PURE__*/React.createElement(Sprite, {
    start: 8.6,
    end: 12.4
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      left: MX,
      top: 430,
      right: MX
    }
  }, /*#__PURE__*/React.createElement(Anim, {
    at: 0.1,
    dur: 0.6
  }, /*#__PURE__*/React.createElement(Eyebrow, null, "The operating thesis")), /*#__PURE__*/React.createElement(Anim, {
    at: 0.35,
    dur: 0.7,
    y: 30,
    style: {
      marginTop: 30
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: SANS,
      fontWeight: 800,
      fontSize: 96,
      lineHeight: 1.0,
      letterSpacing: "-0.035em",
      color: "var(--fg-0)"
    }
  }, "Build, explain,", /*#__PURE__*/React.createElement("br", null), /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--amber)"
    }
  }, "earn trust.")))), /*#__PURE__*/React.createElement("svg", {
    width: W,
    height: H,
    style: {
      position: "absolute",
      inset: 0
    }
  }, /*#__PURE__*/React.createElement(RouteLine, {
    d: `M${MX} ${baseY} H${W - MX}`,
    at: 1.0,
    dur: 1.0,
    color: "rgba(95,230,244,0.45)",
    width: 1.4
  }), PILLARS.map((_, i) => /*#__PURE__*/React.createElement(Node, {
    key: i,
    cx: MX + colW / 2 + i * (colW + 24),
    cy: baseY,
    r: 6,
    at: 1.2 + i * 0.22,
    color: i === 2 ? "var(--amber)" : "var(--cyan)",
    pulse: i === 2
  }))), PILLARS.map(([n, t], i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    style: {
      position: "absolute",
      left: MX + i * (colW + 24),
      top: baseY + 34,
      width: colW
    }
  }, /*#__PURE__*/React.createElement(Anim, {
    at: 1.3 + i * 0.22,
    dur: 0.6,
    y: 20
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: MONO,
      fontWeight: 500,
      fontSize: 22,
      color: i === 2 ? "var(--amber)" : "var(--cyan)"
    }
  }, n), /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: SANS,
      fontWeight: 700,
      fontSize: 50,
      letterSpacing: "-0.02em",
      color: "var(--fg-0)",
      marginTop: 10
    }
  }, t)))));
}

// ── Scene 4 — Close / wordmark ──
function SceneClose() {
  return /*#__PURE__*/React.createElement(Sprite, {
    start: 12.4,
    end: 15.2
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: "absolute",
      inset: 0,
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
      justifyContent: "center",
      textAlign: "center"
    }
  }, /*#__PURE__*/React.createElement(Anim, {
    at: 0.1,
    dur: 0.7,
    y: 20
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: MONO,
      fontWeight: 500,
      fontSize: 26,
      letterSpacing: "0.32em",
      textTransform: "uppercase",
      color: "var(--cyan)",
      paddingLeft: "0.32em"
    }
  }, "ABPIV")), /*#__PURE__*/React.createElement(Anim, {
    at: 0.45,
    dur: 0.7,
    y: 26,
    style: {
      marginTop: 44
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: SANS,
      fontWeight: 800,
      fontSize: 92,
      letterSpacing: "-0.03em",
      color: "var(--fg-0)"
    }
  }, "Allan B. Pedin ", /*#__PURE__*/React.createElement("span", {
    style: {
      color: "var(--cyan)"
    }
  }, "IV"))), /*#__PURE__*/React.createElement(Anim, {
    at: 0.85,
    dur: 0.7
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 120,
      height: 3,
      background: "var(--amber)",
      borderRadius: 2,
      margin: "30px auto 0"
    }
  })), /*#__PURE__*/React.createElement(Anim, {
    at: 1.1,
    dur: 0.7,
    style: {
      marginTop: 30
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: MONO,
      fontWeight: 400,
      fontSize: 26,
      letterSpacing: "0.14em",
      textTransform: "uppercase",
      color: "var(--fg-2)"
    }
  }, "ABPIV \xB7 allanbpediniv.com"))));
}
function MarketingFilm() {
  return /*#__PURE__*/React.createElement(Stage, {
    width: W,
    height: H,
    duration: 15.2,
    background: "#070B14",
    persistKey: "abpiv-social"
  }, /*#__PURE__*/React.createElement(BackgroundField, null), /*#__PURE__*/React.createElement(SceneHook, null), /*#__PURE__*/React.createElement(SceneProof, null), /*#__PURE__*/React.createElement(SceneThesis, null), /*#__PURE__*/React.createElement(SceneClose, null), /*#__PURE__*/React.createElement(Chrome, null));
}
ReactDOM.createRoot(document.getElementById("root")).render(/*#__PURE__*/React.createElement(MarketingFilm, null));
})(); } catch (e) { __ds_ns.__errors.push({ path: "ui_kits/social/scenes.jsx", error: String((e && e.message) || e) }); }

})();
