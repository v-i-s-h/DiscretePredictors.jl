var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#DiscretePredictors.jl-1",
    "page": "Home",
    "title": "DiscretePredictors.jl",
    "category": "section",
    "text": "CurrentModule = DiscretePredictorsA Julia package for online discrete symbol prediction"
},

{
    "location": "#Setting-up-DiscretePredictors.jl-1",
    "page": "Home",
    "title": "Setting up DiscretePredictors.jl",
    "category": "section",
    "text": "Pages = [\"man/guide.md\"]"
},

{
    "location": "#Library-Outline-1",
    "page": "Home",
    "title": "Library Outline",
    "category": "section",
    "text": "Pages = [\"lib/interface.md\", \"lib/predictors.md\"]"
},

{
    "location": "#DiscretePredictors",
    "page": "Home",
    "title": "DiscretePredictors",
    "category": "Module",
    "text": "A Julia package for online discrete sequence prediction.\n\nAPI Overview:\n\np = Predictor{SymbolType}(parameters...) creates a predictor instance p with    prediction algorithm Predictor (see choices below) of symbols of SymbolType with    specified the parameters\nadd!( p, sym ) adds a symbol to the model\npredict( p ) computes a probability distribution over the symbols seen so far by the    model and returns it as dictionary of Dict{SymbolType,Float64}\ninfo_string( p ) returns a human readable string about the predictor p\nunique_string( p ) returns a unique string for the predictor p with paramter configuration\nget_best_symbol( p )  returns the symbol of type SymbolType with highest probability    under current context\nsize( p ) returns the number of nodes in current prediction model p.model\n\nAvailable Predictors:\n\nAdaptive MPP (AdaptiveMPP)\nActive LeZi (ALZ)\nDependency Graph (DG)\nDiscounted HEDGE on KOM (dHedgePPM)\nError Weighted PPM (ewPPM)\nK-th Order Markov Model (KOM)\nLeZi-Update (LeZiUpdate)\nLeZi78 (LZ78)\n\nExample\n\n# Initialize a predictor\njulia> p = KOM{Char}(4)\nDiscretePredictors.KOM{Char}([*] (0)\n, Char[], 4)\n\n# Add some symbols\njulia> add!( p, 'a' )\n\njulia> add!( p, 'b' )\n\njulia> add!( p, 'c' )\n\njulia> add!( p, 'b' )\n\n# Print out the model\njulia> p\nDiscretePredictors.KOM{Char}([*] (4)\n+---[b] (2)\n     +---[c] (1)\n          +---[b] (1)\n+---[a] (1)\n     +---[b] (1)\n          +---[c] (1)\n               +---[b] (1)\n+---[c] (1)\n     +---[b] (1)\n, ['a', 'b', 'c', 'b'], 4)\n\n# Get prediction\njulia> predict( p )\nDict{Char,Float64} with 3 entries:\n  'b' => 0.25\n  'a' => 0.125\n  'c' => 0.625\n\n# Get best symbol\njulia> get_best_symbol( p )\n'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)\n\njulia> info_string( p )\n\"KOM(4)\"\n\njulia> unique_string( p )\n\"KOM_04\"\n\njulia> size( p )\n10\n\n\n\n\n"
},

{
    "location": "#Breif-Overview-1",
    "page": "Home",
    "title": "Breif Overview",
    "category": "section",
    "text": "DiscretePredictors"
},

{
    "location": "man/guide/#",
    "page": "Guide",
    "title": "Guide",
    "category": "page",
    "text": ""
},

{
    "location": "man/guide/#Package-Guide-1",
    "page": "Guide",
    "title": "Package Guide",
    "category": "section",
    "text": ""
},

{
    "location": "man/guide/#Installation-1",
    "page": "Guide",
    "title": "Installation",
    "category": "section",
    "text": "DiscretePredictors is a registered package and so can be installed via Pkg.add.Pkg.add(\"DiscretePredictors\")This package supports Julia 0.6."
},

{
    "location": "man/guide/#Usage-1",
    "page": "Guide",
    "title": "Usage",
    "category": "section",
    "text": "To use DiscretePredictors.jl in your project, using DiscretePredictors"
},

{
    "location": "man/examples/#",
    "page": "Example",
    "title": "Example",
    "category": "page",
    "text": ""
},

