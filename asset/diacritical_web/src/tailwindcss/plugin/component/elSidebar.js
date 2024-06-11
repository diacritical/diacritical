import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  const elSidebar = (value, sidebar) => ({
    display: "flex",
    flexWrap: "wrap",
    [`& > ${sidebar === "before" ? ":first-child" : ":last-child"}`]: {
      flexGrow: theme("flexGrow.DEFAULT"),
    },
    [`& > ${sidebar === "before" ? ":last-child" : ":first-child"}`]: {
      flexBasis: theme("flexBasis.0"),
      flexGrow: theme("flexGrow.999"),
      minInlineSize: `calc(${theme("minInlineSize.full")} * ${value})`,
    },
  });

  matchComponents(
    {
      "el-sidebar": (value) => elSidebar(value, "before"),
      "el-sidebar-after": (value) => elSidebar(value, "after"),
    },
    { values: theme("fraction") },
  );

  const elSidebarBasis = (value, sidebar) => ({
    [`& > ${sidebar === "before" ? ":first-child" : ":last-child"}`]: {
      flexBasis: value,
    },
  });

  matchComponents(
    {
      "el-sidebar-basis": (value) => elSidebarBasis(value, "before"),
      "el-sidebar-after-basis": (value) => elSidebarBasis(value, "after"),
    },
    { values: theme("flexBasis") },
  );
});
