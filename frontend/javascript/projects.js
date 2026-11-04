// The card deal runs site-wide: any .deal element (project cards, post cards)
// slides up from below the fold as it scrolls into view. The tag filters below
// only exist on /projects.
document.documentElement.classList.add("js");

document.addEventListener("DOMContentLoaded", () => {
  // ---- the deal: cards slide up from below the fold, one after another. Only cards that scroll into
  // view are dealt, in batches, so a long list never makes you wait for the whole deck.
  let batch = 0, timer = null;
  const io = "IntersectionObserver" in window && !matchMedia("(prefers-reduced-motion: reduce)").matches
    ? new IntersectionObserver(entries => {
        entries.filter(e => e.isIntersecting && !e.target.classList.contains("dealt")).forEach(e => {
          const el = e.target;
          el.style.setProperty("--d", `${batch * 70}ms`);
          el.style.setProperty("--r", `${(Math.random() * 14 - 7).toFixed(1)}deg`);
          el.style.setProperty("--fx", `${Math.round(Math.random() * 120 - 60)}px`);
          el.classList.add("dealt");
          batch = Math.min(batch + 1, 14);
          io.unobserve(el);
        });
        clearTimeout(timer); timer = setTimeout(() => { batch = 0; }, 400);
      }, { rootMargin: "0px 0px -8% 0px", threshold: 0.05 })
    : null;
  const deal = root => {
    const els = [...root.querySelectorAll(".deal:not(.dealt)")];
    if (io) els.forEach(c => io.observe(c)); else els.forEach(c => c.classList.add("dealt"));
  };
  deal(document);

  // ---- /projects filters (toggle pills, AND across the selection)
  const grid = document.getElementById("pgrid");
  if (!grid) return;
  const cards = [...grid.querySelectorAll(".pcard")];
  const links = [...document.querySelectorAll(".tag-link[data-tag]")];
  const clear = document.getElementById("filter-clear");
  const count = document.getElementById("filter-count");
  const tagsOf = new Map(cards.map(c => [c, JSON.parse(c.dataset.tags || "[]")]));

  const active = () => links.filter(l => l.classList.contains("active")).map(l => l.dataset.tag);
  function apply() {
    const want = active();
    let shown = 0;
    cards.forEach(c => {
      const t = tagsOf.get(c);
      const ok = want.every(w => t.includes(w));
      c.hidden = !ok;
      if (ok) shown++;
    });
    clear.hidden = want.length === 0;
    count.textContent = `${shown} of ${cards.length} projects`;
    links.forEach(l => l.setAttribute("aria-pressed", l.classList.contains("active")));
    document.querySelectorAll(".pfilter").forEach(d => {
      const n = d.querySelectorAll(".tag-link.active").length;
      const badge = d.querySelector(".pf-n");
      badge.textContent = n ? `${n} active` : d.querySelectorAll(".tag-link").length;
    });
    // Re-observe so newly revealed cards still get dealt.
    deal(grid);
  }
  links.forEach(l => l.addEventListener("click", () => { l.classList.toggle("active"); apply(); }));
  clear.addEventListener("click", () => { links.forEach(l => l.classList.remove("active")); apply(); });
});
