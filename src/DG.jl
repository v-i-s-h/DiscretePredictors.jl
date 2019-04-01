# Dependency Graph is a predictor based on Variable order Markov Chains

"""
    DG{SymbolType}(win_length::Int)

Creates a Dependency Graph predictor for `SymbolType` with lookahead window of `win_length`.
`SymbolType` can be any valid type including `Char`, `Int` etc.,
    
## Examples
```julia-repl
jjulia> p = DG{Char}( 4 )
DiscretePredictors.DG{Char}([*] (0)
, Char[], 4)

julia> p = DG{Int}( 3 )
DiscretePredictors.DG{Int}([*] (0)
, Int[], 3)
```

Reference:
Padmanabhan, Venkata N., and Jeffrey C. Mogul. "Using predictive prefetching to improve world wide web latency." ACM SIGCOMM Computer Communication Review 26.3 (1996): 22-36.
"""
mutable struct DG{T} <: BasePredictor{T}
    model::Trie{T,Int}
    window::Vector{T}
    win_length::Int

    DG{T}( _c::Int ) where {T} = new( Trie{T,Int}(), Vector{T}(), _c )
    # (::Type{DG{T}}){T}( _c::Int )   = new{T}( Trie{T,Int}(), Vector{T}(), _c );
end

function add!( p::DG{T}, sym::T ) where {T}
    p.model.value += 1;
    # Check if this symbol is new
    if sym ∉ keys(p.model.children)
        p.model[[sym]]  = 0;    # Start with a support of 0
    end

    for s ∈ p.window
        if haskey( p.model, [s;sym] )
            p.model[[s;sym]] += 1   # Increment occurence
            p.model[[s]] += 1       # Increment support
        else
            p.model[[s;sym]] = 1    # Create new node
            p.model[[s]] += 1        # Increment support
        end
    end

    push!( p.window, sym )   # Add this symbol to window
    if length(p.window) > p.win_length    # Trim window
        popfirst!( p.window )     # Discard oldest symbol
    end

    nothing
end

function predict( p::DG{T} ) where {T}
    # Create a dictionary with symbols
    symbols = Dict( k => 0.0 for k ∈ keys(children(p.model,Vector{T}())) )
    if isempty(symbols)
        # Just return all symbols with equal probability
        prob    = 1.0 / length( keys(symbols) )
        for s ∈ keys(symbols)
            symbols[s]  = prob
        end
    else
        support = p.model[p.window[end:end]]
        if support == 0
            prob    = 1.0 / length( keys(symbols) )
            for s ∈ keys(symbols)
                symbols[s]  = prob
            end
        end
        for (symbol,count) in children(p.model,p.window[end:end])
            symbols[symbol] = count.value / support
        end
    end
    return symbols
end

function info_string( p::DG{T} ) where {T}
    return @sprintf( "DG(%d)", p.win_length )
end

function unique_string( p::DG{T} ) where {T}
    return @sprintf( "DG_%02d", p.win_length )
end
