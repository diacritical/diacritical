import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    { is: (value) => ({ inlineSize: value }) },
    { values: theme("inlineSize") },
  );

  matchUtilities(
    { "max-is": (value) => ({ maxInlineSize: value }) },
    { values: theme("maxInlineSize") },
  );

  matchUtilities(
    { "min-is": (value) => ({ minInlineSize: value }) },
    { values: theme("minInlineSize") },
  );
});
