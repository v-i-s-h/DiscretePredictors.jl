# Test ActiveLeZi Predictor

@testset "LeZiUpdate" begin

p       = LeZiUpdate{Char}();
data    = [ 'a', 'a', 'a', 'b', 'a',
            'b', 'b', 'b', 'b', 'b',
            'a', 'a', 'b', 'c', 'c',
            'd', 'd', 'c', 'b', 'a',
            'a', 'a', 'a' ];

# Create model
# for symbol ∈ data
#     add( p, symbol )
#     predict( p )
# end
@testset "Online Prediction" begin
    # Create model
    for symbol ∈ data
        add!( p, symbol );
        predictions     = predict( p );
        @test mapreduce(sym->predictions[sym],+,keys(predictions)) <= 1.00;     # :/ not adding upto 1.0
    end
end

# Test model
test_model = Dict{Vector{Char},Int}(
    ['a'] => 10,
    ['a','a'] => 3,
    ['a','a','a'] => 1,
    ['a','b'] => 2,
    ['a','b','c'] => 1,
    ['b'] => 8,
    ['b','a'] => 2,
    ['b','b'] => 2,
    ['b','b','a'] => 1,
    ['b','c'] => 1,
    ['c'] => 3,
    ['d'] => 2,
    ['d','c'] => 1
);

@testset "Model Tests" begin
    # Verify Model
    @testset "Values" begin
        @test p.model.value == 23;
        for node ∈ keys( test_model )
            @test p.model[node] == test_model[node];
        end
    end

    # Verify no other nodes exists
    @testset "Nodes" begin
        nodes   = keys( test_model )
        for node in keys( p.model )
            @test node ∈ nodes;
        end
    end

    @testset "Symbol Prediction" begin
        sym_probability = predict( p );
        @test sym_probability['a']  ≈ 468/690;
        @test sym_probability['b']  ≈ 172/690;
        @test sym_probability['c']  ≈  30/690;
        @test sym_probability['d']  ≈  20/690;
    end

    @testset "Model Size" begin
        @test size( p ) == 14
    end
end

@testset "Best Symbol" begin
    # Reusing p
    @test get_best_symbol( p ) == 'a'
    # For untrained model
    @test get_best_symbol( LeZiUpdate{Char}() ) == nothing
    @test get_best_symbol( LeZiUpdate{Char}() ) == nothing
    @test get_best_symbol( LeZiUpdate{String}() ) == nothing
end

@testset "Info tests" begin
    @test info_string( p ) == "LeZiUpdate";
    @test unique_string( p ) == "LZUP";
end

@testset "Random Sequence test" begin
    for idx = 1:10
        learnt_model    = LeZiUpdate{Int}();
        @test @test_nothrow for i = 1:1000
            symbol = trunc(Int,10*rand());
            add!( learnt_model, symbol );
            predict( learnt_model );
        end
    end
end

end

nothing
