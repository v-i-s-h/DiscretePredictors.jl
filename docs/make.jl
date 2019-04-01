using Documenter, DiscretePredictors

makedocs(
    modules = [DiscretePredictors],
    doctest = true,
    format = Documenter.HTML(prettyurls=!("local" in ARGS)),
    sitename = "DiscretePredictors.jl",
    authors = "Vishnu Raj",
    linkcheck = false,
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
            "Guide" => "man/guide.md",
            "man/examples.md",
            # "man/contributing.md",
        ],
        "Library" => Any[
            "High Level Interface" => "lib/interface.md",
            "Predictors" => "lib/predictors.md"
        ]
    ],
    # Use clean URLs, unless built as a "local" build
    # html_prettyurls = !("local" in ARGS),
)

deploydocs(
    repo    = "github.com/v-i-s-h/DiscretePredictors.jl.git",
    target  = "build",
    # julia   = "0.6",
    # osname  = 'linux',
    deps    = nothing,
    make    = nothing,
)
