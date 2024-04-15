import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      "border-lb": (value) => ({
        "@defaults border-width": {},
        borderBlockEndWidth: value,
        borderBlockStartWidth: value,
      }),
      "border-li": (value) => ({
        "@defaults border-width": {},
        borderInlineEndWidth: value,
        borderInlineStartWidth: value,
      }),
    },
    { values: theme("borderWidth") },
  );

  matchUtilities(
    {
      "border-be": (value) => ({
        "@defaults border-width": {},
        borderBlockEndWidth: value,
      }),
      "border-bs": (value) => ({
        "@defaults border-width": {},
        borderBlockStartWidth: value,
      }),
      "border-ie": (value) => ({
        "@defaults border-width": {},
        borderInlineEndWidth: value,
      }),
      "border-is": (value) => ({
        "@defaults border-width": {},
        borderInlineStartWidth: value,
      }),
    },
    { values: theme("borderWidth") },
  );
});
