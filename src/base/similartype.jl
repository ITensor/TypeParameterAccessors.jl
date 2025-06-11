function check_similartype_output(type::Type)
  isconcretetype(type) || throw(
    ArgumentError(
      "`similartype` output `$type`, which is not concrete. The corresponding call to `similar` may not be defined or may not be type stable.",
    ),
  )
  return type
end

"""
    similartype(A, [elt], [shape])
    similartype(typeof(A), [typeof(elt)], [typeof(shape)])

    similartype(typeof(A), shape)
    similartype(typeof(typeof(A)), typeof(shape))

Compute the type that is returned by calling `Base.similar` on the given arguments.
You can either pass instances or types.

!!! warning
    The fallback definition for this function uses `Base.promote_op(similar, args...)`,
    so new implementations of `similar` cannot use this function to determine the output
    type without also implementing `similartype`. Additionally, getting a result that
    is a concrete type requires that the corresponding `similar` call is type stable.
"""
similartype

# similartype(a, elt, ax)
function similartype(arrayt::Type{<:AbstractArray}, eltt::Type{<:Type}, axt::Type{<:Tuple})
  return check_similartype_output(Base.promote_op(similar, arrayt, eltt, axt))
end
function similartype(arrayt::Type{<:AbstractArray}, elt::Type, ax::Tuple)
  return similartype(arrayt, Type{elt}, typeof(ax))
end
function similartype(a::AbstractArray, elt::Type, ax::Tuple)
  return similartype(typeof(a), Type{elt}, typeof(ax))
end

# similartype(a, elt)
function similartype(arrayt::Type{<:AbstractArray}, eltt::Type{<:Type})
  return check_similartype_output(Base.promote_op(similar, arrayt, eltt))
end
function similartype(arrayt::Type{<:AbstractArray}, elt::Type)
  return similartype(arrayt, Type{elt})
end
function similartype(a::AbstractArray, elt::Type)
  return similartype(typeof(a), Type{elt})
end

# similartype(a, ax)
function similartype(arrayt::Type{<:AbstractArray}, axt::Type{<:Tuple})
  return check_similartype_output(Base.promote_op(similar, arrayt, axt))
end
function similartype(a::AbstractArray, ax::Tuple)
  return similartype(typeof(a), typeof(ax))
end

# similartype(typeof(a), ax)
function similartype(arraytt::Type{<:Type{<:AbstractArray}}, axt::Type{<:Tuple})
  return check_similartype_output(Base.promote_op(similar, arraytt, axt))
end
function similartype(arrayt::Type{<:AbstractArray}, ax::Tuple)
  return similartype(Type{arrayt}, typeof(ax))
end

# similartype(a)
function similartype(arrayt::Type{<:AbstractArray})
  return check_similartype_output(Base.promote_op(similar, arrayt))
end
function similartype(a::AbstractArray)
  return similartype(typeof(a))
end
