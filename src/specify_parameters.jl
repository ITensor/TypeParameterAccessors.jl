@inline function specify_type_parameter(type::Type, pos, param)
  return specify_type_parameters(type, (pos,), param)
end

# function _specify_type_parameters(type::Type, positions::Tuple{Vararg{Int}}, params::Tuple)
#   new_params = parameters(type)
#   for i in 1:length(positions)
#     if !is_parameter_specified(type, positions[i])
#       new_params = Base.setindex(new_params, params[i], positions[i])
#     end
#   end
#   return new_parameters(type, new_params)
# end
# @generated function specify_type_parameters(
#   type_type::Type,
#   positions_type::Tuple{Vararg{Position}},
#   params_type::Tuple{Vararg{TypeParameter}},
# )
#   type = parameter(type_type)
#   positions = parameter.(parameters(positions_type))
#   params = parameter.(parameters(params_type))
#   return _specify_type_parameters(type, positions, params)
# end
# function specify_type_parameters(type::Type, positions::Tuple, params::Tuple)
#   return specify_type_parameters(type, position.(type, positions), params)
# end
# function specify_type_parameters(type::Type, params::Tuple)
#   return specify_type_parameters(type, eachposition(type), params)
# end
Base.@constprop :aggressive function specify_type_parameters(
  type::Type, positions::Tuple, params...
)
  @inline
  return __specify_type_parameters(type, Val(positions), params...)
end
Base.@constprop :aggressive function specify_type_parameters(type::Type, params::Tuple)
  @inline
  return specify_type_parameters(type, ntuple(identity, length(params)), params...)
end

@generated function __specify_type_parameters(
  ::Type{type}, ::Val{positions}, params...
) where {type,positions}

  # collect all parameters and change out the specified ones
  allparams = collect(Any, parameters(type))
  for (i, _pos) in enumerate(positions)
    pos = parameter(typeof(position(type, _pos)))
    if !is_parameter_specified(type, pos)
      allparams[pos] = :(params[$i])
    end
  end

  # wrap Symbols in QuoteNode to avoid them being interpolated
  allparams = map(allparams) do p
    p isa Symbol ? QuoteNode(p) : p
  end

  # construct expression for new type
  basetype = unspecify_type_parameters(type)
  type_expr = Expr(:curly, basetype, allparams...)
  for param in reverse(allparams)
    if param isa TypeVar
      type_expr = Expr(:call, :UnionAll, param, type_expr)
    end
  end
  return :(@inline; $type_expr)
end