{
    "location": "man/examples/#Example-1",
    "page": "Example",
    "title": "Example",
    "category": "section",
    "text": ""
},

{
    "location": "man/contributing/#",
    "page": "Contributing Guidelines",
    "title": "Contributing Guidelines",
    "category": "page",
    "text": ""
},

{
    "location": "man/contributing/#Contributing-Guidelines-1",
    "page": "Contributing Guidelines",
    "title": "Contributing Guidelines",
    "category": "section",
    "text": ""
},

{
    "location": "lib/interface/#",
    "page": "High Level Interface",
    "title": "High Level Interface",
    "category": "page",
    "text": ""
},

{
    "location": "lib/interface/#High-Level-Interface-1",
    "page": "High Level Interface",
    "title": "High Level Interface",
    "category": "section",
    "text": "The following interfaces are provided by this package to interact with predictors.Pages = [\"interface.md\"]"
},

{
    "location": "lib/interface/#DiscretePredictors.add!",
    "page": "High Level Interface",
    "title": "DiscretePredictors.add!",
    "category": "Function",
    "text": "add!( p::Predictor{SymbolType}, s::SymbolType)\n\nAdds a symbols s to the prediction model.\n\nExample\n\njulia> p = LZ78{Char}()\nDiscretePredictors.LZ78{Char}([*] (0)\n, Char[], Char[])\n\njulia> add!( p, 'd' )\n\n\n\n"
},

{
    "location": "lib/interface/#add!-1",
    "page": "High Level Interface",
    "title": "add!",
    "category": "section",
    "text": "add!"
},

{
    "location": "lib/interface/#DiscretePredictors.predict",
    "page": "High Level Interface",
    "title": "DiscretePredictors.predict",
    "category": "Function",
    "text": "predict( p::Predictor{SymbolType} )\n\nReturns a disctionary of Dict{SymbolType,Float64} with probabilities of next symbol.\n\nExamples\n\njulia> p = LZ78{Int64}()\nDiscretePredictors.LZ78{Int64}([*] (0)\n, Int64[], Int64[])\n\njulia> add!( p, 2 )\n\njulia> add!( p, 3 )\n\njulia> predict( p )\nDict{Int64,Float64} with 2 entries:\n  2 => 0.5\n  3 => 0.5\n\n\n\n"
},

{
    "location": "lib/interface/#predict-1",
    "page": "High Level Interface",
    "title": "predict",
    "category": "section",
    "text": "predict"
},

{
    "location": "lib/interface/#DiscretePredictors.info_string",
    "page": "High Level Interface",
    "title": "DiscretePredictors.info_string",
    "category": "Function",
    "text": "info_string( p::Predictor{SymbolType} )\n\nReturns a string with information about the predictor p.\n\nExample\n\njulia> p = DG{Char}(4)\nDiscretePredictors.DG{Char}([*] (0)\n, Char[], 4)\n\njulia> info_string( p )\n\"DG(4)\"\n\n\n\n"
},

{
    "location": "lib/interface/#info_string-1",
    "page": "High Level Interface",
    "title": "info_string",
    "category": "section",
    "text": "info_string"
},

{
    "location": "lib/interface/#DiscretePredictors.unique_string",
    "page": "High Level Interface",
    "title": "DiscretePredictors.unique_string",
    "category": "Function",
    "text": "unique_string( p::Predictor{SymbolType} )\n\nReturns an unique string to identify the predictor; Useful for naming log files.\n\nExample\n\njulia> p = DG{Char}(4)\nDiscretePredictors.DG{Char}([*] (0)\n, Char[], 4)\n\njulia> unique_string( p )\n\"DG_04\"\n\n\n\n"
},

{
    "location": "lib/interface/#unique_string-1",
    "page": "High Level Interface",
    "title": "unique_string",
    "category": "section",
    "text": "unique_string"
},

{
    "location": "lib/interface/#DiscretePredictors.get_best_symbol",
    "page": "High Level Interface",
    "title": "DiscretePredictors.get_best_symbol",
    "category": "Function",
    "text": "get_best_symbol( p::Predictor{SymbolType} [,default_sym = nothing] )\n\nReturns the most probable symbol from predictor p on current context. If no symbol to predict, then returns default_sym.\n\nExample\n\njulia> p = DG{Int64}(4)\nDiscretePredictors.DG{Int64}([*] (0)\n, Int64[], 4)\n\njulia> get_best_symbol( p )\n\njulia> get_best_symbol( p, 2 )\n2\n\n\n\n"
},

