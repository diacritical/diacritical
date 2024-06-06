import resolveConfig from "tailwindcss/resolveConfig";
import { createContext } from "tailwindcss/lib/lib/setupContextUtils";
import { resolve } from "node:path";
import { writeFileSync } from "node:fs";

export default (tailwindConfig, buildPath) => {
  const fullConfig = resolveConfig(tailwindConfig);
  const context = createContext(fullConfig);

  const extractClassList = (context) => {
    return context
      .getClassList({ includeMetadata: true })
      .flatMap((maybeClass) => {
        if (typeof maybeClass === "string") return maybeClass;
        const [className, { modifiers }] = maybeClass;

        return [
          className,
          ...modifiers.map((modifier) => `${className}/${modifier}`),
        ];
      })
      .join("\n");
  };

  const classPath = resolve(buildPath, "classes.txt");
  const classList = extractClassList(context);
  writeFileSync(classPath, classList);

  const extractVariantList = (context) => {
    return [...context.variantMap.keys()].join("\n");
  };

  const variantPath = resolve(buildPath, "variants.txt");
  const variantList = extractVariantList(context);
  writeFileSync(variantPath, variantList);
};
