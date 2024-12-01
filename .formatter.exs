[
  import_deps: [:plug],
  inputs: [
    ".{boundary,credo,dialyzer,formatter}.exs",
    "{config,lib,rel,support,test}/**/*.{eex,ex,exs}",
    "mix.{exs,lock}"
  ],
  line_length: 80
]
