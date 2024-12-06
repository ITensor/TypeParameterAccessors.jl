"replace `Symbol`s with `QuoteNode`s to avoid expression interpolation"
wrap_symbol_quotenode(param) = param isa Symbol ? QuoteNode(param) : param

"Construct the expression for qualifying a type with given parameters"
function construct_type_ex(type, parameters)
  basetype = unspecify_type_parameters(type)
  type_ex = Expr(:curly, basetype, wrap_symbol_quotenode.(parameters)...)
  for parameter in reverse(parameters)
    if parameter isa TypeVar
      type_ex = Expr(:call, :UnionAll, parameter, type_ex)
    end
  end
  return type_ex
end
