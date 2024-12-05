abstract type AbstractTypeParameter end
@inline AbstractTypeParameter(param::AbstractTypeParameter) = param
@inline wrapped_type_parameter(param) = AbstractTypeParameter(param)
@inline wrapped_type_parameter(type::Type, pos) =
  AbstractTypeParameter(parameter(type, pos))

struct TypeParameter{Param} <: AbstractTypeParameter end
@inline TypeParameter(param) = TypeParameter{param}()
@inline TypeParameter(param::TypeParameter) = param
@inline AbstractTypeParameter(param) = TypeParameter(param)

struct UnspecifiedTypeParameter <: AbstractTypeParameter end
@inline AbstractTypeParameter(param::TypeVar) = UnspecifiedTypeParameter()