{
    "location": "lib/interface/#get_best_symbol-1",
    "page": "High Level Interface",
    "title": "get_best_symbol",
    "category": "section",
    "text": "get_best_symbol"
},

{
    "location": "lib/interface/#Base.size",
    "page": "High Level Interface",
    "title": "Base.size",
    "category": "Function",
    "text": "size( p::Predictor{SymbolType} )\n\nReturns the number of nodes in the model of predictor p including root node.\n\nExample\n\njulia> p = KOM{Int64}(3)\nDiscretePredictors.KOM{Int64}([*] (0)\n, Int64[], 3)\n\njulia> add!(p,1); add!(p,3); add!(p,2); add!(p,2); add!(p,1)\n\njulia> size( p )\n13\n\njulia> p.model\n[*] (5)\n+---[2] (2)\n     +---[2] (1)\n          +---[1] (1)\n     +---[1] (1)\n+---[3] (1)\n     +---[2] (1)\n          +---[2] (1)\n               +---[1] (1)\n+---[1] (2)\n     +---[3] (1)\n          +---[2] (1)\n               +---[2] (1)\n\n\n\n"
},

{
    "location": "lib/interface/#size-1",
    "page": "High Level Interface",
    "title": "size",
    "category": "section",
    "text": "size"
},

{
    "location": "lib/predictors/#",
    "page": "Predictors",
    "title": "Predictors",
    "category": "page",
    "text": ""
},

{
    "location": "lib/predictors/#Predictors-1",
    "page": "Predictors",
    "title": "Predictors",
    "category": "section",
    "text": "Following are the available online predictors provided by this package.Pages = [\"predictors.md\"]"
},

{
    "location": "lib/predictors/#DiscretePredictors.AdaptiveMPP",
    "page": "Predictors",
    "title": "DiscretePredictors.AdaptiveMPP",
    "category": "Type",
    "text": "AdaptiveMPP{SymbolType}(context_length::Int64 [,α::Float64 ])\n\nCreates an Adaptive MPP predictor with a context depth of context_length and mixing coefficient  for SymbolType. Default value of mixing parameter  = 010. SymbolType can be  any valid type including Char, Int64 etc.,\n\nExamples\n\njulia> p = AdaptiveMPP{Char}(4)\nDiscretePredictors.adaptiveMPP{Char}([*] (0)\n, Char[], 4, 0.1, Inf, 0.0, [0.2, 0.2, 0.2, 0.2, 0.2], Dict{Char,Float64}[Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}()])\n\njulia> p = AdaptiveMPP{Char}(4,0.13)\nDiscretePredictors.adaptiveMPP{Char}([*] (0)\n, Char[], 4, 0.13, Inf, 0.0, [0.2, 0.2, 0.2, 0.2, 0.2], Dict{Char,Float64}[Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}()])\n\nReference: V’yugin, Vladimir V. \"Online Aggregation of Unbounded Signed Losses Using Shifting Experts.\" Conformal and Probabilistic Prediction and Applications. 2017.\n\n\n\n"
},

{
    "location": "lib/predictors/#Adaptive-MPP-1",
    "page": "Predictors",
    "title": "Adaptive MPP",
    "category": "section",
    "text": "AdaptiveMPP"
},

{
    "location": "lib/predictors/#DiscretePredictors.ALZ",
    "page": "Predictors",
    "title": "DiscretePredictors.ALZ",
    "category": "Type",
    "text": "ALZ{SymbolType}()\n\nCreates an Active LeZi predictor for SymbolType. SymbolType can be any valid type including Char, Int64 etc.,\n\nExamples\n\njulia> p = ALZ{Char}()\nDiscretePredictors.ALZ{Char}(Array{Char,1}[], [*] (0)\n, Char[], Char[], 0)\n\njulia> p = ALZ{Int64}()\nDiscretePredictors.ALZ{Int64}(Array{Int64,1}[], [*] (0)\n, Int64[], Int64[], 0)\n\nReference: Gopalratnam, Karthik, and Diane J. Cook. \"Online sequential prediction via incremental parsing: The active lezi algorithm.\" IEEE Intelligent Systems 22.1 (2007).\n\n\n\n"
},

