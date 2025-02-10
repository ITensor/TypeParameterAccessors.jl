module TypeParameterAccessorsCUDAExt

using CUDA: CuArray
using TypeParameterAccessors: TypeParameterAccessors, Position

TypeParameterAccessors.position(::Type{<:CuArray}, ::typeof(eltype)) = Position(1)
TypeParameterAccessors.position(::Type{<:CuArray}, ::typeof(ndims)) = Position(2)

end
