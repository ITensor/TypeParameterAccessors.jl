using Test: @testset
using TestExtras: @constinferred

using TypeParameterAccessors: type_parameters, parenttype, set_type_parameters
using StridedViews: StridedView

@testset "StridedViews" begin
    a = StridedView(zeros(Int, 2, 2))

    Ta = typeof(a)
    tp = (eltype(a), ndims(a), parenttype(a), typeof(a.op))
    @test @constinferred(type_parameters($Ta)) === tp
    @test @constinferred(type_parameters($a)) === tp
    @test @constinferred(type_parameters($Ta, eltype)) === eltype(Ta)
    @test @constinferred(type_parameters($Ta, ndims)) === ndims(Ta)
    @test @constinferred(type_parameters($Ta, parenttype)) === parenttype(Ta)

    @test @constinferred(
        set_type_parameters($Ta, $((eltype, parenttype)), $((Float64, Matrix{Float64})))
    ) === StridedView{Float64, 2, Matrix{Float64}, typeof(a.op)}
end