{
    "location": "lib/predictors/#Active-LeZi-1",
    "page": "Predictors",
    "title": "Active LeZi",
    "category": "section",
    "text": "ALZ"
},

{
    "location": "lib/predictors/#DiscretePredictors.DG",
    "page": "Predictors",
    "title": "DiscretePredictors.DG",
    "category": "Type",
    "text": "DG{SymbolType}(win_length::Int)\n\nCreates a Dependency Graph predictor for SymbolType with lookahead window of win_length. SymbolType can be any valid type including Char, Int64 etc.,\n\nExamples\n\njjulia> p = DG{Char}( 4 )\nDiscretePredictors.DG{Char}([*] (0)\n, Char[], 4)\n\njulia> p = DG{Int64}( 3 )\nDiscretePredictors.DG{Int64}([*] (0)\n, Int64[], 3)\n\nReference: Padmanabhan, Venkata N., and Jeffrey C. Mogul. \"Using predictive prefetching to improve world wide web latency.\" ACM SIGCOMM Computer Communication Review 26.3 (1996): 22-36.\n\n\n\n"
},

{
    "location": "lib/predictors/#Dependency-Graph-1",
    "page": "Predictors",
    "title": "Dependency Graph",
    "category": "section",
    "text": "DG"
},

{
    "location": "lib/predictors/#DiscretePredictors.dHedgePPM",
    "page": "Predictors",
    "title": "DiscretePredictors.dHedgePPM",
    "category": "Type",
    "text": "dHedgePPM{SymbolType}( c::Int, [ β::Float64 = 1.0, γ::Float64 = 1.0 ] )\n\nCreates a Discounted HEDGE Predictor for SymbolType with context length c, learning parameter  and discounting parameter .\n\nExamples\n\njulia> p = dHedgePPM{Char}( 4 )\nDiscretePredictors.dHedgePPM{Char}([*] (0)\n, Char[], 4, 1.0, 1.0, [1.0, 1.0, 1.0, 1.0, 1.0], Dict{Char,Float64}[Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}()])\n\njulia> p = dHedgePPM{Char}( 4, 0.8 )\nDiscretePredictors.dHedgePPM{Char}([*] (0)\n, Char[], 4, 0.8, 1.0, [1.0, 1.0, 1.0, 1.0, 1.0], Dict{Char,Float64}[Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}()])\n\njulia> p = dHedgePPM{Char}( 4, 0.9, 0.8 )\nDiscretePredictors.dHedgePPM{Char}([*] (0)\n, Char[], 4, 0.9, 0.8, [1.0, 1.0, 1.0, 1.0, 1.0], Dict{Char,Float64}[Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}(), Dict{Char,Float64}()])\n\nReference: Raj, Vishnu, and Sheetal Kalyani. \"An aggregating strategy for shifting experts in discrete sequence prediction.\" arXiv preprint arXiv:1708.01744 (2017).\n\n\n\n"
},

{
    "location": "lib/predictors/#Discounted-HEDGE-with-PPM-1",
    "page": "Predictors",
    "title": "Discounted HEDGE with PPM",
    "category": "section",
    "text": "dHedgePPM"
},

{
    "location": "lib/predictors/#DiscretePredictors.ewPPM",
    "page": "Predictors",
    "title": "DiscretePredictors.ewPPM",
    "category": "Type",
    "text": "ewPPM{Char}( c::Int [,ϵ::Float64 = 1.0] )\n\nCreates an Error Weighted PPM predictor with context length c and weighing paramter ϵ.\n\nExamples\n\njulia> p = ewPPM{Int64}(3)\nDiscretePredictors.ewPPM{Int64}([*] (0)\n, Int64[], 3, 1.0, [1.0, 1.0, 1.0, 1.0], Dict{Int64,Float64}[Dict{Int64,Float64}(), Dict{Int64,Float64}(), Dict{Int64,Float64}(), Dict{Int64,Float64}()])\n\njulia> p = ewPPM{Int64}(3, 0.95)\nDiscretePredictors.ewPPM{Int64}([*] (0)\n, Int64[], 3, 0.95, [1.0, 1.0, 1.0, 1.0], Dict{Int64,Float64}[Dict{Int64,Float64}(), Dict{Int64,Float64}(), Dict{Int64,Float64}(), Dict{Int64,Float64}()])\n\nReference: Pulliyakode, Saishankar Katri, and Sheetal Kalyani. \"A modified ppm algorithm for online sequence prediction using short data records.\" IEEE Communications Letters 19.3 (2015): 423-426.\n\n\n\n"
},

