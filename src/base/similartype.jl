function check_similartype_output(type::Type)
    isconcretetype(type) || error(
        "`similartype` output `$type`, which is not concrete. The corresponding call to `similar` may not be defined or may not be type stable.",
    )
    return type
end

@doc """
    similartype(A, [elt], [shape])
    similartype(typeof(A), [typeof(elt)], [typeof(shape)])

    similartype(typeof(A), shape)
    similartype(typeof(typeof(A)), typeof(shape))

Compute the type that is returned by calling `Base.similar` on the given arguments.
You can either pass instances or types.

Note that by default the versions taking arguments call the versions taking types,
so it is recommended to overload the versions taking types. Note that the versions with different
argument combinations, for example `similartype(A)`, `similartype(A, elt)`, `similartype(A, shape)`,
and `similartype(A, elt, shape)`, are separate codepaths, unlike some implementations of `similar`,
so they should be customized separately if needed.

!!! warning
    The fallback definition for this function uses `Base.promote_op(similar, args...)`,
    so new implementations of `similar` cannot use this function to determine the output
    type without also implementing `similartype`. Additionally, getting a result that
    is a concrete type requires that the corresponding `similar` call is type stable.
"""
similartype

# similartype(a, elt, ax)
function similartype(arrayt::Type, eltt::Type{<:Type}, axt::Type{<:Tuple})
    return check_similartype_output(Base.promote_op(similar, arrayt, eltt, axt))
end
function similartype(arrayt::Type, elt::Type, ax::Tuple)
    return similartype(arrayt, Type{elt}, typeof(ax))
end
function similartype(a, elt::Type, ax::Tuple)
    return similartype(typeof(a), Type{elt}, typeof(ax))
end

# similartype(a, elt)
function similartype(arrayt::Type, eltt::Type{<:Type})
    return check_similartype_output(Base.promote_op(similar, arrayt, eltt))
end
function similartype(arrayt::Type, elt::Type)
    return similartype(arrayt, Type{elt})
end
function similartype(a, elt::Type)
    return similartype(typeof(a), Type{elt})
end

# similartype(a, ax)
function similartype(arrayt::Type, axt::Type{<:Tuple})
    return check_similartype_output(Base.promote_op(similar, arrayt, axt))
end
function similartype(a, ax::Tuple)
    return similartype(typeof(a), typeof(ax))
end

# similartype(typeof(a), ax)
function similartype(arraytt::Type{<:Type}, axt::Type{<:Tuple})
    return check_similartype_output(Base.promote_op(similar, arraytt, axt))
end
function similartype(arrayt::Type, ax::Tuple)
    return similartype(Type{arrayt}, typeof(ax))
end

# similartype(a)
function similartype(arrayt::Type)
    return check_similartype_output(Base.promote_op(similar, arrayt))
end
function similartype(a)
    return similartype(typeof(a))
end
