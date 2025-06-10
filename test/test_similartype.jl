using LinearAlgebra: Adjoint, Diagonal
using Test: @test, @test_broken, @test_throws, @testset
using TestExtras: @constinferred
using TypeParameterAccessors: NDims, similartype

@testset "TypeParameterAccessors similartype" begin
  @test similartype(Array, Float32, (2, 2)) === Matrix{Float32}
  @test similartype(Array, Float32, (Base.OneTo(2), Base.OneTo(2))) === Matrix{Float32}
  @test similartype(Array, Float32, Val(2)) === Matrix{Float32}
  @test similartype(Array, Float32, NDims(2)) === Matrix{Float32}
  @test similartype(Array{Float32,3}) === Array{Float32,3}
  @test similartype(Array{<:Any,3}, Float32) === Array{Float32,3}
  @test similartype(Array{Float32}, (2, 2)) === Matrix{Float32}
  @test similartype(Array{Float32}, (Base.OneTo(2), Base.OneTo(2))) === Matrix{Float32}
  @test similartype(Array{Float32}, NDims(2)) === Matrix{Float32}
  @test similartype(Array{Float32}, Val(2)) === Matrix{Float32}
  @test similartype(Array, Type{Float32}, NTuple{3,Base.OneTo{Int}}) === Array{Float32,3}
  @test similartype(Array, Type{Float32}, NTuple{3,Int}) === Array{Float32,3}
  @test similartype(Array, Type{Float32}, Val{3}) === Array{Float32,3}
  @test similartype(Array, Type{Float32}, NDims{3}) === Array{Float32,3}
  @test similartype(Array{Float32}, NTuple{3,Base.OneTo{Int}}) === Array{Float32,3}
  @test similartype(Array{Float32}, NTuple{3,Int}) === Array{Float32,3}
  @test similartype(Array{Float32}, Val{3}) === Array{Float32,3}
  @test similartype(Array{Float32}, NDims{3}) === Array{Float32,3}
  @test similartype(Array{<:Any,3}, Type{Float32}) === Array{Float32,3}
  @test_throws ArgumentError similartype(Array)
  @test_throws ArgumentError similartype(Array, Float64)
  @test_throws ArgumentError similartype(Array, Type{Float64})
  @test_throws ArgumentError similartype(Array, (2, 2))
  @test_throws ArgumentError similartype(Array, (Base.OneTo(2), Base.OneTo(2)))
  @test_throws ArgumentError similartype(Array, Tuple{Int,Int})
  @test_throws ArgumentError similartype(Array, Tuple{Base.OneTo{Int},Base.OneTo{Int}})
  @test_throws ArgumentError similartype(Array, Val(2))
  @test_throws ArgumentError similartype(Array, NDims(2))
  @test_throws ArgumentError similartype(Array, Val{2})
  @test_throws ArgumentError similartype(Array, NDims{2})

  @test similartype(randn(3, 3, 3), Float32, (2, 2)) === Matrix{Float32}
  @test similartype(randn(3, 3, 3), Float32, (Base.OneTo(2), Base.OneTo(2))) ===
    Matrix{Float32}
  @test similartype(randn(3, 3, 3), Float32, Val(2)) === Matrix{Float32}
  @test similartype(randn(3, 3, 3), Float32, NDims(2)) === Matrix{Float32}
  @test similartype(randn(Float32, 3, 3, 3)) === Array{Float32,3}
  @test similartype(randn(3, 3, 3), Float32) === Array{Float32,3}
  @test similartype(randn(Float32, 3, 3, 3), (2, 2)) === Matrix{Float32}
  @test similartype(randn(Float32, 3, 3, 3), (Base.OneTo(2), Base.OneTo(2))) ===
    Matrix{Float32}
  @test similartype(randn(Float32, 3, 3, 3), NDims(2)) === Matrix{Float32}
  @test similartype(randn(Float32, 3, 3, 3), Val(2)) === Matrix{Float32}

  # Adjoint
  @test similartype(Adjoint{Float32,Matrix{Float32}}, Float64, (2, 2, 2)) ===
    Array{Float64,3}
  @test similartype(Adjoint{Float32,Matrix{Float32}}, Float64, NDims(3)) ===
    Array{Float64,3}
  @test similartype(Adjoint{Float32,Matrix{Float32}}, Float64) === Matrix{Float64}

  # Diagonal
  @test similartype(Diagonal{Float32,Vector{Float32}}) === Matrix{Float32}
  @test similartype(Diagonal{Float32,Vector{Float32}}, Float64) === Matrix{Float64}
  @test similartype(Diagonal{Float32,Vector{Float32}}, (2, 2, 2)) === Array{Float32,3}
  @test similartype(Diagonal{Float32,Vector{Float32}}, NDims(3)) === Array{Float32,3}
  @test similartype(Diagonal{Float32,Vector{Float32}}, Float64, (2, 2, 2)) ===
    Array{Float64,3}
  @test similartype(Diagonal{Float32,Vector{Float32}}, Float64, NDims(3)) ===
    Array{Float64,3}

  # BitArray
  @test @constinferred(similartype(BitVector)) === BitVector
  if VERSION < v"1.11-"
    @test similartype(BitArray, (2, 2, 2)) === BitArray{3}
  else
    @test @constinferred(similartype(BitArray, (2, 2, 2))) == BitArray{3}
  end
  @test @constinferred(similartype(BitVector, (2, 2, 2))) === BitArray{3}
  if VERSION < v"1.11-"
    @test similartype(BitArray, NDims(3)) === BitArray{3}
  else
    @test @constinferred(similartype(BitArray, NDims(3))) === BitArray{3}
  end
  @test @constinferred(similartype(BitVector, NDims(3))) === BitArray{3}
  @test @constinferred(similartype(BitVector, Float32)) === Vector{Float32}
  if VERSION < v"1.11-"
    @test similartype(BitArray, Float32, (2, 2, 2)) === Array{Float32,3}
  else
    @test @constinferred(similartype(BitArray, Float32, (2, 2, 2))) === Array{Float32,3}
  end
  @test @constinferred(similartype(BitVector, Float32, (2, 2, 2))) === Array{Float32,3}
  if VERSION < v"1.11-"
    @test similartype(BitArray, Float32, NDims(3)) === Array{Float32,3}
  else
    @test @constinferred(similartype(BitArray, Float32, NDims(3))) === Array{Float32,3}
  end
  @test @constinferred(similartype(BitVector, Float32, NDims(3))) === Array{Float32,3}
  @test_throws ArgumentError similartype(BitArray)
  @test_throws ArgumentError similartype(BitArray, Float32)
end
