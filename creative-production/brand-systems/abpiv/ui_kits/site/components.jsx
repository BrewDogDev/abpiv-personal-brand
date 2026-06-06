// ui_kits/site — components
const { useState } = React;
const D = window.ABPIV_DATA;

function Chip({ children, amber }) {
  return <span className={"chip" + (amber ? " amber" : "")}><span className="dot"></span>{children}</span>;
}

function Nav({ active, onNav }) {
  return (
    <div className="nav">
      <div className="wrap nav-inner">
        <a className="brand" href="#top">{D.brand.name}</a>
        <div className="nav-links">
          {D.nav.map((n) => (
            <a key={n} className={"nav-link" + (active === n ? " active" : "")} href="#"
               onClick={(e) => { e.preventDefault(); onNav(n); }}>{n}</a>
          ))}
          <a className="nav-cta" href="#start" onClick={(e) => { e.preventDefault(); onNav("Featured On"); }}>Start here</a>
        </div>
      </div>
    </div>
  );
}

function HeroRoutes() {
  // thin cyan route lines that draw in, resolving to a single amber node
  return (
    <svg className="hero-routes" viewBox="0 0 1080 560" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
      <g fill="none" stroke="var(--cyan-line)" strokeWidth="1" opacity="0.45">
        <path className="rt" d="M-20 120 H320 Q470 120 470 240 H760" />
        <path className="rt rt2" d="M-20 300 H760" />
        <path className="rt rt3" d="M-20 470 H320 Q470 470 470 240 H760" />
      </g>
      <circle cx="760" cy="240" r="4.5" fill="var(--amber)">
        <animate attributeName="opacity" values="1;0.45;1" dur="2.6s" begin="1.6s" repeatCount="indefinite" />
      </circle>
      <circle cx="-20" cy="120" r="3" fill="var(--cyan)" />
      <circle cx="-20" cy="300" r="3" fill="var(--cyan)" />
      <circle cx="-20" cy="470" r="3" fill="var(--cyan)" />
    </svg>
  );
}

function Hero() {
  return (
    <header className="hero" id="top">
      <HeroRoutes />
      <div className="wrap hero-grid">
        <div>
          <span className="eyebrow">{D.hero.eyebrow}</span>
          <h1>{D.hero.h1a}<span className="accent">{D.hero.h1accent}</span></h1>
          <p className="lede">{D.hero.lede}</p>
          <div className="hero-cta">
            <a className="btn btn-primary" href="#work">Read insights <span className="arr">→</span></a>
            <a className="btn btn-ghost" href="#work">Explore the work</a>
          </div>
          <div className="proof-row">
            {D.hero.proof.map((p, i) => <Chip key={p} amber={i === 1}>{p}</Chip>)}
          </div>
        </div>
        <div className="portrait">
          <img src="../../assets/headshot.png" alt="Allan B. Pedin IV" />
          <div className="portrait-cap">
            <div className="nm">Allan B. Pedin IV</div>
            <div className="rl">Founder · Researcher</div>
          </div>
        </div>
      </div>
    </header>
  );
}

function Thesis() {
  return (
    <section className="section" id="thesis">
      <div className="wrap">
        <div className="section-head">
          <div>
            <span className="eyebrow">{D.thesis.eyebrow}</span>
            <h2>A new age of technology<br />should expand what people can do.</h2>
          </div>
        </div>
        <div className="thesis">
          {D.thesis.pillars.map((p) => (
            <div className="pillar" key={p.n}>
              <span className="n">{p.n}</span>
              <h3>{p.t}</h3>
              <p>{p.p}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

function Work({ active, onTab }) {
  const items = D.work[active];
  return (
    <section className="section" id="work">
      <div className="wrap">
        <div className="section-head">
          <div>
            <span className="eyebrow">Explore the work</span>
            <h2>Recent work by section</h2>
            <p className="lede">{D.workIntro[active]}</p>
          </div>
          <a className="btn btn-ghost" href="#">View all <span className="arr">→</span></a>
        </div>
        <div className="tabs">
          {D.nav.map((n) => (
            <button key={n} className={"tab" + (active === n ? " active" : "")} onClick={() => onTab(n)}>{n}</button>
          ))}
        </div>
        <div className="cards">
          {items.map((c, i) => (
            <article className="card" key={i}>
              <span className="meta">{c.meta}</span>
              <h4>{c.t}</h4>
              <p>{c.p}</p>
              <span className="more">Explore <span className="arr">→</span></span>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}

function SubscribeBand() {
  const [val, setVal] = useState("");
  const [done, setDone] = useState(false);
  return (
    <section className="band" id="start">
      <div className="wrap band-inner">
        <h3>Insight, vision, and execution — delivered as Allan publishes.</h3>
        <div>
          {done ? (
            <Chip>Subscribed — thank you</Chip>
          ) : (
            <form className="field" onSubmit={(e) => { e.preventDefault(); if (val.includes("@")) setDone(true); }}>
              <input type="email" placeholder="you@email.com" value={val} onChange={(e) => setVal(e.target.value)} />
              <button className="btn btn-primary" type="submit">Subscribe</button>
            </form>
          )}
        </div>
      </div>
    </section>
  );
}

function Footer({ onNav }) {
  return (
    <footer className="footer">
      <div className="wrap">
        <div className="footer-top">
          <div>
            <div className="brand-lg">Allan B. Pedin <span style={{ color: "var(--cyan)" }}>IV</span></div>
            <p className="tag">Build, explain, earn trust.</p>
          </div>
          <div className="footer-cols">
            {D.footer.cols.map((col) => (
              <div className="footer-col" key={col.h}>
                <h5>{col.h}</h5>
                {col.links.map((l) => (
                  <a key={l} href="#" onClick={(e) => { e.preventDefault(); if (D.nav.includes(l)) onNav(l); }}>{l}</a>
                ))}
              </div>
            ))}
          </div>
        </div>
        <div className="footer-bottom">
          <span>{D.footer.copyright}</span>
          <span>allanbpediniv.com</span>
        </div>
      </div>
    </footer>
  );
}

Object.assign(window, { Nav, Hero, Thesis, Work, SubscribeBand, Footer, Chip });
