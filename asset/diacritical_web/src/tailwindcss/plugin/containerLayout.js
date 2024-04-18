import plugin from "tailwindcss/plugin";

export default plugin(({ addComponents, theme }) => {
  addComponents({ ".el-container": { containerType: "inline-size" } });
});
