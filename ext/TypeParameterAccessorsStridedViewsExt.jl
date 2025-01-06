module TypeParameterAccessorsStridedViewsExt

using StridedViews: StridedView
using TypeParameterAccessors: TypeParameterAccessors, Position, parenttype

TypeParameterAccessors.position(::Type{<:StridedView}, ::typeof(eltype)) = Position(1)
TypeParameterAccessors.position(::Type{<:StridedView}, ::typeof(ndims)) = Position(2)
function TypeParameterAccessors.position(::Type{<:StridedView}, ::typeof(parenttype))
  return Position(3)
end

end
