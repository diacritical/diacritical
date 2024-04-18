import plugin from "tailwindcss/plugin";

export default plugin(({ matchComponents, theme }) => {
  matchComponents(
    {
      "el-frame": (value) => ({
        alignItems: "center",
        aspectRatio: value,
        display: "flex",
        justifyContent: "center",
        overflow: "hidden",
        "& > img, & > video": {
          blockSize: theme("blockSize.full"),
          inlineSize: theme("inlineSize.full"),
          objectFit: "cover",
        },
      }),
    },
    { values: theme("aspectRatio") },
  );
});
