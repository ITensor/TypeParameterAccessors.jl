@eval module $(gensym())
using TypeParameterAccessors: TypeParameterAccessors
using Test: @testset
using Aqua: Aqua
@testset "TypeParameterAccessors.jl" begin
  @testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(TypeParameterAccessors)
  end
end
end
