# Inputs as types.
function similartype(
  arraytype::Type{<:AbstractArray}, elt::Type{<:Type}, axt::Type{<:Tuple}
)
  return Base.promote_op(similar, arraytype, elt, axt)
end
function similartype(
  arraytype::Type{<:AbstractArray}, elt::Type{<:Type}, ndms::Type{<:Union{Val{N},NDims{N}}}
) where {N}
  return similartype(arraytype, elt, Tuple{ntuple(Returns(Base.OneTo{Int}), Val(N))...})
end
function similartype(arraytype::Type{<:AbstractArray{<:Any,N}}, elt::Type{<:Type}) where {N}
  return similartype(arraytype, elt, Tuple{ntuple(Returns(Base.OneTo{Int}), Val(N))...})
end
function similartype(arraytype::Type{<:AbstractArray{T}}, axt::Type{<:Tuple}) where {T}
  return similartype(arraytype, Type{T}, axt)
end
function similartype(
  arraytype::Type{<:AbstractArray{T}}, ::Type{<:Union{Val{N},NDims{N}}}
) where {T,N}
  return similartype(arraytype, Type{T}, Tuple{ntuple(Returns(Base.OneTo{Int}), Val(N))...})
end

function similartype(arraytype::Type{<:AbstractArray}, elt::Type, ndms::Union{Val,NDims})
  return similartype(arraytype, Type{elt}, Tuple{ntuple(Returns(Base.OneTo{Int}), ndms)...})
end

function similartype(arraytype::Type{<:AbstractArray}, elt::Type, dims::Tuple)
  return similartype(arraytype, Type{elt}, typeof(dims))
end

function similartype(arraytype::Type{<:AbstractArray{T,N}}) where {T,N}
  return similartype(arraytype, T, Val(N))
end
function similartype(arraytype::Type{<:AbstractArray})
  return throw(
    ArgumentError(
      "`similartype` requires specified type parameters if `eltype` and `ndims` aren't passed.",
    ),
  )
end

function similartype(arraytype::Type{<:AbstractArray{<:Any,N}}, elt::Type) where {N}
  return similartype(arraytype, elt, Val(N))
end
function similartype(arraytype::Type{<:AbstractArray}, elt::Type)
  return throw(
    ArgumentError("`similartype` requires specified `ndims` if `ndims` isn't passed.")
  )
end

function similartype(arraytype::Type{<:AbstractArray{T}}, dims::Tuple) where {T}
  return similartype(arraytype, T, dims)
end
function similartype(arraytype::Type{<:AbstractArray}, dims::Tuple)
  return throw(
    ArgumentError("`similartype` requires specified `eltype` if `eltype` isn't passed.")
  )
end

function similartype(arraytype::Type{<:AbstractArray{T}}, ndms::Union{Val,NDims}) where {T}
  return similartype(arraytype, T, ndms)
end
function similartype(arraytype::Type{<:AbstractArray}, ndms::Union{Val,NDims})
  return throw(
    ArgumentError("`similartype` requires specified `eltype` if `eltype` isn't passed.")
  )
end

function similartype(
  arraytype::Type{<:AbstractArray}, dim1::Base.DimOrInd, dim_rest::Base.DimOrInd...
)
  return similartype(arraytype, (dim1, dim_rest...))
end

# Instances
function similartype(array::AbstractArray, eltype::Type, dims...)
  return similartype(typeof(array), eltype, dims...)
end
function similartype(array::AbstractArray, eltype::Type)
  return similartype(typeof(array), eltype, axes(array))
end
similartype(array::AbstractArray, dims...) = similartype(typeof(array), dims...)
