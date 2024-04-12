import resolveConfig from "tailwindcss/resolveConfig";
import { createContext } from "tailwindcss/lib/lib/setupContextUtils";
import path from "node:path";
import { writeFileSync } from "node:fs";

export default async (tailwindConfig, buildPath) => {
  const fullConfig = await resolveConfig(tailwindConfig);
  const context = await createContext(fullConfig);

  const classList = context
    .getClassList({ includeMetadata: true })
    .flatMap((maybeClass) => {
      if (typeof maybeClass === "string") return maybeClass;
      const [className, { modifiers }] = maybeClass;
      return [className, ...modifiers.map((mod) => `${className}/${mod}`)];
    })
    .join("\n");

  writeFileSync(path.resolve(buildPath, "classes.txt"), classList);
  const variantList = [...context.variantMap.keys()].join("\n");
  writeFileSync(path.resolve(buildPath, "variants.txt"), variantList);
};
