import plugin from "tailwindcss/plugin";

export default plugin(({ addUtilities }) => {
  addUtilities({
    ".snap-block": {
      "@defaults scroll-snap-type": {},
      scrollSnapType: "block var(--tw-scroll-snap-strictness)",
    },
    ".snap-inline": {
      "@defaults scroll-snap-type": {},
      scrollSnapType: "inline var(--tw-scroll-snap-strictness)",
    },
  });
});
