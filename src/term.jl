export Term


struct Term{T}
    head::T
    args::Vector{Term{T}}
end
Term{T}(head) where {T} = Term{T}(head, T[])
Term(head::T) where {T} = Term{T}(head, T[])
Term(head::T, args::Vector{Term{U}}) where {T,U} = Term{promote_type(T,U)}(head, args)
function Term(head, args)
    isempty(args) && return Term(head)
    args_ = convert.(Term, args)::Vector{Term}
    # args_ = map(x -> convert(Term, x), args)
    Term(head, collect(promote(args_...)))
end

Base.:(==)(s::Term, t::Term) = (s.head, s.args) == (t.head, t.args)

Base.convert(::Type{Term}, ex) = expr_to_term(Union{}, ex, _expr_build)
Base.convert(::Type{Term}, t::Term) = t
Base.convert(::Type{Term{T}}, ex) where {T} = expr_to_term(T, ex)
Base.convert(::Type{Term{T}}, t::Term) where {T} = Term{T}(t.head, t.args)

Base.convert(::Type{Expr}, t::Term) = term_to_expr(t)

Base.promote_rule(::Type{Term{S}}, ::Type{Term{T}}) where {S,T} = Term{promote_type(S,T)}
