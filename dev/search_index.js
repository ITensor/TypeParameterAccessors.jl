var documenterSearchIndex = {"docs":
[{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"CurrentModule = TypeParameterAccessors","category":"page"},{"location":"type_interface/#Type-interface","page":"Type parameters","title":"Type interface","text":"","category":"section"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"The low-level interface of this package is centered around the ability to get, set and specify the type parameters of a given type.","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"using TypeParameterAccessors","category":"page"},{"location":"type_interface/#Type-Parameters","page":"Type parameters","title":"Type Parameters","text":"","category":"section"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"The central concept in this package is a type parameter, which refers to the variables A, B, ... in type definitions:","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"abstract type Foo{A,B,C,D} end\nstruct Bar{A,B,C,D} end","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"In order to retrieve these parameters, type_parameters can be used, either to retrieve all parameters, or a single one:","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"type_parameters(Foo{1,2,3,4})\ntype_parameters(Foo{1,2,3,4}, 2)\ntype_parameters(Bar{:A,Int,2,Foo})\ntype_parameters(Bar{:A,Int,2,Foo}, 4)","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"warning: Warning\nFor consistency reasons, as well as due to the type system in Julia, these positions will always refer to the base type. This means in particular that using positional type parameters in combination with type aliases can lead to unexpected results. For example, const Foo_alias{D,C,B,A} = Foo{A,B,C,D} would still have type_parameters(Foo_alias) == (A, B, C, D).","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"In order to effectively pass on the information about which type parameter we want to manipulate, it can often be convenient to refer to type parameters not by their position, but rather by their meaning. In particular, this allows users to write more generic code, since the positions of type parameters have no special meaning in the Julia type system. Additionally, this avoids the unexpected results caused by type aliases. Often, these parameters have an associated function to retrieve them, such as eltype or ndims. Therefore, the following syntax is also supported (and in general preferred):","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"type_parameters(Array{Int,2}, ndims)\ntype_parameters(Vector{Float64}, eltype)","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"This can not automatically be inferred for custom types however:","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"type_parameters(Bar{1}, ndims) # errors because `ndims` is not registered","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"In order to support this, we internally pass everything through position, which can be used to bind functions to positions. For type stability reasons, it is beneficial to return the static TypeParameterAccessors.Position instead of a regular integer.","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"TypeParameterAccessors.position(::Type{<:Bar}, ::typeof(ndims)) = TypeParameterAccessors.Position(1)\ntype_parameters(Bar{1}, ndims)","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"warning: Warning\nWhile it might be tempting to define such functions for abstract types, this is in general not a good practice. The reason for this is again that the position of a specific type parameter is not something that is inherited by subtypes, which may decide to change the number as well as the order of the type parameters.","category":"page"},{"location":"type_interface/#Setting-Type-Parameters","page":"Type parameters","title":"Setting Type Parameters","text":"","category":"section"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"In a similar manner, it is also possible to alter the type parameters of a given type. That functionality is provided by set_type_parameters:","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"set_type_parameters(Foo{1,2,3}, 4, :four)\nset_type_parameters(Foo{1,2,3,4}, (1,3), (:A, :B))","category":"page"},{"location":"type_interface/#Specifying-and-Unspecifying-Type-Parameters","page":"Type parameters","title":"Specifying and Unspecifying Type Parameters","text":"","category":"section"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"Finally, sometimes it is either required or useful to work with UnionAll types. These have type parameters that are either not specified or only bounded. For example, Foo is really a shorthand form of Foo{A,B,C,D} where {A,B,C,D}. Starting from a specified type, you can go back to the unspecified form by unspecifying either some or all of the type parameters through unspecify_type_parameters.","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"unspecify_type_parameters(Foo{1,2,3,4})\nunspecify_type_parameters(Foo{1,2,3,4}, 1)\nunspecify_type_parameters(Foo{1,2,3,4}, (1, 3))","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"Similarly, it is possible to set type parameters that have not been fully specified through specify_type_parameters.","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"specify_type_parameter(Foo{1,2,3}, 4, 4)\nspecify_type_parameters(Foo, (1, 2), (:A, Int))","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"Note that this function differs from set_type_parameters only by ignoring type parameters that have not been specified:","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"set_type_parameters(Foo{1,2,3}, (1, 4), (Int, Int))\nspecify_type_parameters(Foo{1,2,3}, (1, 4), (Int, Int))","category":"page"},{"location":"type_interface/#Default-Type-Parameters","page":"Type parameters","title":"Default Type Parameters","text":"","category":"section"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"Finally, it can sometimes be convenient to have default values for type parameters. This can be achieved by registering the default values through default_type_parameters, and then setting or specifying them through set_default_type_parameters and specify_default_type_parameters.","category":"page"},{"location":"type_interface/","page":"Type parameters","title":"Type parameters","text":"TypeParameterAccessors.default_type_parameters(::Type{<:Bar}) = (1, 2, 3, 4)\nset_default_type_parameters(Bar)\nspecify_default_type_parameters(Bar{1,2}, (3, 4))","category":"page"},{"location":"lib/","page":"Library","title":"Library","text":"CurrentModule = TypeParameterAccessors","category":"page"},{"location":"lib/#Index","page":"Library","title":"Index","text":"","category":"section"},{"location":"lib/","page":"Library","title":"Library","text":"Docstrings for the TypeParameterAccessors.jl public API.","category":"page"},{"location":"lib/#Contents","page":"Library","title":"Contents","text":"","category":"section"},{"location":"lib/","page":"Library","title":"Library","text":"Pages = [\"index.md\"]\nDepth = 2:2","category":"page"},{"location":"lib/#Index-2","page":"Library","title":"Index","text":"","category":"section"},{"location":"lib/","page":"Library","title":"Library","text":"Pages = [\"index.md\"]","category":"page"},{"location":"lib/#Type-parameter-interface","page":"Library","title":"Type parameter interface","text":"","category":"section"},{"location":"lib/","page":"Library","title":"Library","text":"position\nPosition\ntype_parameters\ndefault_type_parameters\nnparameters\nis_parameter_specified\nunspecify_type_parameters\nset_type_parameters\nset_default_type_parameters\nspecify_type_parameters\nspecify_default_type_parameters","category":"page"},{"location":"lib/#TypeParameterAccessors.position","page":"Library","title":"TypeParameterAccessors.position","text":"position(type::Type, position_name)::Position\n\nAn optional interface function. Defining this allows accessing a parameter at the defined position using the position_name.\n\nFor example, defining TypeParameterAccessors.position(::Type{<:MyType}, ::typeof(eltype)) = Position(1) allows accessing the first type parameter with type_parameters(MyType(...), eltype), in addition to the standard type_parameters(MyType(...), 1) or type_parameters(MyType(...), Position(1)).\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.Position","page":"Library","title":"TypeParameterAccessors.Position","text":"struct Position{P} end\n\nSingleton type to statically represent the type-parameter position. This is meant for internal use as a Val-like structure to improve type-inference.\n\n\n\n\n\n","category":"type"},{"location":"lib/#TypeParameterAccessors.type_parameters","page":"Library","title":"TypeParameterAccessors.type_parameters","text":"typeparameters(typeor_obj, [pos])\n\nReturn a tuple containing the type parameters of a given type or object. Optionally you can specify a position to just get the parameter for that position.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.default_type_parameters","page":"Library","title":"TypeParameterAccessors.default_type_parameters","text":"defaulttypeparameters(type::Type)::Tuple\n\nAn optional interface function. Defining this allows filling type parameters of the specified type with default values.\n\nThis function should output a Tuple of the default values, with exactly one for each type parameter slot of the type.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.nparameters","page":"Library","title":"TypeParameterAccessors.nparameters","text":"nparameters(typeorobj)\n\nReturn the number of type parameters for a given type or object.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.is_parameter_specified","page":"Library","title":"TypeParameterAccessors.is_parameter_specified","text":"isparameterspecified(type::Type, pos)\n\nReturn whether or not the type parameter at a given position is considered specified.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.unspecify_type_parameters","page":"Library","title":"TypeParameterAccessors.unspecify_type_parameters","text":"unspecifytypeparameters(type::Type, [positions::Tuple])   unspecifytypeparameters(type::Type, position)\n\nReturn a new type where the type parameters at the given positions are unset.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.set_type_parameters","page":"Library","title":"TypeParameterAccessors.set_type_parameters","text":"settypeparameters(type::Type, positions::Tuple, parameters::Tuple)   settypeparameters(type::Type, position, parameter)\n\nReturn a new type where the type parameters at the given positions are set to the provided values.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.set_default_type_parameters","page":"Library","title":"TypeParameterAccessors.set_default_type_parameters","text":"setdefaulttypeparameters(type::Type, [positions::Tuple])   setdefaulttypeparameters(type::Type, position)\n\nSet the type parameters at the given positions to their default values.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.specify_type_parameters","page":"Library","title":"TypeParameterAccessors.specify_type_parameters","text":"specifytypeparameters(type::Type, positions::Tuple, parameters::Tuple)   specifytypeparameters(type::Type, position, parameter)\n\nReturn a new type where the type parameters at the given positions are set to the provided values, only if they were previously unspecified.\n\n\n\n\n\n","category":"function"},{"location":"lib/#TypeParameterAccessors.specify_default_type_parameters","page":"Library","title":"TypeParameterAccessors.specify_default_type_parameters","text":"specifydefaulttypeparameters(type::Type, [positions::Tuple])   specifydefaulttypeparameters(type::Type, position)\n\nSet the type parameters at the given positions to their default values, if they had not been specified.\n\n\n\n\n\n","category":"function"},{"location":"lib/#Array-type-tools","page":"Library","title":"Array-type tools","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"EditURL = \"../../examples/README.jl\"","category":"page"},{"location":"#TypeParameterAccessors.jl","page":"Home","title":"TypeParameterAccessors.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: Stable) (Image: Dev) (Image: Build Status) (Image: Coverage) (Image: Code Style: Blue) (Image: Aqua)","category":"page"},{"location":"#Installation-instructions","page":"Home","title":"Installation instructions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package resides in the ITensor/ITensorRegistry local registry. In order to install, simply add that registry through your package manager. This step is only required once.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Pkg: Pkg\n\njulia> Pkg.Registry.add(url=\"https://github.com/ITensor/ITensorRegistry\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"or:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> Pkg.Registry.add(url=\"git@github.com:ITensor/ITensorRegistry.git\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"if you want to use SSH credentials, which can make it so you don't have to enter your Github ursername and password when registering packages.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Then, the package can be added as usual through the package manager:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> Pkg.add(\"TypeParameterAccessors\")","category":"page"},{"location":"#Examples","page":"Home","title":"Examples","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using Test: @test\nusing TypeParameterAccessors","category":"page"},{"location":"","page":"Home","title":"Home","text":"Getting type parameters","category":"page"},{"location":"","page":"Home","title":"Home","text":"@test type_parameters(Array{Float64}, 1) == Float64\n@test type_parameters(Matrix{Float64}, 2) == 2\n@test type_parameters(Matrix{Float64}) == (Float64, 2)\n@test type_parameters(Array{Float64}, eltype) == Float64\n@test type_parameters(Matrix{Float64}, ndims) == 2\n@test type_parameters.(Matrix{Float64}, (eltype, ndims)) == (Float64, 2)","category":"page"},{"location":"","page":"Home","title":"Home","text":"Setting type parameters","category":"page"},{"location":"","page":"Home","title":"Home","text":"@test set_type_parameters(Array, 1, Float32) == Array{Float32}\n@test set_type_parameters(Array, (1,), (Float32,)) == Array{Float32}\n@test set_type_parameters(Array, (1, 2), (Float32, 2)) == Matrix{Float32}\n@test set_type_parameters(Array, (eltype,), (Float32,)) == Array{Float32}\n@test set_type_parameters(Array, (eltype, ndims), (Float32, 2)) == Matrix{Float32}","category":"page"},{"location":"","page":"Home","title":"Home","text":"Specifying type parameters","category":"page"},{"location":"","page":"Home","title":"Home","text":"@test specify_type_parameters(Array{Float64}, (eltype, ndims), (Float32, 2)) ==\n  Matrix{Float64}\n@test specify_type_parameters(Array{Float64}, ndims, 2) == Matrix{Float64}\n@test specify_type_parameters(Array{Float64}, eltype, Float32) == Array{Float64}","category":"page"},{"location":"","page":"Home","title":"Home","text":"Unspecifying type parameters","category":"page"},{"location":"","page":"Home","title":"Home","text":"@test unspecify_type_parameters(Matrix{Float32}) == Array\n@test unspecify_type_parameters(Matrix{Float32}, 1) == Matrix\n@test unspecify_type_parameters(Matrix{Float32}, (eltype,)) == Matrix\n@test unspecify_type_parameters(Matrix{Float32}, (ndims,)) == Array{Float32}","category":"page"},{"location":"","page":"Home","title":"Home","text":"Getting default type parameters","category":"page"},{"location":"","page":"Home","title":"Home","text":"@test default_type_parameters(Array) == (Float64, 1)\n@test default_type_parameters(Array, eltype) == Float64\n@test default_type_parameters(Array, 2) == 1","category":"page"},{"location":"","page":"Home","title":"Home","text":"Setting default type parameters","category":"page"},{"location":"","page":"Home","title":"Home","text":"@test set_default_type_parameters(Array) == Vector{Float64}\n@test set_default_type_parameters(Array, (eltype,)) == Array{Float64}\n@test set_default_type_parameters(Array, 2) == Vector","category":"page"},{"location":"","page":"Home","title":"Home","text":"Specifying default type parameters","category":"page"},{"location":"","page":"Home","title":"Home","text":"@test specify_default_type_parameters(Matrix, (eltype, ndims)) == Matrix{Float64}\n@test specify_default_type_parameters(Matrix, eltype) == Matrix{Float64}\n@test specify_default_type_parameters(Array{Float32}, (eltype, ndims)) == Vector{Float32}","category":"page"},{"location":"","page":"Home","title":"Home","text":"Other functionality","category":"page"},{"location":"","page":"Home","title":"Home","text":"parenttype\nunwrap_array_type\nis_wrapped_array\nset_eltype\nset_ndims\nset_parenttype\nsimilartype","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"This page was generated using Literate.jl.","category":"page"}]
}