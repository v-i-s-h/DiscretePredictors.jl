# Tests for dHedgePPM Predictor

@testset "AdaptiveMPP" begin

p       = AdaptiveMPP{Char}(2);
data    = [ 'a', 'b', 'c', 'c', 'd',
            'b', 'c', 'd', 'c', 'b',
            'c', 'b', 'c' ];

@testset "Online Prediction" begin
    # Create model
    for symbol ∈ data
        add!( p, symbol );
        predictions     = predict( p );
        if p.model.value > 1
            # For Sequences with length less than cxt_length, current implementation
            # has mathmatical instability, which will return ∑p < 1.00
            @test mapreduce(sym->predictions[sym],+,keys(predictions)) ≈ 1.00
        end
    end
end

# Test model
test_model = Dict{Vector{Char},Int}(
    ['a'] => 1,
    ['a','b'] => 1,
    ['a','b','c'] => 1,
    ['b'] => 4,
    ['b','c'] => 4,
    ['b','c','b'] => 1,
    ['b','c','c'] => 1,
    ['b','c','d'] => 1,
    ['c'] => 6,
    ['c','b'] => 2,
    ['c','b','c'] => 2,
    ['c','c'] => 1,
    ['c','c','d'] => 1,
    ['c','d'] => 2,
    ['c','d','b'] => 1,
    ['c','d','c'] => 1,
    ['d'] => 2,
    ['d','b'] => 1,
    ['d','b','c'] => 1,
    ['d','c'] => 1,
    ['d','c','b'] => 1
);


@testset "Model Tests" begin
    # Verify Model
    @testset "Values" begin
        @test p.model.value == 13
        for node ∈ keys( test_model )
            @test p.model[node] == test_model[node]
        end
    end

    # Verify no other nodes exists
    @testset "Nodes" begin
        nodes   = keys( test_model )
        for node in keys( p.model )
            @test node ∈ nodes;
        end
    end

    # @testset "Symbol Prediction" begin
    #     sym_probability = predict( p );
    #     @test sym_probability['a']  ≈ 0.0351173;
    #     @test sym_probability['b']  ≈ 0.2690020;
    #     @test sym_probability['c']  ≈ 0.4971140;
    #     @test sym_probability['d']  ≈ 0.1987670;
    # end

    @testset "Model Size" begin
        @test size( p ) == 22
    end
end

@testset "Best Symbol" begin
    # Reusing p
    # @test get_best_symbol( p ) == 'b'
    # For untrained model
    @test get_best_symbol( AdaptiveMPP{Int}(4) ) == nothing
    @test get_best_symbol( AdaptiveMPP{Char}(4) ) == nothing
    @test get_best_symbol( AdaptiveMPP{String}(4) ) == nothing
end

@testset "Info tests" begin
    @test info_string( p ) == "Adaptive MPP(2,\$\\alpha_t=0.10\$)"
    @test unique_string( p ) == "adaptiveMPP_02_010"
end

@testset "Random Sequence test" begin
    for idx = 1:10
        learnt_model    = AdaptiveMPP{Int}(5);
        @test @test_nothrow for i = 1:1000
            symbol = trunc(Int,10*rand());
            add!( learnt_model, symbol );
            predict( learnt_model );
        end
    end
end

end

nothing
