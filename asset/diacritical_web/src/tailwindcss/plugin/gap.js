import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      "gap-col": (value) => ({ columnGap: value }),
      "gap-row": (value) => ({ rowGap: value }),
    },
    { values: theme("gap") },
  );
});
