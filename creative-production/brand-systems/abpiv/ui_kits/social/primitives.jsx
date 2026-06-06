// ui_kits/social — primitives for the marketing animation
// (composes the animations.jsx engine: Sprite, useSprite, useTime, Easing, clamp)

const SANS = "Schibsted Grotesk, sans-serif";
const MONO = "IBM Plex Mono, monospace";

// Entry fade-up + scene-exit fade, driven by the parent Sprite's clock.
function Anim({ at = 0, dur = 0.6, exitDur = 0.45, y = 26, ease, children, style }) {
  const { localTime, duration } = useSprite();
  const entry = (ease || Easing.easeOutCubic)(clamp((localTime - at) / dur, 0, 1));
  const exitStart = duration - exitDur;
  let exitO = 1, exitY = 0;
  if (localTime > exitStart) {
    const t = Easing.easeInCubic(clamp((localTime - exitStart) / exitDur, 0, 1));
    exitO = 1 - t; exitY = -t * 16;
  }
  return (
    <div style={{ opacity: entry * exitO, transform: `translateY(${(1 - entry) * y + exitY}px)`, willChange: "transform,opacity", ...style }}>
      {children}
    </div>
  );
}

// A path that "draws" itself (stroke-dashoffset) over [at, at+dur].
function RouteLine({ d, at = 0, dur = 1.1, color = "var(--cyan-line)", width = 1.5, ease, exitDur = 0.45, dash }) {
  const { localTime, duration } = useSprite();
  const prog = (ease || Easing.easeOutCubic)(clamp((localTime - at) / dur, 0, 1));
  const exitStart = duration - exitDur;
  let o = 1;
  if (localTime > exitStart) o = 1 - clamp((localTime - exitStart) / exitDur, 0, 1);
  return (
    <path d={d} fill="none" stroke={color} strokeWidth={width} strokeLinecap="round"
      pathLength="1" strokeDasharray={dash || "1"} strokeDashoffset={1 - prog} style={{ opacity: o }} />
  );
}

// A node dot that pops in at `at`, with optional infinite pulse.
function Node({ cx, cy, r = 5, color = "var(--cyan)", at = 0, pulse = false }) {
  const { localTime, duration } = useSprite();
  const p = Easing.easeOutBack(clamp((localTime - at) / 0.4, 0, 1));
  const exitStart = duration - 0.45;
  let o = 1;
  if (localTime > exitStart) o = 1 - clamp((localTime - exitStart) / 0.45, 0, 1);
  const pr = pulse ? r * (1 + 0.18 * Math.sin((localTime - at) * 3.2)) : r;
  return <circle cx={cx} cy={cy} r={pr * p} fill={color} style={{ opacity: o }} />;
}

const Eyebrow = ({ children, color = "var(--cyan)" }) => (
  <div style={{ display: "flex", alignItems: "center", gap: 16, fontFamily: MONO, fontWeight: 500, fontSize: 22, letterSpacing: "0.2em", textTransform: "uppercase", color }}>
    <span style={{ width: 44, height: 1.5, background: color, opacity: 0.75 }}></span>{children}
  </div>
);

Object.assign(window, { Anim, RouteLine, Node, Eyebrow, SANS, MONO });
