struct NDims{ndims} end
Base.ndims(::NDims{ndims}) where {ndims} = ndims

NDims(ndims::Integer) = NDims{ndims}()
NDims(arraytype::Type{<:AbstractArray}) = NDims(ndims(arraytype))
NDims(array::AbstractArray) = NDims(typeof(array))

Base.ntuple(f, ::NDims{N}) where {N} = ntuple(f, Val(N))
