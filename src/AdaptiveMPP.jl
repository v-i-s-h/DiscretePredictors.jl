# Adaptive MPP: 
"""
    AdaptiveMPP{SymbolType}(context_length::Int [,α::Float64 ])

Creates an Adaptive MPP predictor with a context depth of `context_length` and mixing coefficient
``α`` for `SymbolType`. Default value of mixing parameter ``α = 0.10``. `SymbolType` can be 
any valid type including `Char`, `Int` etc.,

## Examples
```julia-repl
julia> p = AdaptiveMPP{Char}(4)
DiscretePredictors.adaptiveMPP{Char}([*] (0)
, Char[], 4, 0.1, Inf, 0.0, [0.2, 0.2, 0.2, 0.2, 0.2], Dict{Char,Float64}[Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}()])

julia> p = AdaptiveMPP{Char}(4,0.13)
DiscretePredictors.adaptiveMPP{Char}([*] (0)
, Char[], 4, 0.13, Inf, 0.0, [0.2, 0.2, 0.2, 0.2, 0.2], Dict{Char,Float64}[Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}()])
```

Reference:
V’yugin, Vladimir V. "Online Aggregation of Unbounded Signed Losses Using Shifting Experts." Conformal and Probabilistic Prediction and Applications. 2017.
"""
mutable struct AdaptiveMPP{T} <: BasePredictor{T}
    model::Trie{T,Int}
    context::Vector{T}
    cxt_length::Int
    α::Float64
    η::Float64
    Δ::Float64
    weights::Vector{Float64}
    last_prediction::Vector{Dict{T,Float64}}

    AdaptiveMPP{T}( _c::Int, _α = 0.10 ) where {T} = new( Trie{T,Int}(), Vector{T}(),
                                                _c, _α, +Inf, 0.00,
                                                1/(1+_c)*ones(Float64,_c+1), fill(Dict{T,Float64}(),_c+1) )
end

function add!( p::AdaptiveMPP{T}, sym::T ) where {T}
    p.model.value += 1;

    # Calculate expert loss
    expert_loss = zeros(Float64,p.cxt_length+1);
    for expert_idx = 1:p.cxt_length+1
        expert_best_symbol      = get_best_symbol( p.last_prediction[expert_idx] )
        expert_loss[expert_idx] = (expert_best_symbol==sym) ? 0 : 1
    end

    # Compute the aggregating algorithm loss
    h_t = sum( p.weights .* expert_loss )

    # Make loss update
    _w  = map( w->isnan(w) ? 1/(p.cxt_length+1) : w, p.weights.*exp.(-p.η*expert_loss) )
    _w  = _w ./ sum(_w)

    # Mixing Update
    # Based on example-1 with α_{t+1} = 0.1 ∀ t
    p.weights   = p.α * 1/(p.cxt_length) .+ (1-p.α) * _w

    # Learning Parameter Update
    m_t = -1/p.η * log( sum( p.weights .* exp.(-p.η*expert_loss) ) )
    δ_t = h_t - m_t
    p.Δ = p.Δ + δ_t
    p.η = 1 / p.Δ

    # Create node path
    push!( p.context, sym )
    buffer  = p.context[1:end]
    while !isempty(buffer)
        p.model[buffer] = (haskey(p.model,buffer)) ? p.model[buffer]+1 : 1
        popfirst!( buffer )
    end

    if length(p.context) > p.cxt_length
        popfirst!( p.context )
    end

    nothing
end


function predict( p::AdaptiveMPP{T} ) where {T}
    # Clear away last predictions
    p.last_prediction   = fill(Dict{T,Float64}(),p.cxt_length+1)

    # Calculate normalized weights
    norm_weights    = p.weights ./ sum(p.weights)
    # println( "    norm_weights: ", norm_weights )

    # Get prediction from 0-order expert
    symbols = Dict( k => (p.model[[k]]/p.model.value) for k ∈ keys(children(p.model,Vector{T}())) )

    # Save this for later
    p.last_prediction[1]    = deepcopy( symbols )

    # Apply 0-order expert weight
    for sym ∈ keys(symbols)
        symbols[sym] *= norm_weights[1]
    end
    # println( "After Order-0: ", symbols )

    # Do prediction from all other higher orders
    no_of_active_experts    = min( p.model.value, p.cxt_length )
    for expert_idx  = 1:no_of_active_experts
        # Predict
        this_expert_prediction = predict_from_subcontext( p, p.context[1:expert_idx] )
        # Normalize probability out from experts - jugaad
        denom   = 0;
        for (sym,prob) ∈ this_expert_prediction denom += prob; end
        for sym ∈ keys(this_expert_prediction) this_expert_prediction[sym] /= denom;    end

        # Save
        p.last_prediction[expert_idx+1] = deepcopy( this_expert_prediction )
        # Apply weight to expert and add to final prediction
        for sym ∈ keys( symbols )
            symbols[sym] += (this_expert_prediction[sym]*norm_weights[expert_idx+1])
        end
        # println( "After order-$expert_idx: ", symbols );
    end

    return symbols;
end

function info_string( p::AdaptiveMPP{T} ) where {T}
    return @sprintf( "Adaptive MPP(%d,\$\\alpha_t=%3.2f\$)", p.cxt_length,p.α )
end

function unique_string( p::AdaptiveMPP{T} ) where {T}
    return @sprintf( "adaptiveMPP_%02d_%03d", p.cxt_length, trunc(Int,100*p.α) )
end

function predict_from_subcontext( p::AdaptiveMPP{T}, sub_cxt::Vector{T} ) where {T}
    # Create a dictionary with symbols
    symbols = Dict( k => (p.model[[k]]/p.model.value) for k ∈ keys(children(p.model,Vector{T}())) )

    buffer  = Vector{T}()
    for i = length(sub_cxt):-1:1
        pushfirst!( buffer, sub_cxt[i] )
        # println( "    Buffer: ", buffer, " -> ", p.model[buffer] );
        # Apply escape probability
        esc_prob = 1/p.model[buffer]
        for symbol in keys(symbols)
            symbols[symbol] *= esc_prob
        end
        # Get each child probability
        list_of_children    = children( p.model, buffer )
        for k ∈ keys(list_of_children)
            # println( "        ", k, " -> ", list_of_children[k].value )
            symbols[k] += list_of_children[k].value/p.model[buffer]
        end
    end

    return symbols;
end
