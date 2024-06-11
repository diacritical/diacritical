import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  const elStack = (value, combinator) => ({
    display: "flex",
    flexDirection: "column",
    justifyContent: "flex-start",
    [`&${combinator} *`]: { marginBlock: theme("margin.0") },
    [`&${combinator} * + *`]: { marginBlockStart: value },
  });

  matchComponents(
    {
      "el-stack": (value) => elStack(value, " >"),
      "el-stack-recursive": (value) => elStack(value, ""),
    },
    { supportsNegativeValues: true, values: theme("space") },
  );

  matchComponents(
    {
      "el-stack-split": (value) => ({
        "&:only-child": { blockSize: theme("blockSize.full") },
        [`& > :nth-child(${value})`]: { marginBlockEnd: theme("margin.auto") },
      }),
    },
    { values: theme("nthChild") },
  );
});
