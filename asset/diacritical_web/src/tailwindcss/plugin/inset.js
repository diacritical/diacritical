import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      "inset-block": (value) => ({ insetBlock: value }),
      "inset-inline": (value) => ({ insetInline: value }),
    },
    { supportsNegativeValues: true, values: theme("inset") },
  );

  matchUtilities(
    {
      "block-end": (value) => ({ insetBlockEnd: value }),
      "block-start": (value) => ({ insetBlockStart: value }),
      "inline-end": (value) => ({ insetInlineEnd: value }),
      "inline-start": (value) => ({ insetInlineStart: value }),
    },
    { supportsNegativeValues: true, values: theme("inset") },
  );
});
