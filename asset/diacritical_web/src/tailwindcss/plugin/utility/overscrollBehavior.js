import plugin from "tailwindcss/plugin";

export default plugin(({ addUtilities }) => {
  addUtilities({
    ".overscroll-block-auto": { overscrollBehaviorBlock: "auto" },
    ".overscroll-block-contain": { overscrollBehaviorBlock: "contain" },
    ".overscroll-block-none": { overscrollBehaviorBlock: "none" },
    ".overscroll-inline-auto": { overscrollBehaviorInline: "auto" },
    ".overscroll-inline-contain": { overscrollBehaviorInline: "contain" },
    ".overscroll-inline-none": { overscrollBehaviorInline: "none" },
  });
});
