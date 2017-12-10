# DiscretePredictors

#### Created by Vishnu Raj (@v-i-s-h)

DiscretePredictors is a collection of algorithms for discrete sequence prediction. It provides a common API to various discrete sequence prediction algorithms. My goals with the package are:
- **Simple Interface**
- **Easily Extendable**
- **Reproducible Research**

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