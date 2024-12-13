"""
  struct Position{P} end

Singleton type to statically represent the type-parameter position.
This is meant for internal use as a `Val`-like structure to improve type-inference.
"""
struct Position{P} end
Position(pos::Int) = Position{pos}()

Base.Int(pos::Position) = Int(typeof(pos))
Base.Int(::Type{Position{P}}) where {P} = Int(P)
Base.to_index(pos::Position) = Base.to_index(typeof(pos))
Base.to_index(::Type{P}) where {P<:Position} = Int(P)

"""
  position(type::Type, position_name)::Position

An optional interface function. Defining this allows accessing a parameter
at the defined position using the `position_name`.

For example, defining `TypeParameterAccessors.position(::Type{<:MyType}, ::typeof(eltype)) = Position(1)`
allows accessing the first type parameter with `type_parameters(MyType(...), eltype)`,
in addition to the standard `type_parameters(MyType(...), 1)` or `type_parameters(MyType(...), Position(1))`.
"""
function position end

position(object, name) = position(typeof(object), name)
position(::Type, pos::Int) = Position(pos)
position(::Type, pos::Position) = pos
position(type::Type, pos) = throw(MethodError(position, (type, pos)))

function positions(::Type{T}, pos::Tuple) where {T}
  return ntuple(length(pos)) do i
    return position(T, pos[i])
  end
end

"""
  type_parameters(type_or_obj, [pos])

Return a tuple containing the type parameters of a given type or object.
Optionally you can specify a position to just get the parameter for that position.
"""
function type_parameters end

# This implementation is type-stable in 1.11, but not in 1.10.
# Attempts with `Base.@constprop :aggressive` failed, so generated function instead
# @inline type_parameters(::Type{T}) where {T} = Tuple(Base.unwrap_unionall(T).parameters)
@generated function type_parameters(::Type{T}) where {T}
  params = wrap_symbol_quotenode.(Tuple(Base.unwrap_unionall(T).parameters))
  return :(@inline; ($(params...),))
end
@inline type_parameters(::Type{T}, pos) where {T} = type_parameters(T, position(T, pos))
@inline type_parameters(::Type{T}, ::Position{p}) where {T,p} = type_parameters(T)[p]
@inline type_parameters(::Type{T}, ::Position{0}) where {T} = T
@inline type_parameters(object, pos) = type_parameters(typeof(object), pos)
@inline type_parameters(object) = type_parameters(typeof(object))

"""
  nparameters(type_or_obj)

Return the number of type parameters for a given type or object.
"""
nparameters(object) = nparameters(typeof(object))
nparameters(::Type{T}) where {T} = length(type_parameters(T))

"""
  is_parameter_specified(type::Type, pos)

Return whether or not the type parameter at a given position is considered specified.
"""
is_parameter_specified(::Type{T}, pos) where {T} = !(type_parameters(T, pos) isa TypeVar)

"""
  unspecify_type_parameters(type::Type, [positions::Tuple])
  unspecify_type_parameters(type::Type, position)

Return a new type where the type parameters at the given positions are unset.
"""
unspecify_type_parameters(::Type{T}) where {T} = Base.typename(T).wrapper
function unspecify_type_parameters(::Type{T}, pos::Tuple) where {T}
  @inline
  return unspecify_type_parameters(T, positions(T, pos))
end
@generated function unspecify_type_parameters(
  ::Type{T}, positions::Tuple{Vararg{Position}}
) where {T}
  allparams = collect(Any, type_parameters(T))
  for pos in type_parameters(positions)
    allparams[pos] = type_parameters(unspecify_type_parameters(T), Int(pos))
  end
  type_expr = construct_type_expr(T, allparams)
  return :(@inline; $type_expr)
end
unspecify_type_parameters(::Type{T}, pos) where {T} = unspecify_type_parameters(T, (pos,))

