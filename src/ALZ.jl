# Active LeZi
"""
    ALZ{SymbolType}()

Creates an Active LeZi predictor for `SymbolType`. `SymbolType` can be any valid type including
`Char`, `Int64` etc.,
        
# Examples
```julia-repl
julia> p = ALZ{Char}()
DiscretePredictors.ALZ{Char}(Array{Char,1}[], [*] (0)
, Char[], Char[], 0)

julia> p = ALZ{Int64}()
DiscretePredictors.ALZ{Int64}(Array{Int64,1}[], [*] (0)
, Int64[], Int64[], 0)
```

Reference:
Gopalratnam, Karthik, and Diane J. Cook. "Online sequential prediction via incremental parsing: The active lezi algorithm." IEEE Intelligent Systems 22.1 (2007).
"""

type ALZ{T} <: BasePredictor{T}
    dictionary::Vector{Vector{T}}
    model::Trie{T,Int64}
    phrase::Vector{T}
    window::Vector{T}
    max_lz_length::Int64

    # Constructor
    ALZ{T}() where {T} = new{T}( Vector{Vector{T}}(), Trie{T,Int64}(), Vector{T}(), Vector{T}(), 0 );
    # (::Type{ALZ{T}}){T}() = new{T}( Vector{Vector{T}}(), Trie{T,Int64}(), Vector{T}(), Vector{T}(), 0 );
end

function add!{T}( p::ALZ{T}, sym::T )
    p.model.value += 1;   # Update number of symbols seen by model

    push!( p.phrase, sym );

    if p.phrase ∉ p.dictionary
        push!( p.dictionary, p.phrase );
        l   = length(p.phrase);
        p.max_lz_length     = (l>p.max_lz_length)?l:p.max_lz_length;
        p.phrase    = Vector{T}();
    end

    push!( p.window, sym );
    if( length(p.window) > p.max_lz_length )
        shift!( p.window )
    end

    keyBuffer   = p.window[1:end];
    while !isempty(keyBuffer)
        if haskey(p.model,keyBuffer)
            p.model[keyBuffer] += 1;
        else
            p.model[keyBuffer] = 1;
        end
        shift!( keyBuffer )
    end

    nothing
end

function predict{T}( p::ALZ{T} )
    # Create a dictionary with symbols
    symbols = Dict( k => (p.model[[k]]/p.model.value) for k ∈ keys(children(p.model,Vector{T}())) );

    buffer  = Vector{T}();
    for i = length(p.window):-1:2
        unshift!( buffer, p.window[i] );
        list_of_children    = children( p.model, buffer );
        # Get sum of all children values
        s   = isempty(list_of_children)?
                0:
                mapreduce( k->list_of_children[k].value, +, keys(list_of_children) );
        # Apply escape probability
        esc_prob = (p.model[buffer]-s)/p.model[buffer];
        for symbol in keys(symbols)
            symbols[symbol] *= esc_prob;
        end
        # Get each child probability
        for k ∈ keys(list_of_children)
            # println( "        ", k, " -> ", list_of_children[k].value )
            symbols[k] += list_of_children[k].value/p.model[buffer];
        end
    end

    return symbols;
end

function info_string{T}( p::ALZ{T} )
    return @sprintf( "Active-LeZi" );
end

function unique_string{T}( p::ALZ{T} )
    return @sprintf( "ALZ" );
end

"""
seq: a|aa|b|ab|bb|bba|abc|c|d|dc|ba|aaa

dic{}, maxLen[], phrase[], window[]

a :>
    dic{a}, maxLen[1], phrase[], window[a]
    model{[a:1]}
a :>
    dic{a}, maxLen[1], phrase[a], window[a]
    model{[a:2]}
a :>
    dic{a,aa}, maxLen[2], phrase[], window[aa]
    model{aa:1,a:3}
b :>
    dic{a,aa,b}, maxLen[2], phrase[], window[ab]
    model{a:3,aa:1,ab:1,b:1}
a :>
    dic{a,aa,b}, maxLen[2], phrase[a], window[ba]
    model{a:4,aa:1,ab:1,b:1,ba:1}
b :>
    dic{a,aa,b,ab}, maxLen[2], phrase[], window[ab]
    model{a:4,aa:1,ab:2,b:2,ba:1}


"""
