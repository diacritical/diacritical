import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-grid": (value) => ({
        display: "grid",
        gridTemplateColumns: `repeat(auto-fit, minmax(min(${value}, ${theme("inlineSize.full")}), 1fr))`,
      }),
    },
    { values: theme("inlineSize") },
  );
});
