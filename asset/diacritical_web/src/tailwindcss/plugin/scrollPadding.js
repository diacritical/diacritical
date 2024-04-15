import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      "scroll-plb": (value) => ({ scrollPaddingBlock: value }),
      "scroll-pli": (value) => ({ scrollPaddingInline: value }),
    },
    { values: theme("scrollPadding") },
  );

  matchUtilities(
    {
      "scroll-pbe": (value) => ({ scrollPaddingBlockEnd: value }),
      "scroll-pbs": (value) => ({ scrollPaddingBlockStart: value }),
      "scroll-pie": (value) => ({ scrollPaddingInlineEnd: value }),
      "scroll-pis": (value) => ({ scrollPaddingInlineStart: value }),
    },
    { values: theme("scrollPadding") },
  );
});
