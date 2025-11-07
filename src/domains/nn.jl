struct DenseLayer
    weights::Grid
    biases::Grid
end

function DenseLayer(input_size::Int, output_size::Int)
    weights = random_grid(output_size, input_size) .* 0.1
    biases  = zeros_grid(output_size, 1)  
    DenseLayer(weights, biases)
end

function (layer::DenseLayer)(input::Grid)
    result = layer.weights.data * input.data .+ layer.biases.data
    Grid(result)
end

relu(x::Grid) = transform(x, x -> max(0, x))
sigmoid(x::Grid) = transform(x, x -> 1 / (1 + exp(-x)))

struct ConvLayer
    kernels::Vector{Grid}
    biases::Grid
end

function ConvLayer(input_channels::Int, output_channels::Int, kernel_size::Int)
    kernels = [random_grid(kernel_size, kernel_size) .* 0.1
               for _ in 1:output_channels]
    biases = zeros_grid(output_channels, 1)
    ConvLayer(kernels, biases)
end

function (layer::ConvLayer)(input::Grid)
    feature_maps = [convolve(input, k) for k in layer.kernels]
    
    stacked = cat([fm.data for fm in feature_maps]..., dims=3)
    
    biased = stacked .+ reshape(layer.biases.data, 1, 1, :)
    
    relu(Grid(biased))
end
