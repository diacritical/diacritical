import plugin from "tailwindcss/plugin";

export default plugin(({ addComponents, theme }) => {
  addComponents({
    ".el-imposter": {
      insetBlockEnd: theme("inset.1/2"),
      insetBlockStart: theme("inset.1/2"),
      position: "absolute",
      transform: "translate(-50%, -50%)",
    },
  });
});
