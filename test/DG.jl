# Test for DG predictor

@testset "DG" begin

p       = DG{Char}(2);
data    = [ 'a', 'b', 'c', 'c', 'd',
            'b', 'c', 'd', 'c', 'b',
            'c', 'b', 'c' ];

@testset "Online Prediction" begin
    n = 1;
    # Create model
    for symbol ∈ data
        add!( p, symbol );
        predictions     = predict( p );
        s = mapreduce(sym->predictions[sym],+,keys(predictions));
        # if s == 0.00
        #         println( "s = 0.0 at n ", n )
        #         println( "Model: ", p )
        # end
        @test s ≈ 1.00
        n += 1;
    end
end

# Test model
test_model = Dict{Vector{Char},Int}(
    ['a'] => 2,
    ['a','b'] => 1,
    ['a','c'] => 1,
    ['b'] => 7,
    ['b','b'] => 1,
    ['b','c'] => 5,
    ['b','d'] => 1,
    ['c'] => 10,
    ['c','b'] => 3,
    ['c','c'] => 4,
    ['c','d'] => 3,
    ['d'] => 4,
    ['d','b'] => 2,
    ['d','c'] => 2
);

@testset "Model Tests" begin
    # Verify Model
    @testset "Values" begin
        @test p.model.value == 13;
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
        @test sym_probability['a']  ≈ 0/10;
        @test sym_probability['b']  ≈ 3/10;
        @test sym_probability['c']  ≈ 4/10;
        @test sym_probability['d']  ≈ 3/10;
    end

    @testset "Model Size" begin
        @test size( p ) == 14 + 1;
    end
end

@testset "Best Symbol" begin
    # Reusing p
    @test get_best_symbol( p ) == 'c'
    # For untrained model
    @test get_best_symbol( DG{Int}(10) )  == nothing
    @test get_best_symbol( DG{Char}(10) )   == nothing
    @test get_best_symbol( DG{String}(10) ) == nothing
end

@testset "Info tests" begin
    @test info_string( p ) == "DG(2)";
    @test unique_string( p ) == "DG_02";
end

@testset "Random Sequence test" begin
    for idx = 1:10
        learnt_model    = DG{Int}(5);
        @test @test_nothrow for i = 1:1000
            symbol = trunc(Int,10*rand());
            add!( learnt_model, symbol );
            predict( learnt_model );
        end
    end
end


end

nothing
