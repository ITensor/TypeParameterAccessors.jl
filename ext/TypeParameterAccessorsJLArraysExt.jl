module TypeParameterAccessorsJLArraysExt

using JLArrays: JLArray
using TypeParameterAccessors: TypeParameterAccessors, Position

TypeParameterAccessors.position(::Type{<:JLArray}, ::typeof(eltype)) = Position(1)
TypeParameterAccessors.position(::Type{<:JLArray}, ::typeof(ndims)) = Position(2)

end
