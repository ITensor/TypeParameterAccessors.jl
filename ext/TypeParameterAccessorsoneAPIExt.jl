module TypeParameterAccessorsoneAPIExt

using oneAPI: oneArray
using TypeParameterAccessors: TypeParameterAccessors, Position

TypeParameterAccessors.position(::Type{<:oneArray}, ::typeof(eltype)) = Position(1)
TypeParameterAccessors.position(::Type{<:oneArray}, ::typeof(ndims)) = Position(2)

end
