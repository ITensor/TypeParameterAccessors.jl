function _set_type_parameter(type::Type, pos::Int, param)
  params = Base.setindex(parameters(type), param, pos)
  return new_parameters(type, params)
end
@generated function set_type_parameter(
  type_type::Type, pos_type::Position, param_type::TypeParameter
)
  type = parameter(type_type)
  pos = parameter(pos_type)
  param = parameter(param_type)
  return _set_type_parameter(type, pos, param)
end
@inline function set_type_parameter(type::Type, pos, param)
  return set_type_parameter(type, position(type, pos), param)
end
@inline function set_type_parameter(type::Type, pos::Position, param)
  return set_type_parameter(type, pos, TypeParameter(param))
end
function set_type_parameter(type::Type, pos::Position, param::UnspecifiedTypeParameter)
  return unspecify_type_parameter(type, pos)
end

Base.@constprop :aggressive function set_type_parameters(
  type::Type, positions::Tuple, params...
)
  @inline
  return __set_type_parameters(type, Val(positions), params...)
end
Base.@constprop :aggressive function set_type_parameters(type::Type, params::Tuple)
  @inline
  return set_type_parameters(type, ntuple(identity, length(params)), params...)
end

@generated function __set_type_parameters(
  ::Type{type}, ::Val{positions}, params...
) where {type,positions}

  # collect all parameters and change out the specified ones
  allparams = collect(Any, parameters(type))
  for (i, _pos) in enumerate(positions)
    pos = parameter(typeof(position(type, _pos)))
    allparams[pos] = :(params[$i])
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
