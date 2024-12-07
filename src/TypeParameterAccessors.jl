module TypeParameterAccessors

include("type_utils.jl")
include("type_parameters.jl")

# Implementations
include("ndims.jl")
include("base/abstractarray.jl")
include("base/similartype.jl")
include("base/array.jl")
include("base/linearalgebra.jl")
include("base/stridedviews.jl")

end
