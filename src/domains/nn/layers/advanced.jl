struct RNNLayer
    W_xh::Grid  
    W_hh::Grid    
    b_h::Grid   
    hidden_size::Int
end

function RNNLayer(input_size::Int, hidden_size::Int)
    W_xh = transform(random_grid(hidden_size, input_size), x -> x * 0.01)
    W_hh = transform(random_grid(hidden_size, hidden_size), x -> x * 0.01)
    b_h = zeros_grid(hidden_size, 1)
    RNNLayer(W_xh, W_hh, b_h, hidden_size)
end

function (layer::RNNLayer)(input::Grid, hidden::Grid=zeros_grid(layer.hidden_size, 1))
    seq_length = size(input, 2)
    outputs = []
    current_hidden = hidden
    
    for t in 1:seq_length
        x_t = Grid(input.data[:, t:t])  
        h_new = tanh(layer.W_xh * x_t + layer.W_hh * current_hidden + layer.b_h)
        push!(outputs, h_new)
        current_hidden = h_new
    end
    
    return outputs, current_hidden
end

struct AttentionLayer
    W_q::Grid  
    W_k::Grid  
    W_v::Grid  
end

function AttentionLayer(hidden_size::Int)
    W_q = transform(random_grid(hidden_size, hidden_size), x -> x * 0.01)
    W_k = transform(random_grid(hidden_size, hidden_size), x -> x * 0.01) 
    W_v = transform(random_grid(hidden_size, hidden_size), x -> x * 0.01)
    AttentionLayer(W_q, W_k, W_v)
end

function (layer::AttentionLayer)(query::Grid, keys::Grid, values::Grid)
    Q = layer.W_q * query
    K = layer.W_k * keys
    V = layer.W_v * values
    
    scores = Q.data' * K.data
    weights = softmax(Grid(scores))
    
    context = V * weights
    return context, weights
end

struct BatchNorm
    gamma::Grid
    beta::Grid
    running_mean::Grid
    running_var::Grid
    momentum::Float64
    eps::Float64
end

function BatchNorm(features::Int; momentum=0.9, eps=1e-5)
    gamma = ones_grid(features, 1)
    beta = zeros_grid(features, 1)
    running_mean = zeros_grid(features, 1)
    running_var = ones_grid(features, 1)
    BatchNorm(gamma, beta, running_mean, running_var, momentum, eps)
end
