using Test: @testset
using TestExtras: @constinferred

using TypeParameterAccessors:
  type_parameters, set_type_parameters, set_default_type_parameters
using FillArrays: Fill, Zeros, Ones

@testset "Fill" begin
  a = Fill(1, 2, 2)
  Ta = typeof(a)
  tp = (eltype(a), ndims(a), typeof(axes(a)))
  @test @constinferred(type_parameters($Ta)) === tp
  @test @constinferred(type_parameters($a)) === tp
  @test @constinferred(type_parameters($Ta, eltype)) === eltype(Ta)
  @test @constinferred(type_parameters($Ta, ndims)) === ndims(Ta)

  @test @constinferred(set_type_parameters($Ta, eltype, $Float64)) ===
    Fill{Float64,ndims(a),typeof(axes(a))}
  @test @constinferred(set_default_type_parameters($Ta)) ===
    Fill{Float64,1,Tuple{Base.OneTo{Int}}}
end

@testset "Zeros" begin
  a = Zeros{Int}(2, 2)
  Ta = typeof(a)
  tp = (eltype(a), ndims(a), typeof(axes(a)))
  @test @constinferred(type_parameters($Ta)) === tp
  @test @constinferred(type_parameters($a)) === tp
  @test @constinferred(type_parameters($Ta, eltype)) === eltype(Ta)
  @test @constinferred(type_parameters($Ta, ndims)) === ndims(Ta)

  @test @constinferred(set_type_parameters($Ta, eltype, $Float64)) ===
    Zeros{Float64,ndims(a),typeof(axes(a))}
  @test @constinferred(set_default_type_parameters($Ta)) ===
    Zeros{Float64,1,Tuple{Base.OneTo{Int}}}
end

@testset "Ones" begin
  a = Ones{Int}(2, 2)
  Ta = typeof(a)
  tp = (eltype(a), ndims(a), typeof(axes(a)))
  @test @constinferred(type_parameters($Ta)) === tp
  @test @constinferred(type_parameters($a)) === tp
  @test @constinferred(type_parameters($Ta, eltype)) === eltype(Ta)
  @test @constinferred(type_parameters($Ta, ndims)) === ndims(Ta)

  @test @constinferred(set_type_parameters($Ta, eltype, $Float64)) ===
    Ones{Float64,ndims(a),typeof(axes(a))}
  @test @constinferred(set_default_type_parameters($Ta)) ===
    Ones{Float64,1,Tuple{Base.OneTo{Int}}}
end
