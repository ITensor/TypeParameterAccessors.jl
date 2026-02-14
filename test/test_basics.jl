using JLArrays: JLArray, JLMatrix, JLVector
using Test: @test, @test_broken, @test_throws, @testset
using TestExtras: @constinferred
using TypeParameterAccessors: TypeParameterAccessors, Position, complextype, imagtype,
    realtype, set_type_parameters, specify_type_parameters, type_parameters,
    unspecify_type_parameters

const anyarrayts = (
    (arrayt = Array, matrixt = Matrix, vectort = Vector),
    (arrayt = JLArray, matrixt = JLMatrix, vectort = JLVector),
)
@testset "basics (arrayts=$anyarrayt)" for anyarrayt in anyarrayts
    (; arrayt, matrixt, vectort) = anyarrayt

    @testset "Get parameters" begin
        @test @constinferred(type_parameters($(AbstractArray{Float64}), 1)) == Float64
        @test @constinferred(type_parameters($(AbstractArray{Float64}), eltype)) == Float64
        @test @constinferred(type_parameters($(AbstractMatrix{Float64}), ndims)) == 2

        @test @constinferred(type_parameters($(arrayt{Float64}), 1)) == Float64
        @test @constinferred(type_parameters($(Val{3}))) == (3,)

        # @test_throws ErrorException type_parameter(arrayt, 1)
        @test @constinferred(type_parameters($(arrayt{Float64}), eltype)) == Float64
        @test @constinferred(type_parameters($(matrixt{Float64}), ndims)) == 2
        @test @constinferred(type_parameters($(matrixt{Float64}), (ndims, eltype))) ==
            (2, Float64)
        # TODO: Not inferrable without interpolating positions:
        # https://github.com/ITensor/TypeParameterAccessors.jl/issues/21.
        @test @constinferred(type_parameters($(matrixt{Float64}), $((2, eltype)))) ==
            (2, Float64)
        @test @constinferred(type_parameters($(matrixt{Float64}), (ndims, eltype))) ==
            (2, Float64)
        # @test_throws ErrorException type_parameters(arrayt{Float64}, ndims) == 2
        @test @constinferred(
            broadcast($type_parameters, $(matrixt{Float64}), $((2, eltype)))
        ) == (2, Float64)
    end

    @testset "Set parameters" begin
        @test @constinferred(set_type_parameters($arrayt, 1, $Float64)) == arrayt{Float64}
        @test @constinferred(set_type_parameters($arrayt, 2, 2)) == matrixt
        @test @constinferred(set_type_parameters($arrayt, $eltype, $Float32)) ==
            arrayt{Float32}
        @test @constinferred(
            set_type_parameters($arrayt, $((eltype, 2)), $((Float32, 3)))
        ) ==
            arrayt{Float32, 3}
    end

    @testset "Specify parameters" begin
        @test @constinferred(specify_type_parameters($arrayt, 1, $Float64)) ==
            arrayt{Float64}
        @test @constinferred(
            specify_type_parameters($matrixt, $((2, 1)), $((4, Float32)))
        ) ==
            matrixt{Float32}
        @test @constinferred(specify_type_parameters($arrayt, $((Float64, 2)))) ==
            matrixt{Float64}
        @test @constinferred(specify_type_parameters($arrayt, $eltype, $Float32)) ==
            arrayt{Float32}
        @test @constinferred(
            specify_type_parameters($arrayt, $((eltype, 2)), $((Float32, 3)))
        ) == arrayt{Float32, 3}
    end

    @testset "Unspecify parameters" begin
        @test @constinferred(unspecify_type_parameters($vectort, 2)) == arrayt
        @test @constinferred(unspecify_type_parameters($(vectort{Float64}), eltype)) ==
            vectort
        @test @constinferred(unspecify_type_parameters($(vectort{Float64}))) == arrayt
        @test @constinferred(
            unspecify_type_parameters($(vectort{Float64}), $((eltype, 2)))
        ) ==
            arrayt
    end

    @testset "On objects" begin
        @test @constinferred(type_parameters($(Val{3}()))) == (3,)
        @test @constinferred(type_parameters($(Val{Float32}()))) == (Float32,)
        a = arrayt(randn(Float32, (2, 2, 2)))
        @test @constinferred(type_parameters(a, 1)) == Float32
        @test @constinferred(type_parameters(a, eltype)) == Float32
        @test @constinferred(type_parameters(a, 2)) == 3
        @test @constinferred(type_parameters(a, ndims)) == 3
        @test @constinferred(type_parameters(a)) == (Float32, 3)
        @test @constinferred(broadcast($type_parameters, $(Ref(a)), $((2, eltype)))) ==
            (3, Float32)
    end
