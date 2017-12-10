# Base type for all predictors
import Base.size

abstract type BasePredictor{T}
end

function add!{T}( p::BasePredictor{T}, sym::T )
    nothing
end

function predict{T}( p::BasePredictor{T} )
    return Dict{T,Float64}();
end

function info_string{T}( p::BasePredictor{T} )
    return @sprintf( "BasePredictor" );
end

function unique_string{T}( p::BasePredictor{T} )
    return @sprintf( "BASE" );
end

# Function to get highest probability symbol
function get_best_symbol{T}( p::BasePredictor{T}, default_sym = nothing )
    symbols     = predict( p );
    return get_best_symbol( symbols, default_sym );
end

function get_best_symbol{T}( symbols::Dict{T,Float64}, default_sym = nothing )
    best_symbol = default_sym;
    maxP        = 0.00;
    for (symbol,prob) in symbols
        if prob > maxP
            best_symbol = symbol
            maxP        = prob
        end
    end
    return best_symbol;
end

function size{T}( p::BasePredictor{T} )
    return length(keys(p.model)) + 1;
end
