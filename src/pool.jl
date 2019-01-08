export Pool


struct Pool{T}
    ids::Dict{T,UInt}
    lookup::Vector{T}
    Pool{T}() where {T} = new{T}(Dict{T,UInt}(), T[])
end

Base.push!(p::Pool{T}, ex) where {T} = push!(p, convert(Pattern{T}, ex))
function Base.push!(p::Pool, t::Term)
    isa(t.head, Variable) && return Term{Variable}(t.head, t.args)
    return Term(to_pool!(p, t.head), push!.(p, t.args))
end
function Base.getindex(p::Pool{T}, t::Term) where {T}
    isa(t.head, Variable) && return Pattern{T}(t.head, t.args)
    return Pattern{T}(from_pool(p, t.head), getindex.(p, t.args))
end

Base.broadcastable(p::Pool) = Ref(p)


function to_pool!(p::Pool, x)
    haskey(p.ids, x) && return p.ids[x]

    push!(p.lookup, x)
    index = UInt(length(p.lookup))
    p.ids[x] = index
    return index
end
from_pool(p::Pool, x) = isa(x, UInt) ? p.lookup[x] : x
