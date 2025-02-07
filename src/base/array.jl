# TODO: Is this the best way to handle this?
# The idea is to be able to write functions that accept inputs of the form:
# ```julia
# f(AbstractArray)
# f(AbstractArray{Float64})
# f(AbstractMatrix{Float64})
# ```
# etc.
const AbstractArrayType{T,N} = Union{
  Type{AbstractArray},
  Type{AbstractArray{T}},
  Type{AbstractArray{<:Any,N}},
  Type{AbstractArray{T,N}},
}
position(::AbstractArrayType, ::typeof(eltype)) = Position(1)
position(::AbstractArrayType, ::typeof(ndims)) = Position(2)
default_type_parameters(::AbstractArrayType) = (Float64, 1)

position(::Type{<:Array}, ::typeof(eltype)) = Position(1)
position(::Type{<:Array}, ::typeof(ndims)) = Position(2)
default_type_parameters(::Type{<:Array}) = (Float64, 1)

position(::Type{<:BitArray}, ::typeof(ndims)) = Position(1)
default_type_parameters(::Type{<:BitArray}) = (1,)
