import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      "scroll-mlb": (value) => ({ scrollMarginBlock: value }),
      "scroll-mli": (value) => ({ scrollMarginInline: value }),
    },
    { supportsNegativeValues: true, values: theme("scrollMargin") },
  );

  matchUtilities(
    {
      "scroll-mbe": (value) => ({ scrollMarginBlockEnd: value }),
      "scroll-mbs": (value) => ({ scrollMarginBlockStart: value }),
      "scroll-mie": (value) => ({ scrollMarginInlineEnd: value }),
      "scroll-mis": (value) => ({ scrollMarginInlineStart: value }),
    },
    { supportsNegativeValues: true, values: theme("scrollMargin") },
  );
});
