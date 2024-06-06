import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    {
      "rounded-be": (value) => ({
        borderEndEndRadius: value,
        borderEndStartRadius: value,
      }),
      "rounded-bs": (value) => ({
        borderStartEndRadius: value,
        borderStartStartRadius: value,
      }),
      "rounded-ie": (value) => ({
        borderEndEndRadius: value,
        borderStartEndRadius: value,
      }),
      "rounded-is": (value) => ({
        borderEndStartRadius: value,
        borderStartStartRadius: value,
      }),
    },
    { values: theme("borderRadius") },
  );

  matchUtilities(
    {
      "rounded-ee": (value) => ({ borderEndEndRadius: value }),
      "rounded-es": (value) => ({ borderEndStartRadius: value }),
      "rounded-se": (value) => ({ borderStartEndRadius: value }),
      "rounded-ss": (value) => ({ borderStartStartRadius: value }),
    },
    { values: theme("borderRadius") },
  );
});
