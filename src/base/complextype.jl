for f in [:complex, :real]
    ftype = Symbol(f, :type)
    @eval begin
        $ftype(a::AbstractArray) = $ftype(typeof(a))
        function $ftype(A::Type{<:AbstractArray})
            return Base.promote_op($f, A)
        end
        $ftype(x::Number) = $f(typeof(x))
        $ftype(::Type{T}) where {T <: Number} = $f(T)
        $ftype(::Type{<:Type{T}}) where {T <: Number} = $f(T)
    end
end

imagtype(a::AbstractArray) = imagtype(typeof(a))
function imagtype(A::Type{<:AbstractArray})
    return Base.promote_op(imag, A)
end
imagtype(x::Number) = imagtype(typeof(x))
# This works around the fact that `imag(::Type{<:Number})`
# isn't defined in `Base`.
imagtype(::Type{T}) where {T <: Number} = Base.promote_op(imag, T)
imagtype(::Type{<:Type{T}}) where {T <: Number} = imagtype(T)
