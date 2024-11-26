using Literate: Literate
using TypeParameterAccessors: TypeParameterAccessors

Literate.markdown(
  joinpath(pkgdir(TypeParameterAccessors), "examples", "README.jl"),
  joinpath(pkgdir(TypeParameterAccessors));
  flavor=Literate.CommonMarkFlavor(),
  name="README",
)
