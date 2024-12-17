[
  import_deps: [:ecto, :phoenix, :plug, :swoosh],
  inputs: [
    ".{boundary,credo,dialyzer,formatter}.exs",
    "{config,lib,rel,support,test}/**/*.{eex,ex,exs,heex}",
    "mix.{exs,lock}",
    "priv/**/seed.exs"
  ],
  line_length: 80,
  locals_without_parens: [assert_element: 2],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  subdirectories: ["priv/**/migration"]
]
