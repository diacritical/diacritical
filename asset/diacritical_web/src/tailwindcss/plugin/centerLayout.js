import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-center": (value) => ({
        boxSizing: "content-box",
        marginInline: theme("margin.auto"),
        maxInlineSize: value,
      }),
      "el-center-intrinsic": (value) => ({
        alignItems: "center",
        boxSizing: "content-box",
        display: "flex",
        flexDirection: "column",
        marginInline: theme("margin.auto"),
        maxInlineSize: value,
      }),
    },
    { values: theme("maxInlineSize") },
  );
});
