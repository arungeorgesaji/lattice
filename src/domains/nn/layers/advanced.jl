using LogExpFunctions

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
    outputs = Grid[]
    current_hidden = hidden
    
    for t in 1:seq_length
        x_t = Grid(reshape(input.data[:, t], (size(input, 1), 1)))  
        
        linear_combo = Grid(layer.W_xh.data * x_t.data + 
                           layer.W_hh.data * current_hidden.data + 
                           layer.b_h.data)
        h_new = tanh(linear_combo)
        
        push!(outputs, h_new)
        current_hidden = h_new
    end
    
    return outputs, current_hidden
end

function softmax(grid::Grid)
    data = grid.data
    exps = exp.(data .- maximum(data, dims=1))
    Grid(exps ./ sum(exps, dims=1))
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
    Q_data = layer.W_q.data * query.data      
    K_data = layer.W_k.data * keys.data       
    V_data = layer.W_v.data * values.data   
    
    scores = Q_data' * K_data               
    weights = softmax(Grid(scores))           
    
    context_data = V_data * weights.data'     
    context = Grid(context_data)
    
    return context, Grid(weights.data')
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
