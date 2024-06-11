import plugin from "tailwindcss/plugin";

export default plugin(({ addComponents }) => {
  addComponents({ ".el-container": { containerType: "inline-size" } });
});
