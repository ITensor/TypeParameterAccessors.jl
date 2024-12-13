using Test: @test_throws, @testset
using TestExtras: @constinferred
using TypeParameterAccessors:
  set_type_parameters, specify_type_parameters, type_parameters, unspecify_type_parameters

@testset "Get parameters" begin
  @test @constinferred(type_parameters($(AbstractArray{Float64}), 1)) == Float64
  @test @constinferred(type_parameters($(AbstractArray{Float64}), eltype)) == Float64
  @test @constinferred(type_parameters($(AbstractMatrix{Float64}), ndims)) == 2

  @test @constinferred(type_parameters($(Array{Float64}), 1)) == Float64
  @test @constinferred(type_parameters($(Val{3}))) == (3,)

  # @test_throws ErrorException type_parameter(Array, 1)
  @test @constinferred(type_parameters($(Array{Float64}), eltype)) == Float64
  @test @constinferred(type_parameters($(Matrix{Float64}), ndims)) == 2
  # @test_throws ErrorException type_parameter(Array{Float64}, ndims) == 2
  @test @constinferred(broadcast($type_parameters, $(Matrix{Float64}), $((2, eltype)))) ==
    (2, Float64)
end

@testset "Set parameters" begin
  @test @constinferred(set_type_parameters($Array, 1, $Float64)) == Array{Float64}
  @test @constinferred(set_type_parameters($Array, 2, 2)) == Matrix
  @test @constinferred(set_type_parameters($Array, $eltype, $Float32)) == Array{Float32}
  @test @constinferred(set_type_parameters($Array, $((eltype, 2)), $((Float32, 3)))) ==
    Array{Float32,3}
end

@testset "Specify parameters" begin
  @test @constinferred(specify_type_parameters($Array, 1, $Float64)) == Array{Float64}
  @test @constinferred(specify_type_parameters($Matrix, $((2, 1)), $((4, Float32)))) ==
    Matrix{Float32}
  @test @constinferred(specify_type_parameters($Array, $((Float64, 2)))) == Matrix{Float64}
  @test @constinferred(specify_type_parameters($Array, $eltype, $Float32)) == Array{Float32}
  @test @constinferred(specify_type_parameters($Array, $((eltype, 2)), $((Float32, 3)))) ==
    Array{Float32,3}
end

@testset "Unspecify parameters" begin
  @test @constinferred(unspecify_type_parameters($Vector, 2)) == Array
  @test @constinferred(unspecify_type_parameters($(Vector{Float64}), eltype)) == Vector
  @test @constinferred(unspecify_type_parameters($(Vector{Float64}))) == Array
  @test @constinferred(unspecify_type_parameters($(Vector{Float64}), $((eltype, 2)))) ==
    Array
end

@testset "On objects" begin
  @test @constinferred(type_parameters($(Val{3}()))) == (3,)
  @test @constinferred(type_parameters($(Val{Float32}()))) == (Float32,)
  a = randn(Float32, (2, 2, 2))
  @test @constinferred(type_parameters(a, 1)) == Float32
  @test @constinferred(type_parameters(a, eltype)) == Float32
  @test @constinferred(type_parameters(a, 2)) == 3
  @test @constinferred(type_parameters(a, ndims)) == 3
  @test @constinferred(type_parameters(a)) == (Float32, 3)
  @test @constinferred(broadcast($type_parameters, $(Ref(a)), $((2, eltype)))) ==
    (3, Float32)
end
