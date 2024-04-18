import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-box": (value) => ({
        borderWidth: theme("borderWidth.DEFAULT"),
        padding: value,
      }),
    },
    { values: theme("padding") },
  );
});
