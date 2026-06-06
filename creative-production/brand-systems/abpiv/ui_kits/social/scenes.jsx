// ui_kits/social — the marketing animation scenes (canvas 1080×1350)
const W = 1080, H = 1350, MX = 110;

// ── Persistent faint system-map background with slow vertical parallax ──
function BackgroundField() {
  const time = useTime();
  const drift = Math.sin(time * 0.35) * 14;
  return (
    <svg width={W} height={H} style={{ position: "absolute", inset: 0 }} aria-hidden="true">
      <defs>
        <radialGradient id="lift" cx="50%" cy="34%" r="75%">
          <stop offset="0%" stopColor="rgba(44,200,220,0.10)" />
          <stop offset="55%" stopColor="rgba(44,200,220,0.0)" />
        </radialGradient>
      </defs>
      <rect width={W} height={H} fill="url(#lift)" />
      <g stroke="rgba(120,160,200,0.07)" strokeWidth="1">
        {[MX, 360, 540, 720, W - MX].map((x) => (
          <line key={x} x1={x} y1="0" x2={x} y2={H} transform={`translate(${drift * (x > 540 ? 1 : -1) * 0.3} 0)`} />
        ))}
      </g>
      <g stroke="rgba(120,160,200,0.05)" strokeWidth="1">
        {[300, 700, 1050].map((y) => <line key={y} x1="0" y1={y} x2={W} y2={y} />)}
      </g>
    </svg>
  );
}

// ── Persistent brand tag + scene progress dashes ──
function Chrome() {
  const time = useTime();
  const dur = useTimeline().duration;
  const bounds = [0, 4.2, 8.6, 12.4, dur];
  const scene = bounds.findIndex((b, i) => time >= b && time < bounds[i + 1]);
  return (
    <React.Fragment>
      <div style={{ position: "absolute", left: MX, top: 70, display: "flex", alignItems: "center", gap: 12, opacity: 0.85 }}>
        <span style={{ fontFamily: SANS, fontWeight: 800, fontSize: 26, letterSpacing: "0.04em", color: "var(--fg-0)" }}>ABPIV</span>
      </div>
      <div style={{ position: "absolute", right: MX, top: 78, display: "flex", gap: 8 }}>
        {[0, 1, 2, 3].map((i) => (
          <span key={i} style={{ width: i === scene ? 26 : 12, height: 4, borderRadius: 2, background: i === scene ? "var(--cyan)" : "rgba(120,160,200,0.22)", transition: "width 300ms" }}></span>
        ))}
      </div>
    </React.Fragment>
  );
}

// ── Scene 1 — Hook ──
function SceneHook() {
  return (
    <Sprite start={0} end={4.2}>
      <svg width={W} height={H} style={{ position: "absolute", inset: 0 }}>
        <RouteLine d={`M0 560 H${MX + 230} Q${MX + 360} 560 ${MX + 360} 700 H${W}`} at={0.1} dur={1.4} width={1.4} />
        <RouteLine d={`M0 760 H${W}`} at={0.35} dur={1.2} color="rgba(95,230,244,0.35)" width={1.2} />
        <Node cx={MX + 360} cy={700} r={5.5} color="var(--amber)" at={1.3} pulse />
      </svg>
      <div style={{ position: "absolute", left: MX, top: 430, right: MX }}>
        <Anim at={0.15} dur={0.6}><Eyebrow>Visionary Operator CEO</Eyebrow></Anim>
        <Anim at={0.45} dur={0.7} y={34} style={{ marginTop: 34 }}>
          <div style={{ fontFamily: SANS, fontWeight: 800, fontSize: 104, lineHeight: 0.97, letterSpacing: "-0.035em", color: "var(--fg-0)" }}>Expanding<br />individual</div>
        </Anim>
        <Anim at={0.85} dur={0.7} y={34}>
          <div style={{ fontFamily: SANS, fontWeight: 800, fontSize: 104, lineHeight: 1.0, letterSpacing: "-0.035em", color: "var(--amber)" }}>agency.</div>
        </Anim>
        <Anim at={1.5} dur={0.7} y={22} style={{ marginTop: 40 }}>
          <div style={{ fontFamily: SANS, fontWeight: 400, fontSize: 38, lineHeight: 1.45, color: "var(--fg-1)", maxWidth: 760 }}>
            Through emerging technologies that help people and systems coordinate.
          </div>
        </Anim>
      </div>
    </Sprite>
  );
}

