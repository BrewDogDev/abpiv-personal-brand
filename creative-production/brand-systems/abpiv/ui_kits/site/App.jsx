// ui_kits/site — App
const { useState: useStateApp } = React;

function App() {
  const [active, setActive] = useStateApp("Insights");
  const goWork = (tab) => {
    setActive(tab);
    const el = document.getElementById("work");
    if (el) window.scrollTo({ top: el.offsetTop - 64, behavior: "smooth" });
  };
  return (
    <>
      <Nav active={active} onNav={goWork} />
      <Hero />
      <Thesis />
      <Work active={active} onTab={setActive} />
      <SubscribeBand />
      <Footer onNav={goWork} />
    </>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
