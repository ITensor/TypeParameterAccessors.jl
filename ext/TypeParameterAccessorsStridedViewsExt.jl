module TypeParameterAccessorsStridedViewsExt

using StridedViews: StridedView
using TypeParameterAccessors: TypeParameterAccessors, Position, parenttype

function TypeParameterAccessors.position(
  ::Type{T}, ::typeof(parenttype)
) where {T<:StridedView}
  return Position(3)
end

end
