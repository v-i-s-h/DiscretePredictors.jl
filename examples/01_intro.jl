# This example shows how to use different predictors for symbols prediction

# Make the package available
using DiscretePredictors

# Some psuedo data
data = [ 'a', 'a', 'a', 'b', 'a',
         'b', 'b', 'b', 'b', 'b',
         'a', 'a', 'b', 'c', 'c',
         'd', 'd', 'c', 'b', 'a',
         'a', 'a', 'a' ];

# Make a KOM predictor for 'Char' symbol
p   = KOM{Char}(3)

# Just to show some usages
println( "I'm a ", info_string(p), " predictor" )
println( "You can uniquely identify as ", unique_string(p) )

# Add first symbol
add!( p, data[1] )
corr_pred = 0   # Create a counter for correct predictions
for idx = 2:length(data)
    # Predict a symbol from model
    prediction = get_best_symbol( p )
    # Compare
    corr_pred += (prediction==data[idx])?1:0
    # Add next symbol
    add!( p, data[idx] )
end

# Print out accuracy
println( "Accuracy of ", info_string(p), " : ", corr_pred/(length(data)-1) )

# Get current prediction table
println( "Predictions: ", predict(p) )

# Print out size of model
println( "Size of ", info_string(p), ": ", size(p), " nodes" )

# Print out prediction model
println( "Model: \n", p.model )

