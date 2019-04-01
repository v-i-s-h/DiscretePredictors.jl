# LeZi-Update predictor

"""
    LeZiUpdate{SymbolType}()

Creates a LeZiUpdate predictor for `SymbolType`. `SymbolType` can be any valid type including
`Char`, `Int` etc.,

## Examples
```julia-repl
julia> p = LeZiUpdate{Char}()
DiscretePredictors.LeZiUpdate{Char}(Array{Char,1}[], [*] (0)
, Char[], Char[])

julia> p = LeZiUpdate{Int}()
DiscretePredictors.LeZiUpdate{Int}(Array{Int,1}[], [*] (0)
, Int[], Int[])

julia> p = LeZiUpdate{String}()
DiscretePredictors.LeZiUpdate{String}(Array{String,1}[], [*] (0)
, String[], String[])
```

Reference:
Bhattacharya, Amiya, and Sajal K. Das. "LeZi-update: An information-theoretic framework for personal mobility tracking in PCS networks." Wireless Networks 8.2/3 (2002): 121-135.
"""
mutable struct LeZiUpdate{T} <: BasePredictor{T}
    dictionary::Vector{Vector{T}}
    model::Trie{T,Int}
    phrase::Vector{T}
    context::Vector{T}

    LeZiUpdate{T}() where {T} = new( Vector{Vector{}}(), Trie{T,Int}(), Vector{T}(), Vector{T}() )
    # (::Type{LeZiUpdate{T}}){T}() = new{T}( Vector{Vector{}}(), Trie{T,Int}(), Vector{T}(), Vector{T}() );
end

function add!( p::LeZiUpdate{T}, sym::T ) where {T}
    p.model.value += 1   # Update number of symbols seen by model

    push!( p.phrase, sym )
    if p.phrase ∉ p.dictionary
        push!( p.dictionary, p.phrase )

        suffix = p.phrase[1:end];
        while !isempty( suffix )
            prefix  = suffix[1:end];
            while !isempty( prefix )
                if haskey( p.model, prefix )
                    p.model[prefix] += 1
                else
                    p.model[prefix] = 1
                end
                popfirst!( prefix )
            end
            pop!( suffix )
        end
        p.context   = p.phrase[2:end]
        p.phrase    = Vector{T}()
    else
        p.context   = p.phrase[1:end]
    end

    nothing
end

function predict( p::LeZiUpdate{T} ) where {T}
    # Create a dictionary with symbols
    symbols = Dict( k => (p.model[[k]]/p.model.value) for k ∈ keys(children(p.model,Vector{T}())) )

    buffer  = Vector{T}()
    for i = length(p.context):-1:1
        pushfirst!( buffer, p.context[i] )
        # println( "    Buffer: ", buffer );
        list_of_children    = children( p.model, buffer )
        # Get sum of all children values
        s   = isempty(list_of_children) ?
                0 :
                mapreduce( k->list_of_children[k].value, +, keys(list_of_children) );
        # Apply escape probability
        esc_prob = (p.model[buffer]-s)/p.model[buffer]
        for symbol in keys(symbols)
            symbols[symbol] *= esc_prob
        end
        # Get each child probability
        for k ∈ keys(list_of_children)
            # println( "        ", k, " -> ", list_of_children[k].value )
            symbols[k] += list_of_children[k].value/p.model[buffer]
        end
    end

    return symbols;
end

function info_string( p::LeZiUpdate{T} ) where {T}
    return @sprintf( "LeZiUpdate" )
end

function unique_string( p::LeZiUpdate{T} ) where {T}
    return @sprintf( "LZUP" )
end


"""
seq: a|aa|b|ab|bb|bba|abc|c|d|dc|ba|aaa

dic{}, phrase[]

a :>
    dic{a}, phrase[]
    model{a:1}
a :>
    dic{a}, phrase[a]
    model{a:1}
a :>
    dic{a,aa}, phrase[]
    model{a:3,aa:1}
b :>
    dic{a,aa,b}, phrase[]
    model{a:3,aa:1,b:1}
a :>
    dic{a,aa,b}, phrase[a]
    model{a:3,aa:1,b:1}
b :>
    dic{a,aa,b,ab}, phrase[]
    model{a:4,aa:1,ab:1,b:2}
b :>
    dic{a,aa,b,ab}, phrase[b]
    model{a:4,aa:1,ab:1,b:2}
"""
