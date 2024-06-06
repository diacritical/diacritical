import plugin from "tailwindcss/plugin";

export default plugin(({ matchUtilities, theme, addUtilities }) => {
  matchUtilities(
    {
      "divide-b": (value) => {
        value = value === "0" ? "0px" : value;

        return {
          "& > :not([hidden]) ~ :not([hidden])": {
            "@defaults border-width": {},
            "--tw-divide-b-reverse": "0",
            borderBlockEndWidth: `calc(${value} * var(--tw-divide-b-reverse))`,
            borderBlockStartWidth: `calc(${value} * calc(1 - var(--tw-divide-b-reverse)))`,
          },
        };
      },
      "divide-i": (value) => {
        value = value === "0" ? "0px" : value;

        return {
          "& > :not([hidden]) ~ :not([hidden])": {
            "@defaults border-width": {},
            "--tw-divide-i-reverse": "0",
            borderInlineEndWidth: `calc(${value} * var(--tw-divide-i-reverse))`,
            borderInlineStartWidth: `calc(${value} * calc(1 - var(--tw-divide-i-reverse)))`,
          },
        };
      },
    },
    { type: ["line-width", "length", "any"], values: theme("divideWidth") },
  );

  addUtilities({
    ".divide-b-reverse > :not([hidden]) ~ :not([hidden])": {
      "--tw-divide-b-reverse": "1",
    },
    ".divide-i-reverse > :not([hidden]) ~ :not([hidden])": {
      "--tw-divide-i-reverse": "1",
    },
  });
});
