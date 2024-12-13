```@meta
CurrentModule = TypeParameterAccessors
```

# Type interface

The low-level interface of this package is centered around the ability to _get_, _set_ and _specify_ the type parameters of a given type.
```@setup type_parameters
using TypeParameterAccessors
```

## Type Parameters

The central concept in this package is a type parameter, which refers to the variables `A, B, ...` in type definitions:

```@example type_parameters
abstract type Foo{A,B,C,D} end
struct Bar{A,B,C,D} end
```

In order to retrieve these parameters, [`type_parameters`](@ref) can be used, either to retrieve all parameters, or a single one:

```@repl type_parameters
type_parameters(Foo{1,2,3,4})
type_parameters(Foo{1,2,3,4}, 2)
type_parameters(Bar{:A,Int,2,Foo})
type_parameters(Bar{:A,Int,2,Foo}, 4)
```

!!! warning

    For consistency reasons, as well as due to the type system in Julia, these positions will always refer to the *base type*.
    This means in particular that using positional type parameters in combination with type aliases can lead to unexpected results.
    For example, `const Foo_alias{D,C,B,A} = Foo{A,B,C,D}` would still have `type_parameters(Foo_alias) == (A, B, C, D)`.

In order to effectively pass on the information about _which_ type parameter we want to manipulate, it can often be convenient to refer to type parameters not by their position, but rather by their meaning.
In particular, this allows users to write more generic code, since the positions of type parameters have no special meaning in the Julia type system.
Additionally, this avoids the unexpected results caused by type aliases.
Often, these parameters have an associated function to retrieve them, such as `eltype` or `ndims`.
Therefore, the following syntax is also supported (and in general preferred):

```@repl type_parameters
type_parameters(Array{Int,2}, ndims)
type_parameters(Vector{Float64}, eltype)
```

This can not automatically be inferred for custom types however:
```@repl type_parameters
type_parameters(Bar{1}, ndims) # errors because `ndims` is not registered
```

In order to support this, we internally pass everything through [`position`](@ref), which can be used to bind functions to positions.
For type stability reasons, it is beneficial to return the static [`TypeParameterAccessors.Position`](@ref) instead of a regular integer.

```@repl type_parameters
TypeParameterAccessors.position(::Type{<:Bar}, ::typeof(ndims)) = TypeParameterAccessors.Position(1)
type_parameters(Bar{1}, ndims)
```

!!! warning

    While it might be tempting to define such functions for abstract types, this is in general not a good practice.
    The reason for this is again that the position of a specific type parameter is not something that is inherited by subtypes, which may decide to change the number as well as the order of the type parameters.

## Setting Type Parameters

In a similar manner, it is also possible to alter the type parameters of a given type.
That functionality is provided by [`set_type_parameters`](@ref):

```@repl type_parameters
set_type_parameter(Foo{1,2,3}, 4, :four)
set_type_parameters(Foo{1,2,3,4}, (1,3), (:A, :B))
```

## Specifying and Unspecifying Type Parameters

Finally, sometimes it is either required or useful to work with `UnionAll` types.
These have type parameters that are either not specified or only bounded.
For example, `Foo` is really a shorthand form of `Foo{A,B,C,D} where {A,B,C,D}`.
Starting from a *specified* type, you can go back to the unspecified form by unspecifying either some or all of the type parameters through [`unspecify_type_parameters`](@ref).

```@repl type_parameters
unspecify_type_parameters(Foo{1,2,3,4})
unspecify_type_parameters(Foo{1,2,3,4}, (1, 3))
unspecify_type_parameter(Foo{1,2,3,4}, 1)
```

Similarly, it is possible to set type parameters that have not been fully specified through [`specify_type_parameters`](@ref).

```@repl type_parameters
specify_type_parameters(Foo, (1, 2), (:A, Int))
specify_type_parameter(Foo{1,2,3}, 4, 4)
```

Note that this function differs from [`set_type_parameters`](@ref) only by ignoring type parameters that have not been specified:

```@repl type_parameters
set_type_parameters(Foo{1,2,3}, (1, 4), (Int, Int))
specify_type_parameters(Foo{1,2,3}, (1, 4), (Int, Int))
```

## Default Type Parameters

Finally, it can sometimes be convenient to have default values for type parameters.
This can be achieved by registering the default values through [`default_type_parameters`](@ref), and then setting or specifying them through [`set_default_type_parameters`](@ref) and [`specify_default_type_parameters`](@ref).

```@repl type_parameters
TypeParameterAccessors.default_type_parameters(::Type{<:Bar}) = (1, 2, 3, 4)
set_default_type_parameters(Bar)
specify_default_type_parameters(Bar{1,2}, (3, 4))
```
