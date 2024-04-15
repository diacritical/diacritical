import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme }) => {
  matchUtilities(
    { bs: (value) => ({ blockSize: value }) },
    { values: theme("blockSize") },
  );

  matchUtilities(
    { "max-bs": (value) => ({ maxBlockSize: value }) },
    { values: theme("maxBlockSize") },
  );

  matchUtilities(
    { "min-bs": (value) => ({ minBlockSize: value }) },
    { values: theme("minBlockSize") },
  );
});
