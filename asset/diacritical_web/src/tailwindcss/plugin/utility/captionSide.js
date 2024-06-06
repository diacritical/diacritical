import plugin from "tailwindcss/plugin";

export default plugin(({ addUtilities }) => {
  addUtilities({
    ".caption-block-end": { captionSide: "block-end" },
    ".caption-block-start": { captionSide: "block-start" },
    ".caption-inline-end": { captionSide: "inline-end" },
    ".caption-inline-start": { captionSide: "inline-start" },
  });
});
