const plugin = require("tailwindcss/plugin");
const path = require("path");
const fs = require("fs");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./js/**/*.js", "../../lib/*_web.ex", "../../lib/*_web/**/*.*ex"],
  plugins: [
    require("@tailwindcss/container-queries"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    plugin(function ({ matchComponents, theme }) {
      let icons = [
        ["", "/24/outline"],
        ["-micro", "/16/solid"],
        ["-mini", "/20/solid"],
        ["-solid", "/24/solid"],
      ];
      let iconsDir = path.join(__dirname, "../../dep/heroicons/optimized");
      let values = {};
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, ".svg") + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "");
            let size = theme("spacing.6");
            if (name.endsWith("-mini")) {
              size = theme("spacing.5");
            } else if (name.endsWith("-micro")) {
              size = theme("spacing.4");
            }
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "background-color": "currentColor",
              "block-size": size,
              display: "inline-block",
              "inline-size": size,
              "mask-image": `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "vertical-align": "middle",
            };
          },
        },
        { values },
      );
    }),
  ],
  theme: {
    extend: {
      fontFamily: {
        display: [
          "Inter Variable",
          "Inter Display",
          ...defaultTheme.fontFamily.sans,
        ],
        sans: ["Inter Variable", "Inter", ...defaultTheme.fontFamily.sans],
      },
    },
  },
};
