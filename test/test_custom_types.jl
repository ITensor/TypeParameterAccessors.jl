using Test: @testset
using TypeParameterAccessors:
  TypeParameterAccessors,
  Position,
  default_type_parameters,
  set_default_type_parameter,
  set_default_type_parameters,
  set_type_parameter,
  set_type_parameters,
  specify_default_type_parameter,
  specify_default_type_parameters,
  specify_type_parameter,
  specify_type_parameters,
  type_parameters,
  unspecify_type_parameter,
  unspecify_type_parameters
using TestExtras: @constinferred
@testset "TypeParameterAccessors, named positions and defaults" begin
  struct MyType{P1,P2} end
  TypeParameterAccessors.default_type_parameters(::Type{<:MyType}) = (:P1, :P2)

  @test @constinferred(default_type_parameters($MyType, 1)) == :P1
  @test @constinferred(default_type_parameters($MyType, 2)) == :P2
  @test @constinferred(default_type_parameters($(MyType{<:Any,2}), 1)) == :P1
  @test @constinferred(default_type_parameters($(MyType{<:Any,2}), 2)) == :P2
  @test @constinferred(default_type_parameters($(MyType{<:Any,2}))) == (:P1, :P2)
  @test @constinferred(default_type_parameters(MyType)) == (:P1, :P2)
  @test @constinferred(default_type_parameters($(MyType{<:Any,2}), 1)) == :P1
  @test @constinferred(default_type_parameters($(MyType{<:Any,2}), 2)) == :P2

  @test @constinferred(set_default_type_parameter(MyType{1,2}, 1)) == MyType{:P1,2}
  @test @constinferred(set_default_type_parameter(MyType{<:Any,2}, 1)) == MyType{:P1,2}
  @test @constinferred(set_default_type_parameter(MyType{<:Any,2}, 2)) == MyType{<:Any,:P2}
  @test @constinferred(set_default_type_parameters(MyType{<:Any,2})) == MyType{:P1,:P2}

  @test @constinferred(specify_default_type_parameters(MyType{<:Any,2})) == MyType{:P1,2}
  @test @constinferred(specify_default_type_parameter(MyType{<:Any,2}, 1)) == MyType{:P1,2}
  @test @constinferred(specify_default_type_parameter(MyType{<:Any,2}, 2)) ==
    MyType{<:Any,2}
  @test @constinferred(specify_default_type_parameters(MyType)) == MyType{:P1,:P2}

  # Named positions
  function p1 end
  function p2 end
  TypeParameterAccessors.position(::Type{<:MyType}, ::typeof(p1)) = Position(1)
  TypeParameterAccessors.position(::Type{<:MyType}, ::typeof(p2)) = Position(2)

  @test @constinferred(type_parameters(MyType{:p1}, p1)) == :p1
  @test @constinferred(type_parameters(MyType{<:Any,:p2}, p2)) == :p2
  @test @constinferred(default_type_parameters(MyType, p1)) == :P1
  @test @constinferred(default_type_parameters(MyType, p2)) == :P2
end
