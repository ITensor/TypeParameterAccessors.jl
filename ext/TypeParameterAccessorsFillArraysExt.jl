module TypeParameterAccessorsFillArraysExt

using TypeParameterAccessors: TypeParameterAccessors, Position
using FillArrays: Fill, Zeros, Ones

for T in (:Fill, :Zeros, :Ones)
  @eval TypeParameterAccessors.position(::Type{<:$T}, ::typeof(eltype)) = Position(1)
  @eval TypeParameterAccessors.position(::Type{<:$T}, ::typeof(ndims)) = Position(2)
  @eval TypeParameterAccessors.position(::Type{<:$T}, ::typeof(axes)) = Position(3)
  @eval TypeParameterAccessors.default_type_parameters(::Type{<:$T}) = (Float64, 0, Tuple{})
end

end
