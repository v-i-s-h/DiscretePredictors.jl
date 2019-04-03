# Base type for all predictors
import Base.size

abstract type BasePredictor{T}
end

"""
    add!( p::Predictor{SymbolType}, s::SymbolType)

Adds a symbols `s` to the prediction model.

## Example
```julia-repl
julia> p = LZ78{Char}()
DiscretePredictors.LZ78{Char}([*] (0)
, Char[], Char[])

julia> add!( p, 'd' )
```
"""
function add!( p::BasePredictor{T}, sym::T ) where {T}
    nothing
end

"""
    predict( p::Predictor{SymbolType} )

Returns a dictionary of Dict{SymbolType,Float64} with probabilities of next symbol.

## Examples
```julia-repl
julia> p = LZ78{Int}()
DiscretePredictors.LZ78{Int}([*] (0)
, Int[], Int[])

julia> add!( p, 2 )

julia> add!( p, 3 )

julia> predict( p )
Dict{Int,Float64} with 2 entries:
  2 => 0.5
  3 => 0.5
```
"""
function predict( p::BasePredictor{T} ) where {T}
    return Dict{T,Float64}()
end

"""
    info_string( p::Predictor{SymbolType} )

Returns a string with information about the predictor `p`.

## Example
```julia-repl
julia> p = DG{Char}(4)
DiscretePredictors.DG{Char}([*] (0)
, Char[], 4)

julia> info_string( p )
"DG(4)"
```
"""
function info_string( p::BasePredictor{T} ) where {T}
    return @sprintf( "BasePredictor" )
end

"""
    unique_string( p::Predictor{SymbolType} )

Returns an unique string to identify the predictor; Useful for naming log files.

## Example
```julia-repl
julia> p = DG{Char}(4)
DiscretePredictors.DG{Char}([*] (0)
, Char[], 4)

julia> unique_string( p )
"DG_04"
```
"""
function unique_string( p::BasePredictor{T} ) where {T}
    return @sprintf( "BASE" )
end

"""
    get_best_symbol( p::Predictor{SymbolType} [,default_sym = nothing] )

Returns the most probable symbol from predictor `p` on current context. If no symbol to
predict, then returns `default_sym`.

## Example
```julia-repl
julia> p = DG{Int}(4)
DiscretePredictors.DG{Int}([*] (0)
, Int[], 4)

julia> get_best_symbol( p )

julia> get_best_symbol( p, 2 )
2
```
"""
function get_best_symbol( p::BasePredictor{T}, default_sym = nothing ) where {T}
    symbols     = predict( p )
    return get_best_symbol( symbols, default_sym )
end

function get_best_symbol( symbols::Dict{T,Float64}, default_sym = nothing ) where {T}
    best_symbol = default_sym
    maxP        = 0.00
    for (symbol,prob) in symbols
        if prob > maxP
            best_symbol = symbol
            maxP        = prob
        end
    end
    return best_symbol
end

"""
    size( p::Predictor{SymbolType} )

Returns the number of nodes in the model of predictor `p` including root node.

## Example
```julia-repl
julia> p = KOM{Int}(3)
DiscretePredictors.KOM{Int}([*] (0)
, Int[], 3)

julia> add!(p,1); add!(p,3); add!(p,2); add!(p,2); add!(p,1)

julia> size( p )
13

julia> p.model
[*] (5)
+---[2] (2)
     +---[2] (1)
          +---[1] (1)
     +---[1] (1)
+---[3] (1)
     +---[2] (1)
          +---[2] (1)
               +---[1] (1)
+---[1] (2)
     +---[3] (1)
          +---[2] (1)
               +---[2] (1)
```
"""
function size( p::BasePredictor{T} ) where {T}
    return length(keys(p.model)) + 1
end
