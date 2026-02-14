using Aqua: Aqua
using Test: @testset
using TypeParameterAccessors: TypeParameterAccessors

@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(TypeParameterAccessors)
end
