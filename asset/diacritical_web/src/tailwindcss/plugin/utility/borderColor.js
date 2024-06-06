import plugin from "tailwindcss/plugin";
import toColorValue from "tailwindcss/lib/util/toColorValue";
import withAlphaVariable from "tailwindcss/lib/util/withAlphaVariable";
import flattenColorPalette from "tailwindcss/lib/util/flattenColorPalette";

export default plugin(({ matchUtilities, corePlugins, theme }) => {
  matchUtilities(
    {
      "border-lb": (value) => {
        if (!corePlugins("borderOpacity")) {
          return {
            borderBlockEndColor: toColorValue(value),
            borderBlockStartColor: toColorValue(value),
          };
        }

        return withAlphaVariable({
          color: value,
          property: ["border-block-end-color", "border-block-start-color"],
          variable: "--tw-border-opacity",
        });
      },
      "border-li": (value) => {
        if (!corePlugins("borderOpacity")) {
          return {
            borderInlineEndColor: toColorValue(value),
            borderInlineStartColor: toColorValue(value),
          };
        }

        return withAlphaVariable({
          color: value,
          property: ["border-inline-end-color", "border-inline-start-color"],
          variable: "--tw-border-opacity",
        });
      },
    },
    {
      values: (({ DEFAULT: _default, ...colors }) => colors)(
        flattenColorPalette(theme("borderColor")),
      ),
      type: ["color", "any"],
    },
  );

  matchUtilities(
    {
      "border-be": (value) => {
        if (!corePlugins("borderOpacity")) {
          return { borderBlockEndColor: toColorValue(value) };
        }

        return withAlphaVariable({
          color: value,
          property: "border-block-end-color",
          variable: "--tw-border-opacity",
        });
      },
      "border-bs": (value) => {
        if (!corePlugins("borderOpacity")) {
          return { borderBlockStartColor: toColorValue(value) };
        }

        return withAlphaVariable({
          color: value,
          property: "border-block-start-color",
          variable: "--tw-border-opacity",
        });
      },
      "border-ie": (value) => {
        if (!corePlugins("borderOpacity")) {
          return { borderInlineEndColor: toColorValue(value) };
        }

        return withAlphaVariable({
          color: value,
          property: "border-inline-end-color",
          variable: "--tw-border-opacity",
        });
      },
      "border-is": (value) => {
        if (!corePlugins("borderOpacity")) {
          return { borderInlineStartColor: toColorValue(value) };
        }

        return withAlphaVariable({
          color: value,
          property: "border-inline-start-color",
          variable: "--tw-border-opacity",
        });
      },
    },
    {
      values: (({ DEFAULT: _default, ...colors }) => colors)(
        flattenColorPalette(theme("borderColor")),
      ),
      type: ["color", "any"],
    },
  );
});
