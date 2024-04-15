import plugin from "tailwindcss/plugin";

export default plugin(({ addUtilities }) => {
  addUtilities({
    ".resize-block": { resize: "block" },
    ".resize-inline": { resize: "inline" },
  });
});
