"""
  position(type::Type, position_name)::Position

An optional interface function. Defining this allows accessing a parameter
at the defined position using the `position_name`.

For example, defining `TypeParameterAccessors.position(::Type{<:MyType}, ::typeof(eltype)) = Position(1)`
allows accessing the first type parameter with `type_parameter(MyType(...), eltype)`,
in addition to the standard `type_parameter(MyType(...), 1)` or `type_parameter(MyType(...), Position(1))`.
"""
function position end

"""
  type_parameters(type_or_obj, [pos])

Return a tuple containing the type parameters of a given type or object.
Optionally you can specify a position to just get the parameter for that position.
"""
function type_parameters end

"""
  set_type_parameters(type::Type, positions::Tuple, parameters...)

Return a new type where the type parameters at the given positions are set to the provided values.
"""
function set_type_parameters end

"""
  specify_type_parameters(type::Type, positions::Tuple, parameters...)

Return a new type where the type parameters at the given positions are set to the provided values,
only if they were previously unspecified.
"""
function specify_type_parameters end

"""
  unspecify_type_parameters(type::Type, positions::Tuple)

Return a new type where the type parameters at the given positions are unset.
"""
function unspecify_type_parameters end

"""
  default_type_parameters(type::Type)::Tuple

An optional interface function. Defining this allows filling type parameters
of the specified type with default values.

This function should output a Tuple of the default values, with exactly
one for each type parameter slot of the type.
"""
function default_type_parameters end

"""
  set_default_type_parameters(type::Type, positions::Tuple)

"""
function set_default_type_parameters end

"""
  specify_default_type_parameters(type::Type, positions::Tuple)

"""
function specify_default_type_parameters end
