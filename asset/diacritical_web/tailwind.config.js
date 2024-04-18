import path from "node:path";
import stackLayout from "./src/tailwindcss/plugin/stackLayout";
import boxLayout from "./src/tailwindcss/plugin/boxLayout";
import centerLayout from "./src/tailwindcss/plugin/centerLayout";
import clusterLayout from "./src/tailwindcss/plugin/clusterLayout";
import sidebarLayout from "./src/tailwindcss/plugin/sidebarLayout";
import switcherLayout from "./src/tailwindcss/plugin/switcherLayout";
import coverLayout from "./src/tailwindcss/plugin/coverLayout";
import gridLayout from "./src/tailwindcss/plugin/gridLayout";
import frameLayout from "./src/tailwindcss/plugin/frameLayout";
import reelLayout from "./src/tailwindcss/plugin/reelLayout";
import imposterLayout from "./src/tailwindcss/plugin/imposterLayout";
import containerLayout from "./src/tailwindcss/plugin/containerLayout";
import iconLayout from "./src/tailwindcss/plugin/iconLayout";
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
    clusterLayout,
    sidebarLayout,
    switcherLayout,
    coverLayout,
    gridLayout,
    frameLayout,
    reelLayout,
    imposterLayout,
    iconLayout,
    containerLayout,
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
      flexGrow: { 999: 999 },
      fontFamily: {
        display: [
          "Inter Variable",
          "Inter Display",
          ...defaultTheme.fontFamily.sans,
        ],
        sans: ["Inter Variable", "Inter", ...defaultTheme.fontFamily.sans],
      },
      height: { dvb: "100dvb" },
      maxHeight: { dvb: "100dvb" },
      minHeight: { dvb: "100dvb" },
    },
    fraction: {
      "1/2": "1 / 2",
      "1/3": "1 / 3",
      "2/3": "2 / 3",
      "1/4": "1 / 4",
      "2/4": "1 / 2",
      "3/4": "3 / 4",
      "1/6": "1 / 6",
      "2/6": "1 / 3",
      "3/6": "1 / 2",
      "4/6": "2 / 3",
      "5/6": "5 / 6",
      "1/12": "1 / 12",
      "2/12": "1 / 6",
      "3/12": "1 / 4",
      "4/12": "1 / 3",
      "5/12": "5 / 12",
      "6/12": "1 / 2",
      "7/12": "7 / 12",
      "8/12": "2 / 3",
      "9/12": "3 / 4",
      "10/12": "5 / 6",
      "11/12": "11 / 12",
      full: 1,
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
