import plugin from "tailwindcss/plugin";
import path from "node:path";
import { readdirSync, readFileSync } from "node:fs";

export default (heroiconsPath) =>
  plugin(({ matchComponents, theme }) => {
    const icons = [
      ["", "24/outline"],
      ["-micro", "16/solid"],
      ["-mini", "20/solid"],
      ["-solid", "24/solid"],
    ];

    const values = {};

    for (const [suffix, setPath] of icons) {
      for (const file of readdirSync(path.join(heroiconsPath, setPath))) {
        const name = path.basename(file, ".svg") + suffix;

        values[name] = {
          fullPath: path.join(heroiconsPath, setPath, file),
          name,
        };
      }
    }

    matchComponents(
      {
        hero: ({ fullPath, name }) => {
          const content = readFileSync(fullPath)
            .toString()
            .replace(/\r?\n|\r/g, "");

          const size = (() => {
            if (name.endsWith("-micro")) return theme("spacing.4");
            else if (name.endsWith("-mini")) return theme("spacing.5");
            else return theme("spacing.6");
          })();

          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            backgroundColor: "currentColor",
            blockSize: size,
            display: "inline-block",
            inlineSize: size,
            maskImage: `var(--hero-${name})`,
            maskRepeat: "no-repeat",
            verticalAlign: "middle",
          };
        },
      },
      { values },
    );
  });
