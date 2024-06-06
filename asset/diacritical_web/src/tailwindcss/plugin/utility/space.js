import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme, addUtilities }) => {
  matchUtilities(
    {
      "space-b": (value) => {
        value = value === "0" ? "0px" : value;

        return {
          "& > :not([hidden]) ~ :not([hidden])": {
            "--tw-space-b-reverse": "0",
            marginBlockEnd: `calc(${value} * var(--tw-space-b-reverse))`,
            marginBlockStart: `calc(${value} * calc(1 - var(--tw-space-b-reverse)))`,
          },
        };
      },
      "space-i": (value) => {
        value = value === "0" ? "0px" : value;

        return {
          "& > :not([hidden]) ~ :not([hidden])": {
            "--tw-space-i-reverse": "0",
            marginInlineEnd: `calc(${value} * var(--tw-space-i-reverse))`,
            marginInlineStart: `calc(${value} * calc(1 - var(--tw-space-i-reverse)))`,
          },
        };
      },
    },
    { supportsNegativeValues: true, values: theme("space") },
  );

  addUtilities({
    ".space-b-reverse > :not([hidden]) ~ :not([hidden])": {
      "--tw-space-b-reverse": "1",
    },
    ".space-i-reverse > :not([hidden]) ~ :not([hidden])": {
      "--tw-space-i-reverse": "1",
    },
  });
});
