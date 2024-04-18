import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-switcher": (value) => ({
        display: "flex",
        flexWrap: "wrap",
        "& > *": {
          flexBasis: `calc((${value} - ${theme("flexBasis.full")}) * 999)`,
          flexGrow: theme("flexGrow.1"),
        },
      }),
    },
    { values: theme("flexBasis") },
  );

  matchComponents(
    {
      "el-switcher-limit": (value) => ({
        [`& > :nth-last-child(n + ${value + 1}), & > :nth-last-child(n + ${value + 1}) ~ *`]:
          { flexBasis: theme("flexBasis.full") },
      }),
    },
    { values: theme("nthChild") },
  );
});
