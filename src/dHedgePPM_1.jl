# Discounted HEDEGEd KOM

# With p-loss
mutable struct dHedgePPM_1{T} <: BasePredictor{T}
    model::Trie{T,Int}
    context::Vector{T}
    cxt_length::Int
    β::Float64
    γ::Float64
    weights::Vector{Float64}
    last_prediction::Vector{Dict{T,Float64}}

    dHedgePPM_1{T}( _c::Int, _β::Float64 = 1.0, _γ::Float64 = 1.0 ) where {T} = new( Trie{T,Int}(), Vector{T}(),
                                                _c, _β, _γ,
                                                ones(Float64,_c+1), fill(Dict{T,Float64}(),_c+1) );
end

function add( p::dHedgePPM_1{T}, sym::T ) where {T}
    p.model.value += 1;

    # Update weights
    for expert_idx = 1:p.cxt_length+1
        expert_best_symbol  = get_best_symbol( p.last_prediction[expert_idx] );
        # expert_loss         = (expert_best_symbol==sym)?0:1;
        if expert_best_symbol != nothing
            expert_loss     = 1.0 - p.last_prediction[expert_idx][expert_best_symbol];
        else
            expert_loss     = 1.0;
        end
        p.weights[expert_idx] = (p.weights[expert_idx]^p.γ) * (p.β^expert_loss);
    end

    # Create node path
    push!( p.context, sym );
    buffer  = p.context[1:end];
    while !isempty(buffer)
        p.model[buffer] = (haskey(p.model,buffer)) ? p.model[buffer]+1 : 1;
        shift!( buffer )
    end

    if length(p.context) > p.cxt_length
        shift!( p.context )
    end
end


function predict( p::dHedgePPM_1{T} ) where {T}
    # Clear away last predictions
    p.last_prediction   = fill(Dict{T,Float64}(),p.cxt_length+1);

    # Calculate normalized weights
    norm_weights    = p.weights ./ sum(p.weights);
    # println( "    norm_weights: ", norm_weights );

    # Get prediction from 0-order expert
    symbols = Dict( k => (p.model[[k]]/p.model.value) for k ∈ keys(children(p.model,Vector{T}())) );

    # Save this for later
    p.last_prediction[1]    = deepcopy( symbols );

    # Apply 0-order expert weight
    for sym ∈ keys(symbols)
        symbols[sym] *= norm_weights[1];
    end
    # println( "After Order-0: ", symbols );

    # Do prediction from all other higher orders
    no_of_active_experts    = min( p.model.value, p.cxt_length );
    for expert_idx  = 1:no_of_active_experts
        # Predict
        this_expert_prediction = predict_from_subcontext( p, p.context[1:expert_idx] );
        # Normalize probability out from experts - jugaad
        denom   = 0;
        for (sym,prob) ∈ this_expert_prediction denom += prob; end
        for sym ∈ keys(this_expert_prediction) this_expert_prediction[sym] /= denom;    end

        # Save
        p.last_prediction[expert_idx+1] = deepcopy( this_expert_prediction );
        # Apply weight to expert and add to final prediction
        for sym ∈ keys( symbols )
            symbols[sym] += (this_expert_prediction[sym]*norm_weights[expert_idx+1]);
        end
        # println( "After order-$expert_idx: ", symbols );
    end

    return symbols;
end

function info_string( p::dHedgePPM_1{T} ) where {T}
    return @sprintf( "dHedgePPM1(%d,\$\\beta\$ = %3.2f,\$\\gamma\$ = %3.2f)",
                            p.cxt_length, p.β, p.γ );
end

function unique_string( p::dHedgePPM_1{T} ) where {T}
    return @sprintf( "dHedgePPM1_%02d_%03d_%03d", p.cxt_length,
                        trunc(Int,100*p.β), trunc(Int,100*p.γ)  );
end

function predict_from_subcontext( p::dHedgePPM_1{T}, sub_cxt::Vector{T} )  where {T}
    # Create a dictionary with symbols
    symbols = Dict( k => (p.model[[k]]/p.model.value) for k ∈ keys(children(p.model,Vector{T}())) );

    buffer  = Vector{T}();
    for i = length(sub_cxt):-1:1
        unshift!( buffer, sub_cxt[i] );
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
