module TypeParameterAccessorsAMDGPUExt

using AMDGPU: ROCArray
using TypeParameterAccessors: TypeParameterAccessors, Position

TypeParameterAccessors.position(::Type{<:ROCArray}, ::typeof(eltype)) = Position(1)
TypeParameterAccessors.position(::Type{<:ROCArray}, ::typeof(ndims)) = Position(2)

end
