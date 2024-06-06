import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-sidebar": (value) => ({
        display: "flex",
        flexWrap: "wrap",
        "& > :first-child": {
          flexBasis: theme("flexBasis.0"),
          flexGrow: theme("flexGrow.999"),
          minInlineSize: `calc(${theme("minInlineSize.full")} * ${value})`,
        },
        "& > :last-child": { flexGrow: theme("flexGrow.1") },
      }),
      "el-sidebar-after": (value) => ({
        display: "flex",
        flexWrap: "wrap",
        "& > :first-child": { flexGrow: theme("flexGrow.1") },
        "& > :last-child": {
          flexBasis: theme("flexBasis.0"),
          flexGrow: theme("flexGrow.999"),
          minInlineSize: `calc(${theme("minInlineSize.full")} * ${value})`,
        },
      }),
    },
    { values: theme("fraction") },
  );

  matchComponents(
    {
      "el-sidebar-basis": (value) => ({
        "& > :last-child": { flexBasis: value },
      }),
      "el-sidebar-after-basis": (value) => ({
        "& > :first-child": { flexBasis: value },
      }),
    },
    { values: theme("flexBasis") },
  );
});
