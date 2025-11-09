struct DenseLayer
    weights::Grid
    biases::Grid
end

function DenseLayer(input_size::Int, output_size::Int; init_scale=0.1)
    scale = init_scale * sqrt(2.0 / (input_size + output_size))
    weights = transform(random_grid(output_size, input_size), x -> x * scale)
    biases = zeros_grid(output_size, 1)
    DenseLayer(weights, biases)
end

function (layer::DenseLayer)(input::Grid)
    result = layer.weights.data * input.data .+ layer.biases.data
    Grid(result)
end 

struct ConvLayer
    kernels::Vector{Grid}
    biases::Grid
    stride::Int
    padding::Int
end

function ConvLayer(input_channels::Int, output_channels::Int, kernel_size::Int; 
                   stride=1, padding=0)
    scale = sqrt(2.0 / (input_channels * kernel_size * kernel_size))
    kernels = [transform(random_grid(kernel_size, kernel_size), x -> x * scale)
               for _ in 1:output_channels]
    biases = zeros_grid(output_channels, 1)
    ConvLayer(kernels, biases, stride, padding)
end

function (layer::ConvLayer)(input::Grid)
    data = input.data
    
    if ndims(data) == 2
        h, w = size(data)
        data = reshape(data, h, w, 1)
        input = Grid(data)
    end
    
    h_in, w_in, c_in = size(data)
    
    feature_maps = []
    for kernel in layer.kernels
        channel_map = zeros(h_in - size(kernel.data, 1) + 1, 
                           w_in - size(kernel.data, 2) + 1)
        
        for ch in 1:c_in
            input_channel = Grid(data[:, :, ch])
            conv_result = convolve(input_channel, kernel, mode=:valid)
            channel_map .+= conv_result.data
        end
        
        push!(feature_maps, Grid(channel_map))
    end
    
    if layer.stride > 1
        feature_maps = [Grid(fm.data[1:layer.stride:end, 1:layer.stride:end]) 
                       for fm in feature_maps]
    end
    
    if isempty(feature_maps)
        return input
    end
    
    h, w = size(feature_maps[1])
    c = length(feature_maps)
    
    stacked = zeros(eltype(input), h, w, c)
    for (ch, fm) in enumerate(feature_maps)
        stacked[:, :, ch] = fm.data
    end
    
    biased = stacked .+ reshape(layer.biases.data, 1, 1, :)
    
    relu(Grid(biased))
end

relu(x::Grid) = transform(x, x -> max(0, x))
sigmoid(x::Grid) = transform(x, x -> 1 / (1 + exp(-x)))
tanh(x::Grid) = transform(x, x -> Base.tanh(x))
softplus(x::Grid) = transform(x, x -> log(1 + exp(x)))
