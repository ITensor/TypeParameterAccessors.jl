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
    canonical="https://itensor.github.io/TypeParameterAccessors.jl",
    edit_link="main",
    assets=["assets/favicon.ico", "assets/extras.css"],
  ),
  pages=[
    "Home" => "index.md",
    "Type parameters" => "type_interface.md",
    "Library" => "lib/index.md",
  ],
  checkdocs=:exports,
)

deploydocs(;
  repo="github.com/ITensor/TypeParameterAccessors.jl", devbranch="main", push_preview=true
)
