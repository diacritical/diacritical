import path from "node:path";
import stackLayout from "./src/tailwindcss/plugin/stackLayout";
import boxLayout from "./src/tailwindcss/plugin/boxLayout";
import centerLayout from "./src/tailwindcss/plugin/centerLayout";
import heroicons from "./src/tailwindcss/plugin/heroicons";
import inset from "./src/tailwindcss/plugin/inset";
import margin from "./src/tailwindcss/plugin/margin";
import blockSize from "./src/tailwindcss/plugin/blockSize";
import inlineSize from "./src/tailwindcss/plugin/inlineSize";
import captionSide from "./src/tailwindcss/plugin/captionSide";
import resize from "./src/tailwindcss/plugin/resize";
import scrollSnapType from "./src/tailwindcss/plugin/scrollSnapType";
import scrollMargin from "./src/tailwindcss/plugin/scrollMargin";
import scrollPadding from "./src/tailwindcss/plugin/scrollPadding";
import gap from "./src/tailwindcss/plugin/gap";
import space from "./src/tailwindcss/plugin/space";
import divideWidth from "./src/tailwindcss/plugin/divideWidth";
import overflow from "./src/tailwindcss/plugin/overflow";
import overscrollBehavior from "./src/tailwindcss/plugin/overscrollBehavior";
import borderRadius from "./src/tailwindcss/plugin/borderRadius";
import borderWidth from "./src/tailwindcss/plugin/borderWidth";
import borderColor from "./src/tailwindcss/plugin/borderColor";
import padding from "./src/tailwindcss/plugin/padding";
import containerQueries from "@tailwindcss/container-queries";
import forms from "@tailwindcss/forms";
import typography from "@tailwindcss/typography";
import defaultTheme from "tailwindcss/defaultTheme";
import extractConfig from "./src/tailwindcss/util/extractConfig";

const heroiconsPath = path.join(__dirname, "../../dep/heroicons/optimized");

const tailwindConfig = {
  content: ["./js/**/*.js", "../../lib/*_web.ex", "../../lib/*_web/**/*.*ex"],
  plugins: [
    stackLayout,
    boxLayout,
    centerLayout,
    heroicons(heroiconsPath),
    inset,
    margin,
    blockSize,
    inlineSize,
    captionSide,
    resize,
    scrollSnapType,
    scrollMargin,
    scrollPadding,
    gap,
    space,
    divideWidth,
    overflow,
    overscrollBehavior,
    borderRadius,
    borderWidth,
    borderColor,
    padding,
    containerQueries,
    forms,
    typography,
  ],
  theme: {
    blockSize: ({ theme }) => ({ ...theme("height") }),
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
    inlineSize: ({ theme }) => ({ ...theme("width") }),
    maxBlockSize: ({ theme }) => ({ ...theme("maxHeight") }),
    maxInlineSize: ({ theme }) => ({ ...theme("maxWidth") }),
    minBlockSize: ({ theme }) => ({ ...theme("minHeight") }),
    minInlineSize: ({ theme }) => ({ ...theme("minWidth") }),
    nthChild: {
      1: 1,
      2: 2,
      3: 3,
      4: 4,
      5: 5,
      6: 6,
      7: 7,
      8: 8,
      9: 9,
      10: 10,
      11: 11,
      12: 12,
    },
  },
};

extractConfig(tailwindConfig, "../../_build");

export default tailwindConfig;
