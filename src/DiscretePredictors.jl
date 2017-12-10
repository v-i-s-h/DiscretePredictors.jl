module DiscretePredictors

    include( "./Trie.jl" )
    include( "./BasePredictor.jl" )
    include( "./ALZ.jl" )
    include( "./DG.jl" )
    include( "./KOM.jl")
    include( "./LeZiUpdate.jl" )
    include( "./LZ78.jl" )
    include( "./dHedgePPM.jl" )      # Discounted HEDGEd KOM
    include( "./dHedgePPM_1.jl" )
    include( "./adaptiveMPP.jl" )

    include( "./ewPPM.jl" )



    export
        Trie,
        # Predictors
        adaptiveMPP,
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
        add,
        predict,
        info_string,
        unique_string,
        get_best_symbol,
        size

"""
A Julia package for discrete sequence prediction.

API Overview:
- `p = Predictor{SymbolType}(parameters...)` creates a predictor instance `p` with 
    prediction algorithm `Predictor` (see choices below) of symbols of `SymbolType` with 
    specified the `parameters`
- `add( p, sym )` adds a symbol to the model
- `predict( p )` computes a probability distribution over the symbols seen so far by the 
    model and returns it as dictionary of `Dict{SymbolType,Float64}`
- `info_string( p )` returns a human readable string about the predictor `p`
- `unique_string( p )` returns a unique string for the predictor `p` with paramter configuration
- `get_best_symbol( p )`  returns the symbol of type `SymbolType` with highest probability 
    under current context
- `size( p )` returns the number of nodes in current prediction model `p.model`

Available Predictors:
- Active LeZi (`ALZ`)
- Dependency Graph (`DG`)
- Discounted HEDGE on KOM (`dHedgePPM`)
- Error Weighted PPM (`ewPPM`)
- K-th Order Markov Model (`KOM`)
- LeZi-Update (`LeZiUpdate`)
- LeZi78 (`LeZi78`)
"""
DiscretePredictors

end # module
