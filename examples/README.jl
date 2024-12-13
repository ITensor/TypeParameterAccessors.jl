# # TypeParameterAccessors.jl
# 
# [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ITensor.github.io/TypeParameterAccessors.jl/stable/)
# [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ITensor.github.io/TypeParameterAccessors.jl/dev/)
# [![Build Status](https://github.com/ITensor/TypeParameterAccessors.jl/actions/workflows/Tests.yml/badge.svg?branch=main)](https://github.com/ITensor/TypeParameterAccessors.jl/actions/workflows/Tests.yml?query=branch%3Amain)
# [![Coverage](https://codecov.io/gh/ITensor/TypeParameterAccessors.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/ITensor/TypeParameterAccessors.jl)
# [![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
# [![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

# ## Installation instructions

# This package resides in the `ITensor/ITensorRegistry` local registry.
# In order to install, simply add that registry through your package manager.
# This step is only required once.
#=
```julia
julia> using Pkg: Pkg

julia> Pkg.Registry.add(url="https://github.com/ITensor/ITensorRegistry")
```
=#
# or:
#=
```julia
julia> Pkg.Registry.add(url="git@github.com:ITensor/ITensorRegistry.git")
```
=#
# if you want to use SSH credentials, which can make it so you don't have to enter your Github ursername and password when registering packages.

# Then, the package can be added as usual through the package manager:

#=
```julia
julia> Pkg.add("TypeParameterAccessors")
```
=#

# ## Examples

using Test: @test
using TypeParameterAccessors

# Getting type parameters
@test type_parameters(Array{Float64}, 1) == Float64
@test type_parameters(Matrix{Float64}, 2) == 2
@test type_parameters(Matrix{Float64}) == (Float64, 2)
@test type_parameters(Array{Float64}, eltype) == Float64
@test type_parameters(Matrix{Float64}, ndims) == 2
@test type_parameters.(Matrix{Float64}, (eltype, ndims)) == (Float64, 2)

# Setting type parameters
@test set_type_parameters(Array, 1, Float32) == Array{Float32}
@test set_type_parameters(Array, (1,), (Float32,)) == Array{Float32}
@test set_type_parameters(Array, (1, 2), (Float32, 2)) == Matrix{Float32}
@test set_type_parameters(Array, (eltype,), (Float32,)) == Array{Float32}
@test set_type_parameters(Array, (eltype, ndims), (Float32, 2)) == Matrix{Float32}

# Specifying type parameters
@test specify_type_parameters(Array{Float64}, (eltype, ndims), (Float32, 2)) ==
      Matrix{Float64}
@test specify_type_parameters(Array{Float64}, ndims, 2) == Matrix{Float64}
@test specify_type_parameters(Array{Float64}, eltype, Float32) == Array{Float64}

# Unspecifying type parameters
@test unspecify_type_parameters(Matrix{Float32}) == Array
@test unspecify_type_parameters(Matrix{Float32}, 1) == Matrix
@test unspecify_type_parameters(Matrix{Float32}, (eltype,)) == Matrix
@test unspecify_type_parameters(Matrix{Float32}, (ndims,)) == Array{Float32}

# Getting default type parameters
@test default_type_parameters(Array) == (Float64, 1)
@test default_type_parameters(Array, eltype) == Float64
@test default_type_parameters(Array, 2) == 1

# Setting default type parameters
@test set_default_type_parameters(Array) == Vector{Float64}
@test set_default_type_parameters(Array, (eltype,)) == Array{Float64}
@test set_default_type_parameters(Array, 2) == Vector

# Specifying default type parameters
@test specify_default_type_parameters(Matrix, (eltype, ndims)) == Matrix{Float64}
@test specify_default_type_parameters(Matrix, eltype) == Matrix{Float64}
@test specify_default_type_parameters(Array{Float32}, (eltype, ndims)) == Vector{Float32}

# Other functionality
#
# - `parenttype`
# - `unwrap_array_type`
# - `is_wrapped_array`
# - `set_eltype`
# - `set_ndims`
# - `set_parenttype`
# - `similartype`
