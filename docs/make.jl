using TypeParameterAccessors
using Documenter

DocMeta.setdocmeta!(
  TypeParameterAccessors, :DocTestSetup, :(using TypeParameterAccessors); recursive=true
)

makedocs(;
  modules=[TypeParameterAccessors],
  authors="ITensor developers",
  sitename="TypeParameterAccessors.jl",
  format=Documenter.HTML(;
    canonical="https://ITensor.github.io/TypeParameterAccessors.jl",
    edit_link="main",
    assets=String[],
  ),
  pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/ITensor/TypeParameterAccessors.jl", devbranch="main")
