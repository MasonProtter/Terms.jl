function expr_to_term(T, x, f = _expr_static)
    isa(x, Expr) || return Term{f(T, x)}(x, Term{T}[])

    args = similar(x.args, Term{T})
    for i ∈ eachindex(x.args)
        args[i] = expr_to_term(T, x.args[i])
    end
    return Term{f(T, x.head)}(x.head, args)
end
_expr_static(T, x) = T
_expr_build(T, x) = promote_type(T, typeof(x))


function term_to_expr(t::Term)
    isempty(t.args) && return t.head
    isa(t.head, Symbol) || throw(ArgumentError("invalid `Expr` head ($(t.head))"))

    expr = Expr(t.head)
    append!(expr.args, term_to_expr.(t.args))
    return expr
end
