import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      mlb: (value) => ({ marginBlock: value }),
      mli: (value) => ({ marginInline: value }),
    },
    { supportsNegativeValues: true, values: theme("margin") },
  );

  matchUtilities(
    {
      mbe: (value) => ({ marginBlockEnd: value }),
      mbs: (value) => ({ marginBlockStart: value }),
      mie: (value) => ({ marginInlineEnd: value }),
      mis: (value) => ({ marginInlineStart: value }),
    },
    { supportsNegativeValues: true, values: theme("margin") },
  );
});
