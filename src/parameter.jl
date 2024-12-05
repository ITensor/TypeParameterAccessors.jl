@inline parameter(type::Type, pos) = parameter(type, position(type, pos))
@inline parameter(type::Type, pos::Position) = parameters(type)[Int(pos)]
@inline parameter(type::Type) = only(parameters(type))
