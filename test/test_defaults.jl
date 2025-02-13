using JLArrays: JLArray
using Test: @test, @test_throws, @testset
using TestExtras: @constinferred
using TypeParameterAccessors:
  TypeParameterAccessors,
  Position,
  default_type_parameters,
  set_default_type_parameters,
  specify_default_type_parameters

const arrayts = (Array, JLArray)
@testset "TypeParameterAccessors defaults $arrayt" for arrayt in arrayts
  vectort = arrayt{<:Any,1}
  @testset "Get defaults" begin
    @test @constinferred(default_type_parameters($arrayt, 1)) == Float64
    @test @constinferred(default_type_parameters($arrayt, 2)) == 1
    @test @constinferred(default_type_parameters($arrayt)) == (Float64, 1)
    @test @constinferred(default_type_parameters($arrayt, $((2, 1)))) == (1, Float64)
    @test @constinferred(broadcast($default_type_parameters, $arrayt, (ndims, eltype))) ==
      (1, Float64)
    @test @constinferred(broadcast($default_type_parameters, $arrayt, $((2, 1)))) ==
      (1, Float64)
    @test @constinferred(broadcast($default_type_parameters, $arrayt, (ndims, eltype))) ==
      (1, Float64)
  end

  @testset "Set defaults" begin
    @test @constinferred(set_default_type_parameters($(arrayt{Float32}), 1)) ==
      arrayt{Float64}
    @test @constinferred(set_default_type_parameters($(arrayt{Float32}), eltype)) ==
      arrayt{Float64}
    @test @constinferred(set_default_type_parameters($(arrayt{Float32}))) ==
      vectort{Float64}
    @test @constinferred(set_default_type_parameters($(arrayt{Float32}), $((1, 2)))) ==
      vectort{Float64}
    @test @constinferred(
      set_default_type_parameters($(arrayt{Float32}), (eltype, ndims))
    ) == vectort{Float64}
    @test @constinferred(set_default_type_parameters($arrayt)) == vectort{Float64}
    @test @constinferred(set_default_type_parameters($arrayt, 1)) == arrayt{Float64}
    @test @constinferred(set_default_type_parameters($arrayt, $((1, 2)))) ==
      vectort{Float64}
  end

  @testset "Specify defaults" begin
    @test @constinferred(specify_default_type_parameters($arrayt, 1)) == arrayt{Float64}
    @test @constinferred(specify_default_type_parameters($arrayt, eltype)) ==
      arrayt{Float64}
    @test @constinferred(specify_default_type_parameters($arrayt, 2)) == vectort
    @test @constinferred(specify_default_type_parameters($arrayt, ndims)) == vectort
    @test @constinferred(specify_default_type_parameters($arrayt)) == vectort{Float64}
    @test @constinferred(specify_default_type_parameters($arrayt, 1)) == arrayt{Float64}
    @test @constinferred(specify_default_type_parameters($arrayt, eltype)) ==
      arrayt{Float64}
    @test @constinferred(specify_default_type_parameters($arrayt, 2)) == vectort
    @test @constinferred(specify_default_type_parameters($arrayt, ndims)) == vectort
    @test @constinferred(specify_default_type_parameters($arrayt, $((1, 2)))) ==
      vectort{Float64}
    @test @constinferred(specify_default_type_parameters($arrayt, (eltype, ndims))) ==
      vectort{Float64}
  end

  @testset "On objects" begin
    a = randn(Float32, (2, 2, 2))
    @test @constinferred(default_type_parameters(a, 1)) == Float64
    @test @constinferred(default_type_parameters(a, eltype)) == Float64
    @test @constinferred(default_type_parameters(a, 2)) == 1
    @test @constinferred(default_type_parameters(a, ndims)) == 1
    @test @constinferred(default_type_parameters(a)) == (Float64, 1)
  end

  @testset "Automatic fallback for defaults" begin
    struct MyArray{B,A} <: AbstractArray{A,B} end
    @test @constinferred(default_type_parameters(MyArray)) === (1, Float64)
    @test @constinferred(default_type_parameters(MyArray{2,Float32})) === (1, Float64)
    @test @constinferred(default_type_parameters($MyArray, 1)) === 1
    @test @constinferred(default_type_parameters($MyArray, 2)) === Float64
    @test @constinferred(default_type_parameters(MyArray, eltype)) === Float64
    @test @constinferred(default_type_parameters(MyArray, ndims)) === 1

    und = TypeParameterAccessors.UndefinedDefaultTypeParameter()

    struct MyVector{X,Y,A<:Real} <: AbstractArray{A,1} end
    @test @constinferred(default_type_parameters(MyVector)) === (und, und, Float64)
    @test_throws ErrorException default_type_parameters(MyVector, 1)
    @test_throws ErrorException default_type_parameters(MyVector, 2)
    @test @constinferred(default_type_parameters($MyVector, 3)) === Float64
    @test @constinferred(default_type_parameters(MyVector, eltype)) === Float64
    @test_throws ErrorException default_type_parameters(MyVector, ndims)

    struct MyBoolArray{X,Y,Z,B} <: AbstractArray{Bool,B} end
    @test @constinferred(default_type_parameters(MyBoolArray)) === (und, und, und, 1)
    @test_throws ErrorException default_type_parameters(MyBoolArray, 1)
    @test_throws ErrorException default_type_parameters(MyBoolArray, 2)
    @test_throws ErrorException default_type_parameters(MyBoolArray, 3)
    @test @constinferred(default_type_parameters($MyBoolArray, 4)) === 1
    @test_throws ErrorException default_type_parameters(MyBoolArray, eltype)
    @test @constinferred(default_type_parameters(MyBoolArray, ndims)) === 1
  end
end
