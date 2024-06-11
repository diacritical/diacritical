import plugin from "tailwindcss/plugin";

export default plugin(({ addComponents, theme }) => {
  const elImposter = {
    insetBlockStart: theme("inset.1/2"),
    insetInlineStart: theme("inset.1/2"),
    position: undefined,
    transform: "translate(-50%, -50%)",
  };

  addComponents({
    ".el-imposter": { ...elImposter, position: "absolute" },
    ".el-imposter-fixed": { ...elImposter, position: "fixed" },
  });
});
