module DiscretePredictors

    using Printf

    include( "./Trie.jl" )
    include( "./BasePredictor.jl" )
    include( "./ALZ.jl" )
    include( "./DG.jl" )
    include( "./KOM.jl")
    include( "./LeZiUpdate.jl" )
    include( "./LZ78.jl" )
    include( "./dHedgePPM.jl" )      # Discounted HEDGEd KOM
    include( "./dHedgePPM_1.jl" )
    include( "./AdaptiveMPP.jl" )
    include( "./ewPPM.jl" )

    export
        Trie,
        # Predictors
        AdaptiveMPP,
        BasePredictor,
        ALZ,
        DG,
        dHedgePPM,
        dHedgePPM_1,
        acc_dHPPM,
        ewPPM,
        KOM,
        LeZiUpdate,
        LZ78,
        # functions
        add!,
        predict,
        info_string,
        unique_string,
        get_best_symbol,
        size

"""
A Julia package for online discrete sequence prediction.

API Overview:
- `p = Predictor{SymbolType}(parameters...)` creates a predictor instance `p` with 
    prediction algorithm `Predictor` (see choices below) of symbols of `SymbolType` with 
    specified the `parameters`
- `add!( p, sym )` adds a symbol to the model
- `predict( p )` computes a probability distribution over the symbols seen so far by the 
    model and returns it as dictionary of `Dict{SymbolType,Float64}`
- `info_string( p )` returns a human readable string about the predictor `p`
- `unique_string( p )` returns a unique string for the predictor `p` with paramter configuration
- `get_best_symbol( p )`  returns the symbol of type `SymbolType` with highest probability 
    under current context
- `size( p )` returns the number of nodes in current prediction model `p.model`

Available Predictors:
- Adaptive MPP ([`AdaptiveMPP`](@ref))
- Active LeZi ([`ALZ`](@ref))
- Dependency Graph ([`DG`](@ref))
- Discounted HEDGE on KOM ([`dHedgePPM`](@ref))
- Error Weighted PPM ([`ewPPM`](@ref))
- K-th Order Markov Model ([`KOM`](@ref))
- LeZi-Update ([`LeZiUpdate`](@ref))
- LeZi78 ([`LZ78`](@ref))

## Example
```julia
# Initialize a predictor
julia> p = KOM{Char}(4)
DiscretePredictors.KOM{Char}([*] (0)
, Char[], 4)

# Add some symbols
julia> add!( p, 'a' )

julia> add!( p, 'b' )

julia> add!( p, 'c' )

julia> add!( p, 'b' )

# Print out the model
julia> p
DiscretePredictors.KOM{Char}([*] (4)
+---[b] (2)
     +---[c] (1)
          +---[b] (1)
+---[a] (1)
     +---[b] (1)
          +---[c] (1)
               +---[b] (1)
+---[c] (1)
     +---[b] (1)
, ['a', 'b', 'c', 'b'], 4)

# Get prediction
julia> predict( p )
Dict{Char,Float64} with 3 entries:
  'b' => 0.25
  'a' => 0.125
  'c' => 0.625

# Get best symbol
julia> get_best_symbol( p )
'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)

julia> info_string( p )
"KOM(4)"

julia> unique_string( p )
"KOM_04"

julia> size( p )
10

```
"""
DiscretePredictors

end # module
