import path from "node:path";

import elStack from "./src/tailwindcss/plugin/component/elStack";
import elBox from "./src/tailwindcss/plugin/component/elBox";
import elCenter from "./src/tailwindcss/plugin/component/elCenter";
import elCluster from "./src/tailwindcss/plugin/component/elCluster";
import elSidebar from "./src/tailwindcss/plugin/component/elSidebar";
import elSwitcher from "./src/tailwindcss/plugin/component/elSwitcher";
import elCover from "./src/tailwindcss/plugin/component/elCover";
import elGrid from "./src/tailwindcss/plugin/component/elGrid";
import elFrame from "./src/tailwindcss/plugin/component/elFrame";
import elReel from "./src/tailwindcss/plugin/component/elReel";
import elImposter from "./src/tailwindcss/plugin/component/elImposter";
import elIcon from "./src/tailwindcss/plugin/component/elIcon";
import elContainer from "./src/tailwindcss/plugin/component/elContainer";
import heroicons from "./src/tailwindcss/plugin/component/heroicons";

import inset from "./src/tailwindcss/plugin/utility/inset";
import margin from "./src/tailwindcss/plugin/utility/margin";
import blockSize from "./src/tailwindcss/plugin/utility/blockSize";
import inlineSize from "./src/tailwindcss/plugin/utility/inlineSize";
import captionSide from "./src/tailwindcss/plugin/utility/captionSide";
import resize from "./src/tailwindcss/plugin/utility/resize";
import scrollSnapType from "./src/tailwindcss/plugin/utility/scrollSnapType";
import scrollMargin from "./src/tailwindcss/plugin/utility/scrollMargin";
import scrollPadding from "./src/tailwindcss/plugin/utility/scrollPadding";
import gap from "./src/tailwindcss/plugin/utility/gap";
import space from "./src/tailwindcss/plugin/utility/space";
import divideWidth from "./src/tailwindcss/plugin/utility/divideWidth";
import overflow from "./src/tailwindcss/plugin/utility/overflow";
import overscrollBehavior from "./src/tailwindcss/plugin/utility/overscrollBehavior";
import borderRadius from "./src/tailwindcss/plugin/utility/borderRadius";
import borderWidth from "./src/tailwindcss/plugin/utility/borderWidth";
import borderColor from "./src/tailwindcss/plugin/utility/borderColor";
import padding from "./src/tailwindcss/plugin/utility/padding";

import containerQueries from "@tailwindcss/container-queries";
import forms from "@tailwindcss/forms";
import typography from "@tailwindcss/typography";

import defaultTheme from "tailwindcss/defaultTheme";
import extractConfig from "./src/tailwindcss/utility/extractConfig";

const heroiconsPath = path.join(__dirname, "../../dep/heroicons/optimized");

const tailwindConfig = {
  content: ["./js/**/*.js", "../../lib/*_web.ex", "../../lib/*_web/**/*.*ex"],
  plugins: [
    elStack,
    elBox,
    elCenter,
    elCluster,
    elSidebar,
    elSwitcher,
    elCover,
    elGrid,
    elFrame,
    elReel,
    elImposter,
    elIcon,
    elContainer,
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
