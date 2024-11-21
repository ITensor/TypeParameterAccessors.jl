var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = TypeParameterAccessors","category":"page"},{"location":"#TypeParameterAccessors","page":"Home","title":"TypeParameterAccessors","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for TypeParameterAccessors.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [TypeParameterAccessors]","category":"page"},{"location":"#TypeParameterAccessors.default_type_parameters","page":"Home","title":"TypeParameterAccessors.default_type_parameters","text":"default_parameters(type::Type)::Tuple\n\nAn optional interface function. Defining this allows filling type parameters of the specified type with default values.\n\nThis function should output a Tuple of the default values, with exactly one for each type parameter slot of the type.\n\n\n\n\n\n","category":"function"},{"location":"#TypeParameterAccessors.position","page":"Home","title":"TypeParameterAccessors.position","text":"position(type::Type, position_name)::Position\n\nAn optional interface function. Defining this allows accessing a parameter at the defined position using the position_name.\n\nFor example, defining TypeParameterAccessors.position(::Type{<:MyType}, ::typeof(eltype)) = Position(1) allows accessing the first type parameter with type_parameter(MyType(...), eltype), in addition to the standard type_parameter(MyType(...), 1) or type_parameter(MyType(...), Position(1)).\n\n\n\n\n\n","category":"function"},{"location":"#TypeParameterAccessors.set_indstype-Tuple{Type{<:AbstractArray}, Tuple}","page":"Home","title":"TypeParameterAccessors.set_indstype","text":"set_indstype should be overloaded for types with structured dimensions, like OffsetArrays or named indices (such as ITensors).\n\n\n\n\n\n","category":"method"}]
}
