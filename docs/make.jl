using TypeParameterAccessors: TypeParameterAccessors
using Documenter: Documenter, DocMeta, deploydocs, makedocs

DocMeta.setdocmeta!(
  TypeParameterAccessors, :DocTestSetup, :(using TypeParameterAccessors); recursive=true
)

include("make_index.jl")

makedocs(;
  modules=[TypeParameterAccessors],
  authors="ITensor developers <support@itensor.org> and contributors",
  sitename="TypeParameterAccessors.jl",
  format=Documenter.HTML(;
    canonical="https://ITensor.github.io/TypeParameterAccessors.jl",
    edit_link="main",
    assets=String[],
  ),
  pages=["Home" => "index.md"],
  # TODO: Define missing docs and delete this.
  warnonly=[:missing_docs],
)

deploydocs(;
  repo="github.com/ITensor/TypeParameterAccessors.jl", devbranch="main", push_preview=true
)
