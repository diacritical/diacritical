import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-cluster": (value) => ({
        alignItems: "center",
        display: "flex",
        flexWrap: "wrap",
        gap: value,
        justifyContent: "flex-start",
      }),
    },
    { values: theme("gap") },
  );
});
