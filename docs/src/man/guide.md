# Package Guide

## Installation
DiscretePredictors is a registered package and so can be installed via `Pkg.add`.

```julia
Pkg.add("DiscretePredictors")
```

This package supports Julia `0.6`.

## Usage
To use ```DiscretePredictors.jl``` in your project, 

```julia
using DiscretePredictors
```

## Accessing Documentation from REPL
All docs found here can also be accessed via REPL through Julia's help functionality.
```julia-repl
julia> using DiscretePredictors

help?> predict
search: predict BasePredictor DiscretePredictors permutedims permutedims! mapreducedim ipermutedims PermutedDimsArray

  predict( p::Predictor{SymbolType} )

  Returns a dictionary of Dict{SymbolType,Float64} with probabilities of next symbol.

     Examples
    ==========

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