using Base.Broadcast: broadcasted
using LinearAlgebra: Adjoint, Diagonal
using Test: @test, @test_broken, @test_throws, @testset
using TestExtras: @constinferred
using TypeParameterAccessors: NDims, similartype

@testset "TypeParameterAccessors similartype" begin
  # similartype(a, elt, ax)
  @test similartype(Array, Float32, Base.OneTo.((2, 2))) === Matrix{Float32}
  @test similartype(Array, Type{Float32}, NTuple{3,Base.OneTo{Int}}) === Array{Float32,3}
  @test similartype(randn(3, 3, 3), Float32, Base.OneTo.((2, 2))) === Matrix{Float32}

  # similartype(a, elt, sz)
  @test similartype(Array, Float32, (2, 2)) === Matrix{Float32}
  @test similartype(Array, Type{Float32}, NTuple{3,Int}) === Array{Float32,3}
  @test similartype(randn(3, 3, 3), Float32, (2, 2)) === Matrix{Float32}

  # similartype(a, elt)
  @test similartype(Array{<:Any,3}, Float32) === Array{Float32,3}
  @test similartype(Array{<:Any,3}, Type{Float32}) === Array{Float32,3}
  @test similartype(randn(3, 3, 3), Float32) === Array{Float32,3}

  # similartype(a, ax)
  @test similartype(Array{Float32}, Base.OneTo.((2, 2))) === Matrix{Float32}
  @test similartype(Array{Float32}, NTuple{3,Base.OneTo{Int}}) === Array{Float32,3}

  # similartype(a, sz)
  @test similartype(Array{Float32}, (2, 2)) === Matrix{Float32}
  @test similartype(Array{Float32}, NTuple{3,Int}) === Array{Float32,3}
  @test similartype(randn(Float32, 3, 3, 3), Base.OneTo.((2, 2))) === Matrix{Float32}

  # similartype(a)
  @test similartype(Array{Float32,3}) === Array{Float32,3}
  @test similartype(randn(Float32, 3, 3, 3)) === Array{Float32,3}

  # Underdefined
  @test_throws ArgumentError similartype(Array, Float64)
  @test_throws ArgumentError similartype(Array, Type{Float64})
  @test_throws ArgumentError similartype(Array, Base.OneTo.((2, 2)))
  @test_throws ArgumentError similartype(Array, Tuple{Base.OneTo{Int},Base.OneTo{Int}})
  @test_throws ArgumentError similartype(Array, (2, 2))
  @test_throws ArgumentError similartype(Array, Tuple{Int,Int})
  @test_throws ArgumentError similartype(Array)

  # Adjoint
  @test similartype(Adjoint{Float32,Matrix{Float32}}, Float64, (2, 2, 2)) ===
    Array{Float64,3}
  @test similartype(Adjoint{Float32,Matrix{Float32}}, Float64) === Matrix{Float64}

  # Diagonal
  @test similartype(Diagonal{Float32,Vector{Float32}}) === Diagonal{Float32,Vector{Float32}}
  @test similartype(Diagonal{Float32,Vector{Float32}}, Float64) ===
    Diagonal{Float64,Vector{Float64}}
  @test_throws ArgumentError similartype(Diagonal{Float32,Vector{Float32}}, (2, 2, 2))
  @test similartype(Diagonal{Float32,Vector{Float32}}, Float64, (2, 2, 2)) ===
    Array{Float64,3}

  # BitArray
  @test @constinferred(similartype(BitVector)) === BitVector
  if VERSION < v"1.11-"
    @test similartype(BitArray, (2, 2, 2)) === BitArray{3}
  else
    @test @constinferred(similartype(BitArray, (2, 2, 2))) == BitArray{3}
  end
  @test_throws ArgumentError similartype(BitVector, (2, 2, 2))
  @test @constinferred(similartype(BitVector, Float32)) === Vector{Float32}
  if VERSION < v"1.11-"
    @test similartype(BitArray, Float32, (2, 2, 2)) === Array{Float32,3}
  else
    @test @constinferred(similartype(BitArray, Float32, (2, 2, 2))) === Array{Float32,3}
  end
  @test @constinferred(similartype(BitVector, Float32, (2, 2, 2))) === Array{Float32,3}
  @test_throws ArgumentError similartype(BitArray)
  @test_throws ArgumentError similartype(BitArray, Float32)

  # Base.Broadcasted (test on non-AbstractArray)
  bc = broadcasted(+, randn(2, 2, 2), randn(2, 2, 2))
  @test @constinferred(similartype(bc, Float32, Base.OneTo.((3, 3)))) === Matrix{Float32}
  @test @constinferred(
    similartype(typeof(bc), Type{Float32}, NTuple{2,Base.OneTo{Int}})
  ) === Matrix{Float32}
  @test @constinferred(similartype(bc, Float32, (3, 3))) === Matrix{Float32}
  @test @constinferred(similartype(typeof(bc), Type{Float32}, NTuple{2,Int})) ===
    Matrix{Float32}
  @test @constinferred(similartype(bc, Float32)) === Array{Float32,3}
  @test @constinferred(similartype(typeof(bc), Type{Float32})) === Array{Float32,3}
end
