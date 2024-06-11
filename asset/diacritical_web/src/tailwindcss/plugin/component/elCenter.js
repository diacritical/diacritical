import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  const elCenter = (value) => ({
    alignItems: undefined,
    boxSizing: "content-box",
    display: undefined,
    flexDirection: undefined,
    marginInline: theme("margin.auto"),
    maxInlineSize: value,
  });

  matchComponents(
    {
      "el-center": (value) => elCenter(value),
      "el-center-intrinsic": (value) => ({
        ...elCenter(value),
        alignItems: "center",
        display: "flex",
        flexDirection: "column",
      }),
    },
    { values: theme("maxInlineSize") },
  );
});
