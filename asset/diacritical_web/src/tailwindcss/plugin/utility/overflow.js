import plugin from "tailwindcss/plugin";

export default plugin(({ addUtilities }) => {
  addUtilities({
    ".overflow-block-auto": { overflowBlock: "auto" },
    ".overflow-block-clip": { overflowBlock: "clip" },
    ".overflow-block-hidden": { overflowBlock: "hidden" },
    ".overflow-block-scroll": { overflowBlock: "scroll" },
    ".overflow-block-visible": { overflowBlock: "visible" },
    ".overflow-inline-auto": { overflowInline: "auto" },
    ".overflow-inline-clip": { overflowInline: "clip" },
    ".overflow-inline-hidden": { overflowInline: "hidden" },
    ".overflow-inline-scroll": { overflowInline: "scroll" },
    ".overflow-inline-visible": { overflowInline: "visible" },
  });
});