end

@testset "Automatic fallback for position" begin
    struct MyArray{B, A} <: AbstractArray{A, B} end
    @test @constinferred(TypeParameterAccessors.position(MyArray, eltype)) == Position(2)
    @test @constinferred(TypeParameterAccessors.position(MyArray{3, Float32}, eltype)) ==
        Position(2)
    @test @constinferred(TypeParameterAccessors.position(MyArray, ndims)) == Position(1)
    @test @constinferred(TypeParameterAccessors.position(MyArray{3, Float32}, ndims)) ==
        Position(1)

    struct MyVector{X, Y, A <: Real} <: AbstractArray{A, 1} end
    @test @constinferred(TypeParameterAccessors.position(MyVector, eltype)) == Position(3)
    @test @constinferred(
        TypeParameterAccessors.position(MyVector{Int, (1, 2), Float32}, eltype)
    ) == Position(3)
    @test_throws ErrorException TypeParameterAccessors.position(MyVector, ndims)
    @test_throws ErrorException TypeParameterAccessors.position(
        MyVector{Int, (1, 2), Float32}, ndims
    )

    struct MyBoolArray{X, Y, Z, B} <: AbstractArray{Bool, B} end
    @test_throws ErrorException TypeParameterAccessors.position(MyBoolArray, eltype)
    @test_throws ErrorException TypeParameterAccessors.position(
        MyBoolArray{1, 2, 3, 4},
        eltype
    )
    @test @constinferred(TypeParameterAccessors.position(MyBoolArray, ndims)) == Position(4)
    @test @constinferred(TypeParameterAccessors.position(MyBoolArray{1, 2, 3, 4}, ndims)) ==
        Position(4)
end

@testset "complextype, realtype, imagtype" begin
    @test complextype(Float32(1.2)) === ComplexF32
    @test complextype(Float32(1.2) + Float32(2.3) * im) === ComplexF32
    @test complextype(Float32) === ComplexF32
    @test complextype(ComplexF32) === ComplexF32
    @test complextype(Type{Float32}) === ComplexF32
    @test complextype(Type{ComplexF32}) === ComplexF32
    @test complextype(randn(Float32, 2, 2)) === Matrix{ComplexF32}
    @test complextype(randn(ComplexF32, 2, 2)) === Matrix{ComplexF32}
    @test complextype(Matrix{Float32}) === Matrix{ComplexF32}
    @test complextype(Matrix{ComplexF32}) === Matrix{ComplexF32}

    for f in (realtype, imagtype)
        @test @constinferred(f(Float32(1.2))) === Float32
        @test @constinferred(f(Float32(1.2) + Float32(2.3) * im)) === Float32
        @test @constinferred(f(Float32)) === Float32
        @test @constinferred(f(ComplexF32)) === Float32
        @test @constinferred(f(Type{Float32})) === Float32
        @test @constinferred(f(Type{ComplexF32})) === Float32
        @test @constinferred(f(randn(Float32, 2, 2))) === Matrix{Float32}
        @test @constinferred(f(randn(ComplexF32, 2, 2))) === Matrix{Float32}
        @test @constinferred(f(Matrix{Float32})) === Matrix{Float32}
        @test @constinferred(f(Matrix{ComplexF32})) === Matrix{Float32}
    end
end
