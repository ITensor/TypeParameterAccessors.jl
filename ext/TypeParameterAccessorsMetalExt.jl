module TypeParameterAccessorsMetalExt

using Metal: MtlArray
using TypeParameterAccessors: TypeParameterAccessors, Position

TypeParameterAccessors.position(::Type{<:MtlArray}, ::typeof(eltype)) = Position(1)
TypeParameterAccessors.position(::Type{<:MtlArray}, ::typeof(ndims)) = Position(2)

end
