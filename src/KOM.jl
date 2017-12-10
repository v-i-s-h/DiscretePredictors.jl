# Kth Order Markov Model

type KOM{T} <: BasePredictor{T}
    model::Trie{T,Int64}
    context::Vector{T}
    cxt_length::Int64

    KOM{T}( _c::Int ) where {T} = new( Trie{T,Int64}(), Vector{T}(), _c )
    # (::Type{KOM{T}}){T}(_c::Int64) = new{T}( Trie{T,Int64}(), Vector{T}(), _c );
end

function add!{T}( p::KOM{T}, sym::T )
    p.model.value += 1;

    # Create node path
    push!( p.context, sym );
    buffer  = p.context[1:end];
    while !isempty(buffer)
        p.model[buffer] = (haskey(p.model,buffer))? p.model[buffer]+1: 1;
        shift!( buffer )
    end

    if length(p.context) > p.cxt_length
        shift!( p.context )
    end
end

function predict{T}( p::KOM{T} )
    # Create a dictionary with symbols
    symbols = Dict( k => (p.model[[k]]/p.model.value) for k ∈ keys(children(p.model,Vector{T}())) );

    buffer  = Vector{T}();
    for i = length(p.context):-1:1
        unshift!( buffer, p.context[i] );
        # println( "    Buffer: ", buffer, " -> ", p.model[buffer] );
        # Apply escape probability
        esc_prob = 1/p.model[buffer];
        for symbol in keys(symbols)
            symbols[symbol] *= esc_prob;
        end
        # Get each child probability
        list_of_children    = children( p.model, buffer );
        for k ∈ keys(list_of_children)
            # println( "        ", k, " -> ", list_of_children[k].value )
            symbols[k] += list_of_children[k].value/p.model[buffer];
        end
    end

    return symbols;
end

function info_string{T}( p::KOM{T} )
    return @sprintf( "KOM(%d)", p.cxt_length );
end

function unique_string{T}( p::KOM{T} )
    return @sprintf( "KOM_%02d", p.cxt_length );
end
