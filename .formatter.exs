[
  import_deps: [:phoenix, :plug],
  inputs: [
    ".{boundary,credo,dialyzer,formatter}.exs",
    "{config,lib,rel,support,test}/**/*.{eex,ex,exs,heex}",
    "mix.{exs,lock}"
  ],
  line_length: 80,
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
