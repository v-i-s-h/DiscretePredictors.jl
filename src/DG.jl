# Dependency Graph is a predictor based on Variable order Markov Chains
# Based on: Padmanabhan, V. N., & Mogul, J. C. (1996). Using predictive prefetching to improve World Wide Web latency. ACM SIGCOMM Computer Communication Review, 26(3), 22–36. http://doi.org/10.1145/235160.235164

type DG{T} <: BasePredictor{T}
    model::Trie{T,Int64}
    window::Vector{T}
    win_length::Int64

    DG{T}( _c::Int ) where {T} = new( Trie{T,Int64}(), Vector{T}(), _c );
    # (::Type{DG{T}}){T}( _c::Int )   = new{T}( Trie{T,Int64}(), Vector{T}(), _c );
end

function add!{T}( p::DG{T}, sym::T )
    p.model.value += 1;
    # Check if this symbol is new
    if sym ∉ keys(p.model.children)
        p.model[[sym]]  = 0;    # Start with a support of 0
    end

    for s ∈ p.window
        if haskey( p.model, [s;sym] )
            p.model[[s;sym]]    += 1;   # Increment occurence
            p.model[[s]]        += 1;        # Increment support
        else
            p.model[[s;sym]]    = 1;    # Create new node
            p.model[[s]]        += 1;        # Increment support
        end
    end

    push!( p.window, sym );   # Add this symbol to window
    if length(p.window) > p.win_length    # Trim window
        shift!( p.window );     # Discard oldest symbol
    end
end

function predict{T}( p::DG{T} )
    # Create a dictionary with symbols
    symbols = Dict( k => 0.0 for k ∈ keys(children(p.model,Vector{T}())) );
    if isempty(symbols)
        # Just return all symbols with equal probability
        prob    = 1.0 / length( keys(symbols) );
        for s ∈ keys(symbols)
            symbols[s]  = prob;
        end
    else
        support = p.model[p.window[end:end]];
        if support == 0
            prob    = 1.0 / length( keys(symbols) );
            for s ∈ keys(symbols)
                symbols[s]  = prob;
            end
        end
        for (symbol,count) in children(p.model,p.window[end:end])
            symbols[symbol] = count.value / support;
        end
    end
    return symbols;
end

function info_string{T}( p::DG{T} )
    return @sprintf( "DG(%d)", p.win_length );
end

function unique_string{T}( p::DG{T} )
    return @sprintf( "DG_%02d", p.win_length );
end
