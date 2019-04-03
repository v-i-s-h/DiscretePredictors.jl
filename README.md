# DiscretePredictors

DiscretePredictors is a collection of algorithms for online discrete sequence prediction. 
It provides a common API to various discrete sequence prediction algorithms. My goals with 
the package are:
- **Simple Interface**
- **Easily Extendable**
- **Reproducible Research**

**Build Status** 
[![Build Status](https://travis-ci.org/v-i-s-h/DiscretePredictors.jl.svg?branch=master)](https://travis-ci.org/v-i-s-h/DiscretePredictors.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/aace65lkov206h5a?svg=true)](https://ci.appveyor.com/project/v-i-s-h/discretepredictors-jl)
**Documentation**
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://v-i-s-h.github.io/DiscretePredictors.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://v-i-s-h.github.io/DiscretePredictors.jl/latest)

**Installation**
For Julia 1.0+
```
] add DiscretePredictors
```
Development of this package now targets only Julia 1.+. A release for Julia 0.6.x/0.7.0 can be downloaded from [here](https://github.com/v-i-s-h/DiscretePredictors.jl/releases/tag/v0.1.0).

### API Overview:
- `p = Predictor{SymbolType}(parameters...)` creates a predictor instance `p` with 
    prediction algorithm `Predictor` (see choices below) of symbols of `SymbolType` with 
    specified the `parameters`
- `add!( p, sym )` adds a symbol to the model
- `predict( p )` computes a probability distribution over the symbols seen so far by the 
    model and returns it as dictionary of `Dict{SymbolType,Float64}`
- `info_string( p )` returns a human readable string about the predictor `p`
- `unique_string( p )` returns a unique string for the predictor `p` with parameter configuration
- `get_best_symbol( p )`  returns the symbol of type `SymbolType` with highest probability 
    under current context
- `size( p )` returns the number of nodes in current prediction model `p.model`

### Available Predictors:
- Adaptive MPP (`AdaptiveMPP`)
- Active LeZi (`ALZ`)
- Dependency Graph (`DG`)
- Discounted HEDGE on KOM (`dHedgePPM`)
- Error Weighted PPM (`ewPPM`)
- K-th Order Markov Model (`KOM`)
- LeZi-Update (`LeZiUpdate`)
- LeZi78 (`LeZi78`)

### Example
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

### Contribute
You can contribute to this project in multiple ways:

1. Found a bug? Please file an issue.
2. Want to see a new predictor implemented? Please file an issue with relevant references. We will make our best effort to implement it.
3. Implemented a new algorithm? Great! Go ahead and open a PR.

### Acknowledgements
This package uses a [modified version](./src/Trie.jl) of ```trie``` from 
[DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl/).
I sincerely thank the developers of [trie.jl](https://github.com/JuliaCollections/DataStructures.jl/blob/master/src/trie.jl).