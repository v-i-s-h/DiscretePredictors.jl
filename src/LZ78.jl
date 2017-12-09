# LZ78 Prediction Implementation

type LZ78{T} <: BasePredictor{T}
    model::Trie{T,Int64}
    phrase::Vector{T}
    context::Vector{T}

    # Constructor
    LZ78{T}() where {T} = new( Trie{T,Int64}(), Vector{T}(), Vector{T}() );
    # (::Type{LZ78{T}}){T}() = new{T}( Trie{T,Int64}(), Vector{T}(), Vector{T}() );
end

function add{T}( p::LZ78{T}, sym::T )
    p.model.value += 1;

    # Update model
    push!( p.phrase, sym );
    if( p.phrase ∈ keys(p.model) ) # Already in dictionary
        # Meww!!
        p.context   = p.phrase[1:end];
        p.model[p.phrase] += 1;
    else
        # keyBuffer   = copy( p.phrase );
        p.model[p.phrase]  = 1; # Add this phrase to trie
        # keyBuffer = p.phrase[1:end-1];  # Suffix
        # while !isempty(keyBuffer)
        #     p.model[ keyBuffer ] += 1;
        #     pop!( keyBuffer );
        # end
        # println( "Spliting phrase: ", p.phrase )
        p.context = p.phrase[2:end];
        p.phrase  = Vector{T}();
    end
end

function predict{T}( p::LZ78{T} )
    # Create a dictionary with symbols
    # println( "Predicting on context: ", p.context )
    children_of_root    = children(p.model,Vector{T}());
    if isempty(children_of_root) # No symbol seen
        return Dict{T,Float64}();   # No prediction
    end
    root_sum            = mapreduce( c->p.model[[c]], +, keys(children_of_root) );
    symbols = Dict( k => (p.model[[k]]/root_sum) for k ∈ keys(children_of_root) );

    window  = p.context[1:end];
    buffer  = Vector{T}();
    for i = length(window):-1:1
        unshift!( buffer, window[i] );
        list_of_children    = children( p.model, buffer );
        # Get sum of all children values
        s   = isempty(list_of_children)?
                0:
                mapreduce( k->list_of_children[k].value, +, keys(list_of_children) );
        # Apply escape probability
        if haskey(p.model,buffer)
            esc_prob = (p.model[buffer]-s)/p.model[buffer];
        else
            esc_prob = 1.0;
        end
        # println( "    escape from cxt: ", buffer, " with ", esc_prob )
        for symbol in keys(symbols)
            symbols[symbol] *= esc_prob;
        end
        # Get each child probability
        for k ∈ keys(list_of_children)
            # println( "        ", k, " -> ", list_of_children[k].value )
            if haskey(symbols,k)    # Not an orphan symbol
                symbols[k] += list_of_children[k].value/p.model[buffer];
            else
                symbols[k] = 0.00;
            end
        end
    end

    return symbols;
end

function info_string{T}( p::LZ78{T} )
    return @sprintf( "LZ78" );
end

function unique_string{T}( p::LZ78{T} )
    return @sprintf( "LZ78" );
end
