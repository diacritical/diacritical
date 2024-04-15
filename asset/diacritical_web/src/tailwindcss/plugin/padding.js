import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      plb: (value) => ({ paddingBlock: value }),
      pli: (value) => ({ paddingInline: value }),
    },
    { values: theme("padding") },
  );

  matchUtilities(
    {
      pbe: (value) => ({ paddingBlockEnd: value }),
      pbs: (value) => ({ paddingBlockStart: value }),
      pie: (value) => ({ paddingInlineEnd: value }),
      pis: (value) => ({ paddingInlineStart: value }),
    },
    { values: theme("padding") },
  );
});