// ── Scene 2 — Proof ──
const PROOF = ["Published AI & Blockchain Researcher", "CipherPlay / RANDAO founder", "Web3 Thought Leader"];
function SceneProof() {
  const rowY = [700, 880, 1060];
  return (
    <Sprite start={4.2} end={8.6}>
      <div style={{ position: "absolute", left: MX, top: 410, right: MX }}>
        <Anim at={0.1} dur={0.6}><Eyebrow>In public · on the record</Eyebrow></Anim>
        <Anim at={0.3} dur={0.7} y={28} style={{ marginTop: 28 }}>
          <div style={{ fontFamily: SANS, fontWeight: 700, fontSize: 72, lineHeight: 1.0, letterSpacing: "-0.03em", color: "var(--fg-0)" }}>The signal,<br />not the noise.</div>
        </Anim>
      </div>
      <svg width={W} height={H} style={{ position: "absolute", inset: 0 }}>
        {rowY.map((y, i) => (
          <RouteLine key={i} d={`M${MX} ${y} H${W - MX}`} at={0.9 + i * 0.28} dur={0.8} color="rgba(95,230,244,0.4)" width={1.2} dash="1" />
        ))}
        {rowY.map((y, i) => <Node key={i} cx={MX} cy={y} r={6} at={0.9 + i * 0.28} color={i === 1 ? "var(--amber)" : "var(--cyan)"} />)}
      </svg>
      {PROOF.map((p, i) => (
        <div key={i} style={{ position: "absolute", left: MX + 36, top: rowY[i] - 44, right: MX }}>
          <Anim at={1.0 + i * 0.28} dur={0.6} y={16}>
            <div style={{ display: "flex", alignItems: "baseline", gap: 22 }}>
              <span style={{ fontFamily: MONO, fontWeight: 500, fontSize: 22, color: i === 1 ? "var(--amber)" : "var(--cyan)" }}>{`0${i + 1}`}</span>
              <span style={{ fontFamily: SANS, fontWeight: 600, fontSize: 40, letterSpacing: "-0.02em", color: "var(--fg-0)" }}>{p}</span>
            </div>
          </Anim>
        </div>
      ))}
    </Sprite>
  );
}

// ── Scene 3 — Thesis ──
const PILLARS = [["01", "Insight"], ["02", "Vision"], ["03", "Execution"]];
function SceneThesis() {
  const colW = (W - MX * 2 - 48) / 3;
  const baseY = 800;
  return (
    <Sprite start={8.6} end={12.4}>
      <div style={{ position: "absolute", left: MX, top: 430, right: MX }}>
        <Anim at={0.1} dur={0.6}><Eyebrow>The operating thesis</Eyebrow></Anim>
        <Anim at={0.35} dur={0.7} y={30} style={{ marginTop: 30 }}>
          <div style={{ fontFamily: SANS, fontWeight: 800, fontSize: 96, lineHeight: 1.0, letterSpacing: "-0.035em", color: "var(--fg-0)" }}>
            Build, explain,<br /><span style={{ color: "var(--amber)" }}>earn trust.</span>
          </div>
        </Anim>
      </div>
      <svg width={W} height={H} style={{ position: "absolute", inset: 0 }}>
        <RouteLine d={`M${MX} ${baseY} H${W - MX}`} at={1.0} dur={1.0} color="rgba(95,230,244,0.45)" width={1.4} />
        {PILLARS.map((_, i) => <Node key={i} cx={MX + colW / 2 + i * (colW + 24)} cy={baseY} r={6} at={1.2 + i * 0.22} color={i === 2 ? "var(--amber)" : "var(--cyan)"} pulse={i === 2} />)}
      </svg>
      {PILLARS.map(([n, t], i) => (
        <div key={i} style={{ position: "absolute", left: MX + i * (colW + 24), top: baseY + 34, width: colW }}>
          <Anim at={1.3 + i * 0.22} dur={0.6} y={20}>
            <div style={{ fontFamily: MONO, fontWeight: 500, fontSize: 22, color: i === 2 ? "var(--amber)" : "var(--cyan)" }}>{n}</div>
            <div style={{ fontFamily: SANS, fontWeight: 700, fontSize: 50, letterSpacing: "-0.02em", color: "var(--fg-0)", marginTop: 10 }}>{t}</div>
          </Anim>
        </div>
      ))}
    </Sprite>
  );
}

// ── Scene 4 — Close / wordmark ──
function SceneClose() {
  return (
    <Sprite start={12.4} end={15.2}>
      <div style={{ position: "absolute", inset: 0, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", textAlign: "center" }}>
        <Anim at={0.1} dur={0.7} y={20}>
          <div style={{ fontFamily: MONO, fontWeight: 500, fontSize: 26, letterSpacing: "0.32em", textTransform: "uppercase", color: "var(--cyan)", paddingLeft: "0.32em" }}>ABPIV</div>
        </Anim>
        <Anim at={0.45} dur={0.7} y={26} style={{ marginTop: 44 }}>
          <div style={{ fontFamily: SANS, fontWeight: 800, fontSize: 92, letterSpacing: "-0.03em", color: "var(--fg-0)" }}>
            Allan B. Pedin <span style={{ color: "var(--cyan)" }}>IV</span>
          </div>
        </Anim>
        <Anim at={0.85} dur={0.7}>
          <div style={{ width: 120, height: 3, background: "var(--amber)", borderRadius: 2, margin: "30px auto 0" }}></div>
        </Anim>
        <Anim at={1.1} dur={0.7} style={{ marginTop: 30 }}>
          <div style={{ fontFamily: MONO, fontWeight: 400, fontSize: 26, letterSpacing: "0.14em", textTransform: "uppercase", color: "var(--fg-2)" }}>
            ABPIV · allanbpediniv.com
          </div>
        </Anim>
      </div>
    </Sprite>
  );
}

function MarketingFilm() {
  return (
    <Stage width={W} height={H} duration={15.2} background="#070B14" persistKey="abpiv-social">
      <BackgroundField />
      <SceneHook />
      <SceneProof />
      <SceneThesis />
      <SceneClose />
      <Chrome />
    </Stage>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<MarketingFilm />);
