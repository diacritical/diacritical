import path from "node:path";
import heroicons from "./src/tailwindcss/plugin/heroicons";
import inset from "./src/tailwindcss/plugin/inset";
import margin from "./src/tailwindcss/plugin/margin";
import blockSize from "./src/tailwindcss/plugin/blockSize";
import containerQueries from "@tailwindcss/container-queries";
import forms from "@tailwindcss/forms";
import typography from "@tailwindcss/typography";
import defaultTheme from "tailwindcss/defaultTheme";
import extractConfig from "./src/tailwindcss/util/extractConfig";

const heroiconsPath = path.join(__dirname, "../../dep/heroicons/optimized");

const tailwindConfig = {
  content: ["./js/**/*.js", "../../lib/*_web.ex", "../../lib/*_web/**/*.*ex"],
  plugins: [
    heroicons(heroiconsPath),
    inset,
    margin,
    blockSize,
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
    maxBlockSize: ({ theme }) => ({ ...theme("maxHeight") }),
    minBlockSize: ({ theme }) => ({ ...theme("minHeight") }),
  },
};

extractConfig(tailwindConfig, "../../_build");

export default tailwindConfig;