"""
  set_type_parameters(type::Type, positions::Tuple, parameters::Tuple)
  set_type_parameters(type::Type, position, parameter)

Return a new type where the type parameters at the given positions are set to the provided values.
"""
function set_type_parameters(
  ::Type{T}, pos::Tuple{Vararg{Any,N}}, parameters::Tuple{Vararg{Any,N}}
) where {T,N}
  return set_type_parameters(T, positions(T, pos), parameters)
end
@generated function set_type_parameters(
  ::Type{T}, positions::Tuple{Vararg{Position,N}}, params::Tuple{Vararg{Any,N}}
) where {T,N}
  # collect parameters and change
  allparams = collect(Any, type_parameters(T))
  for (i, pos) in enumerate(type_parameters(positions))
    allparams[pos] = :(params[$i])
  end
  type_expr = construct_type_expr(T, allparams)
  return :(@inline; $type_expr)
end
function set_type_parameters(::Type{T}, pos, param) where {T}
  return set_type_parameters(T, (pos,), (param,))
end

"""
  specify_type_parameters(type::Type, positions::Tuple, parameters::Tuple)
  specify_type_parameters(type::Type, position, parameter)

Return a new type where the type parameters at the given positions are set to the provided values,
only if they were previously unspecified.
"""
function specify_type_parameters(
  ::Type{T}, pos::Tuple{Vararg{Any,N}}, parameters::Tuple{Vararg{Any,N}}
) where {T,N}
  return specify_type_parameters(T, positions(T, pos), parameters)
end
function specify_type_parameters(::Type{T}, parameters::Tuple) where {T}
  return specify_type_parameters(T, ntuple(identity, nparameters(T)), parameters)
end
@generated function specify_type_parameters(
  ::Type{T}, positions::Tuple{Vararg{Position,N}}, params::Tuple{Vararg{Any,N}}
) where {T,N}
  # collect parameters and change unspecified
  allparams = collect(Any, type_parameters(T))
  for (i, pos) in enumerate(type_parameters(positions))
    if !is_parameter_specified(T, pos())
      allparams[pos] = :(params[$i])
    end
  end
  type_expr = construct_type_expr(T, allparams)
  return :(@inline; $type_expr)
end
function specify_type_parameters(::Type{T}, pos, param) where {T}
  return specify_type_parameters(T, (pos,), (param,))
end

"""
  default_type_parameters(type::Type)::Tuple

An optional interface function. Defining this allows filling type parameters
of the specified type with default values.

This function should output a Tuple of the default values, with exactly
one for each type parameter slot of the type.
"""
function default_type_parameters(::Type{T}, pos) where {T}
  return default_type_parameters(T, position(T, pos))
end
function default_type_parameters(::Type{T}, ::Position{pos}) where {T,pos}
  return default_type_parameters(T)[pos]
end
default_type_parameters(t) = default_type_parameters(typeof(t))
default_type_parameters(t, pos) = default_type_parameters(typeof(t), pos)

"""
  set_default_type_parameters(type::Type, [positions::Tuple])
  set_default_type_parameters(type::Type, position)

Set the type parameters at the given positions to their default values.
"""
function set_default_type_parameters(::Type{T}, pos::Tuple) where {T}
  return set_type_parameters(T, pos, default_type_parameters.(T, pos))
end
function set_default_type_parameters(::Type{T}) where {T}
  return set_default_type_parameters(T, ntuple(identity, nparameters(T)))
end
function set_default_type_parameters(::Type{T}, pos) where {T}
  return set_default_type_parameters(T, (pos,))
end

"""
  specify_default_type_parameters(type::Type, [positions::Tuple])
  specify_default_type_parameters(type::Type, position)

Set the type parameters at the given positions to their default values, if they
had not been specified.
"""
function specify_default_type_parameters(::Type{T}, pos::Tuple) where {T}
  return specify_type_parameters(T, pos, default_type_parameters.(T, pos))
end
function specify_default_type_parameters(::Type{T}) where {T}
  return specify_default_type_parameters(T, ntuple(identity, nparameters(T)))
end
function specify_default_type_parameters(::Type{T}, pos) where {T}
  return specify_default_type_parameters(T, (pos,))
end
