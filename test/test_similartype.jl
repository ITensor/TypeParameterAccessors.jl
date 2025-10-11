using LinearAlgebra: Adjoint, Diagonal
using Test: @test, @test_broken, @testset
using TestExtras: @constinferred
using TypeParameterAccessors: NDims, similartype

@testset "TypeParameterAccessors similartype" begin
    @test similartype(Array, Float64, (2, 2)) == Matrix{Float64}
    @test similartype(Array) == Array
    @test similartype(Array, Float64) == Array{Float64}
    @test similartype(Array, (2, 2)) == Matrix
    @test similartype(Array, NDims(2)) == Matrix
    @test similartype(Array, Float64, (2, 2)) == Matrix{Float64}
    @test similartype(Array, Float64, NDims(2)) == Matrix{Float64}

    # Adjoint
    @test similartype(Adjoint{Float32, Matrix{Float32}}, Float64, (2, 2, 2)) ==
        Array{Float64, 3}
    @test similartype(Adjoint{Float32, Matrix{Float32}}, Float64, NDims(3)) == Array{Float64, 3}
    @test similartype(Adjoint{Float32, Matrix{Float32}}, Float64) == Matrix{Float64}

    # Diagonal
    @test similartype(Diagonal{Float32, Vector{Float32}}) == Matrix{Float32}
    @test similartype(Diagonal{Float32, Vector{Float32}}, Float64) == Matrix{Float64}
    @test similartype(Diagonal{Float32, Vector{Float32}}, (2, 2, 2)) == Array{Float32, 3}
    @test similartype(Diagonal{Float32, Vector{Float32}}, NDims(3)) == Array{Float32, 3}
    @test similartype(Diagonal{Float32, Vector{Float32}}, Float64, (2, 2, 2)) ==
        Array{Float64, 3}
    @test similartype(Diagonal{Float32, Vector{Float32}}, Float64, NDims(3)) ==
        Array{Float64, 3}

    # BitArray
    @test @constinferred(similartype(BitArray)) == BitArray
    @test @constinferred(similartype(BitVector)) == BitVector
    @test @constinferred(similartype(BitArray, (2, 2, 2))) == BitArray{3}
    @test @constinferred(similartype(BitVector, (2, 2, 2))) == BitArray{3}
    @test @constinferred(similartype(BitArray, NDims(3))) == BitArray{3}
    @test @constinferred(similartype(BitVector, NDims(3))) == BitArray{3}
    @test @constinferred(similartype(BitArray, Float32)) == Array{Float32}
    @test @constinferred(similartype(BitVector, Float32)) == Vector{Float32}
    @test @constinferred(similartype(BitArray, Float32, (2, 2, 2))) == Array{Float32, 3}
    @test @constinferred(similartype(BitVector, Float32, (2, 2, 2))) == Array{Float32, 3}
    @test @constinferred(similartype(BitArray, Float32, NDims(3))) == Array{Float32, 3}
    @test @constinferred(similartype(BitVector, Float32, NDims(3))) == Array{Float32, 3}
end