{
    "location": "lib/predictors/#Error-Weighted-PPM-1",
    "page": "Predictors",
    "title": "Error Weighted PPM",
    "category": "section",
    "text": "ewPPM"
},

{
    "location": "lib/predictors/#DiscretePredictors.KOM",
    "page": "Predictors",
    "title": "DiscretePredictors.KOM",
    "category": "Type",
    "text": "KOM{SymbolType}(context_length::Int64)\n\nCreates a K-th Order Markov Model predictor with a context depth of context_length for  SymbolType. SymbolType can be any valid type including Char, Int64 etc.,\n\nExamples\n\njulia> p = KOM{Char}(3)\nDiscretePredictors.KOM{Char}([*] (0)\n, Char[], 3)\n\njulia> p = KOM{Int64}(5)\nDiscretePredictors.KOM{Int64}([*] (0)\n, Int64[], 5)\n\njulia> p = KOM{String}(4)\nDiscretePredictors.KOM{String}([*] (0)\n, String[], 4)\n\nReference:\n\n\n\n"
},

{
    "location": "lib/predictors/#K-th-Order-Markov-Model-1",
    "page": "Predictors",
    "title": "K-th Order Markov Model",
    "category": "section",
    "text": "KOM"
},

{
    "location": "lib/predictors/#DiscretePredictors.LeZiUpdate",
    "page": "Predictors",
    "title": "DiscretePredictors.LeZiUpdate",
    "category": "Type",
    "text": "LeZiUpdate{SymbolType}()\n\nCreates a LeZiUpdate predictor for SymbolType. SymbolType can be any valid type including Char, Int64 etc.,\n\nExamples\n\njulia> p = LeZiUpdate{Char}()\nDiscretePredictors.LeZiUpdate{Char}(Array{Char,1}[], [*] (0)\n, Char[], Char[])\n\njulia> p = LeZiUpdate{Int64}()\nDiscretePredictors.LeZiUpdate{Int64}(Array{Int64,1}[], [*] (0)\n, Int64[], Int64[])\n\njulia> p = LeZiUpdate{String}()\nDiscretePredictors.LeZiUpdate{String}(Array{String,1}[], [*] (0)\n, String[], String[])\n\nReference: Bhattacharya, Amiya, and Sajal K. Das. \"LeZi-update: An information-theoretic framework for personal mobility tracking in PCS networks.\" Wireless Networks 8.2/3 (2002): 121-135.\n\n\n\n"
},

{
    "location": "lib/predictors/#LeZi-Update-1",
    "page": "Predictors",
    "title": "LeZi Update",
    "category": "section",
    "text": "LeZiUpdate"
},

{
    "location": "lib/predictors/#DiscretePredictors.LZ78",
    "page": "Predictors",
    "title": "DiscretePredictors.LZ78",
    "category": "Type",
    "text": "LZ78{SymbolType}()\n\nCreates a LZ78 predictor for SymbolType. SymbolType can be any valid type including Char, Int64 etc.,\n\nExamples\n\njulia> p = LZ78{Int64}()\nDiscretePredictors.LZ78{Int64}([*] (0)\n, Int64[], Int64[])\n\njulia> p = LZ78{Char}()\nDiscretePredictors.LZ78{Char}([*] (0)\n, Char[], Char[])\n\njulia> p = LZ78{String}()\nDiscretePredictors.LZ78{String}([*] (0)\n, String[], String[])\n\nReference: Ziv, Jacob, and Abraham Lempel. \"Compression of individual sequences via variable-rate coding.\" IEEE transactions on Information Theory 24.5 (1978): 530-536.\n\n\n\n"
},

{
    "location": "lib/predictors/#LZ78-1",
    "page": "Predictors",
    "title": "LZ78",
    "category": "section",
    "text": "LZ78"
},

]}
