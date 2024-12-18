using Test: @test_throws, @testset
using TypeParameterAccessors:
  TypeParameterAccessors,
  Position,
  default_type_parameters,
  set_default_type_parameters,
  specify_default_type_parameters
using TestExtras: @constinferred
@testset "TypeParameterAccessors defaults" begin
  @testset "Erroneously requires wrapping to infer" begin end
  @testset "Get defaults" begin
    @test @constinferred(default_type_parameters($Array, 1)) == Float64
    @test @constinferred(default_type_parameters($Array, 2)) == 1
    @test @constinferred(default_type_parameters($Array)) == (Float64, 1)
    @test @constinferred(default_type_parameters($Array, $((2, 1)))) == (1, Float64)
    @test @constinferred(broadcast($default_type_parameters, $Array, (ndims, eltype))) ==
      (1, Float64)
    @test @constinferred(broadcast($default_type_parameters, $Array, $((2, 1)))) ==
      (1, Float64)
    @test @constinferred(broadcast($default_type_parameters, $Array, (ndims, eltype))) ==
      (1, Float64)
  end

  @testset "Set defaults" begin
    @test @constinferred(set_default_type_parameters($(Array{Float32}), 1)) ==
      Array{Float64}
    @test @constinferred(set_default_type_parameters($(Array{Float32}), eltype)) ==
      Array{Float64}
    @test @constinferred(set_default_type_parameters($(Array{Float32}))) == Vector{Float64}
    @test @constinferred(set_default_type_parameters($(Array{Float32}), $((1, 2)))) ==
      Vector{Float64}
    @test @constinferred(set_default_type_parameters($(Array{Float32}), (eltype, ndims))) ==
      Vector{Float64}
    @test @constinferred(set_default_type_parameters($Array)) == Vector{Float64}
    @test @constinferred(set_default_type_parameters($Array, 1)) == Array{Float64}
    @test @constinferred(set_default_type_parameters($Array, $((1, 2)))) == Vector{Float64}
  end

  @testset "Specify defaults" begin
    @test @constinferred(specify_default_type_parameters($Array, 1)) == Array{Float64}
    @test @constinferred(specify_default_type_parameters($Array, eltype)) == Array{Float64}
    @test @constinferred(specify_default_type_parameters($Array, 2)) == Vector
    @test @constinferred(specify_default_type_parameters($Array, ndims)) == Vector
    @test @constinferred(specify_default_type_parameters($Array)) == Vector{Float64}
    @test @constinferred(specify_default_type_parameters($Array, 1)) == Array{Float64}
    @test @constinferred(specify_default_type_parameters($Array, eltype)) == Array{Float64}
    @test @constinferred(specify_default_type_parameters($Array, 2)) == Vector
    @test @constinferred(specify_default_type_parameters($Array, ndims)) == Vector
    @test @constinferred(specify_default_type_parameters($Array, $((1, 2)))) ==
      Vector{Float64}
    @test @constinferred(specify_default_type_parameters($Array, (eltype, ndims))) ==
      Vector{Float64}
  end

  @testset "On objects" begin
    a = randn(Float32, (2, 2, 2))
    @test @constinferred(default_type_parameters(a, 1)) == Float64
    @test @constinferred(default_type_parameters(a, eltype)) == Float64
    @test @constinferred(default_type_parameters(a, 2)) == 1
    @test @constinferred(default_type_parameters(a, ndims)) == 1
    @test @constinferred(default_type_parameters(a)) == (Float64, 1)
  end
end
