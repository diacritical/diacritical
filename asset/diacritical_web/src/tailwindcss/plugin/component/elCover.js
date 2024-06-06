import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-cover": (value) => ({
        display: "flex",
        flexDirection: "column",
        minBlockSize: theme("minBlockSize.dvb"),
        padding: theme("padding.4"),
        "& > *": { marginBlock: theme("margin.4") },
        [`& > :first-child:not(${value})`]: {
          marginBlockStart: theme("margin.0"),
        },
        [`& > :last-child:not(${value})`]: {
          marginBlockEnd: theme("margin.0"),
        },
        [`& > ${value}`]: { marginBlock: theme("margin.auto") },
      }),
    },
    { values: theme("tag") },
  );

  matchComponents(
    { "el-cover-mlb": (value) => ({ "& > *": { marginBlock: value } }) },
    { values: theme("margin") },
  );
});
