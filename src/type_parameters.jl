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
allows accessing the first type parameter with `type_parameter(MyType(...), eltype)`,
in addition to the standard `type_parameter(MyType(...), 1)` or `type_parameter(MyType(...), Position(1))`.
"""
function position end

position(object, name) = position(typeof(object), name)
@inline position(::Type, pos::Int) = Position(pos)
@inline position(::Type, pos::Position) = pos
position(type::Type, pos) = throw(MethodError(position, (type, pos)))

# Base.@constprop :aggressive function positions(::Type{T}, pos::Tuple) where {T}
#   @inline
#   return ntuple(i -> position(T, pos[i]), Val(length(pos)))
# end
@generated function positions(::Type{T}, pos::Tuple) where {T}
  ex = Expr(:tuple)
  for i in 1:nparameters(pos)
    push!(ex.args, :(position(T, pos[$(i)])))
  end
  return :(@inline; $ex)
end

"""
  type_parameters(type_or_obj, [pos...])

Return a tuple containing the type parameters of a given type or object.
Optionally you can specify a position to just get the parameter for that position.
"""
function type_parameters end

@inline type_parameters(::Type{T}) where {T} = Tuple(Base.unwrap_unionall(T).parameters)
@inline type_parameters(object, pos...) = type_parameters(typeof(object), pos...)
Base.@constprop :aggressive function type_parameters(::Type{T}, pos...) where {T}
  @inline
  return type_parameters(T, positions(T, pos)...)
end
@generated function type_parameters(::Type{T}, pos::Vararg{Position}) where {T}
  allparams = (T, type_parameters(T)...)
  return :(($((wrap_symbol_quotenode(allparams[Int(p) + 1]) for p in pos)...),))
end

Base.@constprop :aggressive type_parameter(t, pos...) = (
  @inline; type_parameters(t, pos...)[1]
)
# @inline type_parameter(t) = type_parameter(t, Position(1))
# @inline type_parameter(t, pos) = type_parameter(typeof(t), pos)
# @inline type_parameter(::Type{T}, pos) where {T} = only(type_parameters(T, (pos,)))

"""
  nparameters(type_or_obj)

Return the number of type parameters for a given type or object.
"""
nparameters(object) = nparameters(typeof(object))
nparameters(::Type{T}) where {T} = length(type_parameters(T))

"""
  is_parameter_specified(type::Type, pos)

Return whether or not the type parameter at a given position is considered specified or not.
"""
is_parameter_specified(::Type{T}, pos) where {T} = !(type_parameter(T, pos) isa TypeVar)

"""
  unspecify_type_parameters(type::Type, [positions::Tuple])

Return a new type where the type parameters at the given positions are unset.
"""
function unspecify_type_parameters(::Type{T}) where {T}
  return Base.typename(T).wrapper
end
function unspecify_type_parameters(::Type{T}, pos...) where {T}
  @inline
  return unspecify_type_parameters(T, positions(T, pos)...)
end
@generated function unspecify_type_parameters(
  ::Type{T}, positions::Vararg{Position}
) where {T}
  allparams = collect(Any, type_parameters(T))
  for pos in positions
    allparams[pos] = type_parameter(unspecify_type_parameters(T), Int(pos))
  end
  type_ex = construct_type_ex(T, allparams)
  return :(@inline; $type_ex)
end

unspecify_type_parameter(::Type{T}, pos) where {T} = unspecify_type_parameters(T, pos)

"""
  set_type_parameters(type::Type, positions::Tuple, parameters...)

Return a new type where the type parameters at the given positions are set to the provided values.
"""
function set_type_parameters(::Type{T}, pos::Tuple, parameters...) where {T}
  return set_type_parameters(T, positions(T, pos), parameters...)
end
@generated function set_type_parameters(
  ::Type{T}, positions::Tuple{Vararg{Position}}, params...
) where {T}
  # collect parameters and change
  allparams = collect(Any, type_parameters(T))
  for (i, pos) in enumerate(type_parameters(positions))
    allparams[pos] = :(params[$i])
  end
  type_ex = construct_type_ex(T, allparams)
  return :(@inline; $type_ex)
end

function set_type_parameter(::Type{T}, pos, param) where {T}
  return set_type_parameters(T, (pos,), param)
end

"""
  specify_type_parameters(type::Type, positions::Tuple, parameters...)

Return a new type where the type parameters at the given positions are set to the provided values,
only if they were previously unspecified.
"""
function specify_type_parameters(::Type{T}, pos::Tuple, parameters...) where {T}
  return specify_type_parameters(
    T, ntuple(i -> position(T, pos[i]), length(pos)), parameters...
  )
end
function specify_type_parameters(::Type{T}, parameters::Tuple) where {T}
  return specify_type_parameters(T, ntuple(identity, nparameters(T)), parameters...)
end
@generated function specify_type_parameters(
  ::Type{T}, positions::Tuple{Vararg{Position}}, params...
) where {T}
  # collect parameters and change unspecified
  allparams = collect(Any, type_parameters(T))
  for (i, pos) in enumerate(type_parameters(positions))
    if !is_parameter_specified(T, pos())
      allparams[pos] = :(params[$i])
    end
  end
  type_ex = construct_type_ex(T, allparams)
  return :(@inline; $type_ex)
end

function specify_type_parameter(::Type{T}, pos, param) where {T}
  return specify_type_parameters(T, (pos,), param)
end

"""
  default_type_parameters(type::Type)::Tuple

An optional interface function. Defining this allows filling type parameters
of the specified type with default values.

This function should output a Tuple of the default values, with exactly
one for each type parameter slot of the type.
"""
function default_type_parameters(::Type{T}, pos...) where {T}
  length(pos) == 0 && throw(ArgumentError("defaults not defined"))
  return map(pos) do p
    return default_type_parameters(T)[Int(position(T, p))]
  end
end
default_type_parameters(t, pos...) = default_type_parameters(typeof(t), pos...)

default_type_parameter(t, pos) = default_type_parameters(t, pos)[1]

"""
  set_default_type_parameters(type::Type, positions...)

"""
function set_default_type_parameters(::Type{T}, pos...) where {T}
  return set_type_parameters(T, pos, default_type_parameters(T, pos...)...)
end
function set_default_type_parameters(::Type{T}) where {T}
  return set_default_type_parameters(T, ntuple(identity, nparameters(T))...)
end

set_default_type_parameter(::Type{T}, pos) where {T} = set_default_type_parameters(T, pos)

"""
  specify_default_type_parameters(type::Type, positions...)

"""
function specify_default_type_parameters(::Type{T}, pos...) where {T}
  return specify_type_parameters(T, pos, default_type_parameters(T, pos...)...)
end
function specify_default_type_parameters(::Type{T}) where {T}
  return specify_default_type_parameters(T, ntuple(identity, nparameters(T))...)
end

function specify_default_type_parameter(::Type{T}, pos) where {T}
  return specify_default_type_parameters(T, pos)
end

#
#
# @inline type_parameter(param::TypeParameter) = parameter(typeof(param))
# function type_parameter(param::UnspecifiedTypeParameter)
#   return error("The requested type parameter isn't specified.")
# end
# Base.@constprop :aggressive function type_parameter(type::Type, pos)
#   return type_parameter(wrapped_type_parameter(type, pos))
# end
# @inline function type_parameter(object, pos)
#   return type_parameter(typeof(object), pos)
# end
# @inline function type_parameter(type_or_object)
#   return only(type_parameters(type_or_object))
# end
#
# function type_parameters(type_or_object, positions=eachposition(type_or_object))
#   return map(pos -> type_parameter(type_or_object, pos), positions)
# end
