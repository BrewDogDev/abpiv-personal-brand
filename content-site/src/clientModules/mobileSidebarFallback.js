function getSidebarParts() {
  const nav = document.querySelector('nav.navbar');
  const toggle = document.querySelector('button.navbar__toggle');

  return {nav, toggle};
}

function isSidebarOpen() {
  const {nav, toggle} = getSidebarParts();

  return Boolean(
    nav?.classList.contains('navbar-sidebar--show') ||
      toggle?.getAttribute('aria-expanded') === 'true',
  );
}

function setSidebarOpen(open) {
  const {nav, toggle} = getSidebarParts();

  nav?.classList.toggle('navbar-sidebar--show', open);
  toggle?.setAttribute('aria-expanded', String(open));
}

function runAfterNativeHandler(callback) {
  window.setTimeout(callback, 0);
}

let removeClickListener;

function attachMobileSidebarFallback() {
  if (typeof document === 'undefined' || removeClickListener) {
    return;
  }

  const onClick = (event) => {
    const target = event.target;

    if (!(target instanceof Element)) {
      return;
    }

    const toggle = target.closest('button.navbar__toggle');

    if (toggle) {
      const wasOpen = isSidebarOpen();

      runAfterNativeHandler(() => {
        if (isSidebarOpen() === wasOpen) {
          setSidebarOpen(!wasOpen);
        }
      });

      return;
    }

    const shouldClose =
      target.closest('.navbar-sidebar__backdrop') ||
      target.closest('.navbar-sidebar__close') ||
      target.closest('.navbar-sidebar a');

    if (shouldClose) {
      runAfterNativeHandler(() => {
        if (isSidebarOpen()) {
          setSidebarOpen(false);
        }
      });
    }
  };

  document.addEventListener('click', onClick, true);

  removeClickListener = () => {
    document.removeEventListener('click', onClick, true);
    removeClickListener = undefined;
  };
}

attachMobileSidebarFallback();

export function onRouteDidUpdate() {
  attachMobileSidebarFallback();
}
