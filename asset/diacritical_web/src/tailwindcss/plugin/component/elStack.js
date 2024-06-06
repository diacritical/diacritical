import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-stack": (value) => {
        value = value === "0" ? "0px" : value;

        return {
          display: "flex",
          flexDirection: "column",
          justifyContent: "flex-start",
          "& > :not([hidden])": { marginBlock: theme("margin.0") },
          "& > :not([hidden]) + :not([hidden])": { marginBlockStart: value },
        };
      },
      "el-stack-recursive": (value) => {
        value = value === "0" ? "0px" : value;

        return {
          display: "flex",
          flexDirection: "column",
          justifyContent: "flex-start",
          "& :not([hidden])": { marginBlock: theme("margin.0") },
          "& :not([hidden]) + :not([hidden])": { marginBlockStart: value },
        };
      },
    },
    { supportsNegativeValues: true, values: theme("space") },
  );

  matchComponents(
    {
      "el-stack-split": (value) => ({
        "&:only-child": { blockSize: theme("blockSize.full") },
        [`& > :nth-child(${value} of :not([hidden]))`]: {
          marginBlockEnd: theme("margin.auto"),
        },
      }),
    },
    { values: theme("nthChild") },
  );
});
