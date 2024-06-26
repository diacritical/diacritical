import plugin from "tailwindcss/plugin";

export default plugin(({ addComponents }) => {
  addComponents({
    ".el-icon": {
      blockSize: ["0.75em", "1cap"],
      inlineSize: ["0.75em", "1cap"],
    },
  });
});
