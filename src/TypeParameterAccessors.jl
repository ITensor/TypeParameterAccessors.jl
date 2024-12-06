module TypeParameterAccessors

include("type_utils.jl")
# Interface
# include("interface.jl")
# include("to_unionall.jl")
# include("parameters.jl")
# include("abstractposition.jl")
# include("abstracttypeparameter.jl")
include("type_parameters.jl")
# include("position.jl")
# include("parameter.jl")
# include("is_parameter_specified.jl")
# include("unspecify_parameters.jl")
# include("set_parameters.jl")
# include("specify_parameters.jl")
# include("default_parameters.jl")

# Implementations
include("ndims.jl")
include("base/abstractarray.jl")
include("base/similartype.jl")
include("base/array.jl")
include("base/linearalgebra.jl")
include("base/stridedviews.jl")

end
