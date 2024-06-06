import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-reel": (value) => ({
        blockSize: theme("blockSize.auto"),
        display: "flex",
        overflowX: "auto",
        overflowY: "hidden",
        "& > *": { flex: theme("flex.none") },
        "& > img": {
          blockSize: theme("blockSize.full"),
          flexBasis: theme("flexBasis.auto"),
          inlineSize: theme("inlineSize.auto"),
        },
        "& > :not([hidden]) + :not([hidden])": { marginInlineStart: value },
      }),
    },
    { values: theme("space") },
  );

  matchComponents(
    { "el-reel-basis": (value) => ({ "& > *": { flexBasis: value } }) },
    { values: theme("flexBasis") },
  );
});
