abstract type Optimizer end

struct SGD <: Optimizer
    lr::Float64
    momentum::Float64
    velocity::Dict{Any, Grid}
end

SGD(lr=0.01; momentum=0.0) = SGD(lr, momentum, Dict())

function update!(optimizer::SGD, param::Grid, grad::Grid)
    if optimizer.momentum > 0
        if !haskey(optimizer.velocity, param)
            optimizer.velocity[param] = zeros_grid(size(param)...)
        end
        optimizer.velocity[param] = optimizer.momentum * optimizer.velocity[param] - optimizer.lr * grad
        param.data .+= optimizer.velocity[param].data
    else
        param.data .-= optimizer.lr .* grad.data
    end
end

struct Adam <: Optimizer
    lr::Float64
    beta1::Float64
    beta2::Float64
    epsilon::Float64
    m::Dict{Any, Grid}  
    v::Dict{Any, Grid}  
    t::Int             
end

Adam(lr=0.001; beta1=0.9, beta2=0.999, epsilon=1e-8) = Adam(lr, beta1, beta2, epsilon, Dict(), Dict(), 0)

function update!(optimizer::Adam, param::Grid, grad::Grid)
    optimizer.t += 1
    
    if !haskey(optimizer.m, param)
        optimizer.m[param] = zeros_grid(size(param)...)
        optimizer.v[param] = zeros_grid(size(param)...)
    end
    
    optimizer.m[param] = optimizer.beta1 * optimizer.m[param] + (1 - optimizer.beta1) * grad
    optimizer.v[param] = optimizer.beta2 * optimizer.v[param] + (1 - optimizer.beta2) * (grad .* grad)
    
    m_hat = optimizer.m[param] / (1 - optimizer.beta1^optimizer.t)
    v_hat = optimizer.v[param] / (1 - optimizer.beta2^optimizer.t)
    
    param.data .-= optimizer.lr .* m_hat.data ./ (sqrt.(v_hat.data) .+ optimizer.epsilon)
end
