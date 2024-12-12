using Test: @test_broken, @testset
using TestExtras: @constinferred
using LinearAlgebra:
  Adjoint,
  Diagonal,
  Hermitian,
  LowerTriangular,
  Symmetric,
  Transpose,
  UnitLowerTriangular,
  UnitUpperTriangular,
  UpperTriangular
using TypeParameterAccessors:
  type_parameters,
  NDims,
  is_wrapped_array,
  parenttype,
  set_eltype,
  set_ndims,
  set_parenttype,
  unspecify_type_parameters,
  unwrap_array_type
using StridedViews: StridedView

@testset "TypeParameterAccessors wrapper types" begin
  @testset "Array" begin
    array = randn(2, 2)
    array_type = typeof(array)
    @test @inferred(parenttype(Matrix)) === Matrix
    @test @inferred(is_wrapped_array(array)) == false
    @test @inferred(parenttype(array)) === array_type
    array_32 = @constinferred set_eltype(array, Float32)
    @test array_32 isa Matrix{Float32}
    @test array_32 ≈ array
    @test @inferred(set_eltype(Array{<:Any,2}, Float64)) == Matrix{Float64}
    @test @constinferred(set_ndims(Array{Float64}, 2)) == Matrix{Float64}
    @test @inferred(unwrap_array_type(array_type)) == array_type
  end

  @testset "Base AbstractArray wrappers" begin
    array = randn(2, 2)
    for wrapped_array in (
      Base.ReshapedArray(array, (2, 2), ()),
      SubArray(randn(2, 2), (:, :)),
      PermutedDimsArray(randn(2, 2), (1, 2)),
    )
      wrapped_array_type = typeof(wrapped_array)
      @test @inferred(parenttype(wrapped_array)) == Matrix{Float64}
      @test @inferred(type_parameters(wrapped_array, eltype)) == Float64
      @test @inferred(is_wrapped_array(wrapped_array)) == true
      @test @inferred(unwrap_array_type(wrapped_array_type)) == Matrix{Float64}
      @test @constinferred(set_eltype(wrapped_array_type, Float32)) <:
        unspecify_type_parameters(wrapped_array_type){Float32}
      # Julia doesn't have the necessary conversions defined for this to work.
      @test_broken set_eltype(wrapped_array, Float32) isa
        unspecify_type_parameters(wrapped_array_type){Float32}
    end
  end

  @testset "LinearAlgebra wrappers" begin
    for wrapper in (
      Transpose,
      Adjoint,
      Symmetric,
      Hermitian,
      UpperTriangular,
      LowerTriangular,
      UnitUpperTriangular,
      UnitLowerTriangular,
    )
      array = randn(2, 2)
      wrapped_array = wrapper(array)
      wrapped_array_type = typeof(wrapped_array)
      @test @inferred(is_wrapped_array(wrapped_array)) == true
      @test @inferred(parenttype(wrapped_array)) == Matrix{Float64}
      @test @inferred(unwrap_array_type(wrapped_array_type)) == Matrix{Float64}
      @test @inferred(set_parenttype(wrapped_array_type, wrapped_array_type)) ==
        wrapper{eltype(wrapped_array_type),wrapped_array_type}
      @test @inferred(set_eltype(wrapped_array_type, Float32)) ==
        wrapper{Float32,Matrix{Float32}}
      if wrapper ∉ (UnitUpperTriangular, UnitLowerTriangular)
        @test @inferred set_eltype(wrapped_array, Float32) isa
          wrapper{Float32,Matrix{Float32}}
      end
    end
  end

  @testset "LinearAlgebra Diagonal wrapper" begin
    array = randn(2, 2)
    wrapped_array = Diagonal(array)
    wrapped_array_type = typeof(wrapped_array)
    @test @inferred(is_wrapped_array(wrapped_array)) == true
    @test @inferred(parenttype(wrapped_array)) == Vector{Float64}
    @test @inferred(unwrap_array_type(wrapped_array_type)) == Vector{Float64}
    @test @inferred(set_eltype(wrapped_array_type, Float32)) ==
      Diagonal{Float32,Vector{Float32}}
    if VERSION ≥ v"1.8"
      # `Diagonal{T,Vector{T}}(diag::Diagonal)` not define in Julia 1.7
      # and below.
      @test @inferred(set_eltype(wrapped_array, Float32)) isa
        Diagonal{Float32,Vector{Float32}}
    end
  end

  @testset "LinearAlgebra nested wrappers" begin
    array = randn(2, 2)
    wrapped_array = view(reshape(transpose(array), 4), 1:2)
    wrapped_array_type = typeof(wrapped_array)
    @test @inferred(is_wrapped_array(wrapped_array)) == true
    @test @inferred(parenttype(wrapped_array)) <:
      Base.ReshapedArray{Float64,1,Transpose{Float64,Matrix{Float64}}}
    @test @inferred(unwrap_array_type(array)) == Matrix{Float64}
  end

  @testset "StridedView" begin
    array = randn(2, 2)
    wrapped_array = StridedView(randn(2, 2))
    wrapped_array_type = typeof(wrapped_array)
    @test @inferred(is_wrapped_array(wrapped_array)) == true
    @test @inferred(parenttype(wrapped_array)) == Matrix{Float64}
    @test @inferred(unwrap_array_type(wrapped_array_type)) == Matrix{Float64}
  end
end
