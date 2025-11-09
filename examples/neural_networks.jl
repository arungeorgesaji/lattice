using Lattice, Lattice.NN

println("=== Neural Network Examples ===")

println("1. Binary Classification Network")

model = Lattice.NN.Sequential(
    Lattice.NN.DenseLayer(10, 20),
    Lattice.NN.relu,
    Lattice.NN.DenseLayer(20, 10),
    Lattice.NN.relu,
    Lattice.NN.DenseLayer(10, 1),
    Lattice.NN.sigmoid
)

X_train = Lattice.random_grid(10, 100)  
y_train = Lattice.Grid(rand(1, 100) .> 0.5)  

predictions = model(X_train)
println("Predictions shape: ", size(predictions))
println("First 5 predictions: ", predictions.data[1:5])

println("\n2. Convolutional Neural Network")

cnn = Lattice.NN.Sequential(
    Lattice.NN.ConvLayer(1, 16, 3, padding=1),
    Lattice.NN.relu,
    Lattice.NN.MaxPool(2),
    Lattice.NN.ConvLayer(16, 32, 3, padding=1),
    Lattice.NN.relu,
    Lattice.NN.MaxPool(2),
    Lattice.NN.GlobalAvgPool(),
    Lattice.NN.DenseLayer(32, 10),
    Lattice.NN.softplus
)

image = Lattice.random_grid(28, 28)  
cnn_output = cnn(image)
println("CNN output shape: ", size(cnn_output))
println("CNN output: ", cnn_output.data)

println("\n3. Recurrent Neural Network")

rnn = Lattice.NN.RNNLayer(10, 16)
sequence = Lattice.random_grid(10, 5)  
outputs, final_state = rnn(sequence)

println("Number of outputs: ", length(outputs))
println("Final hidden state shape: ", size(final_state))

println("\n4. Simple Training Example")

simple_model = Lattice.NN.Sequential(
    Lattice.NN.DenseLayer(2, 4),
    Lattice.NN.relu,
    Lattice.NN.DenseLayer(4, 1),
    Lattice.NN.sigmoid
)

X = Lattice.Grid([0 0 1 1; 0 1 0 1])
y = Lattice.Grid([0 1 1 0])

optimizer = Lattice.NN.Adam(0.01)
epochs = 100

println("Training XOR classifier...")
for epoch in 1:epochs
    pred = simple_model(X)
    loss = Lattice.NN.binary_cross_entropy(pred, y)
    
    if epoch % 20 == 0
        println("Epoch $epoch, Loss: $loss")
    end
end

param_count = Lattice.NN.count_parameters(model)
println("\nTotal parameters in model: $param_count")
