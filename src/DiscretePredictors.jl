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

end # module
