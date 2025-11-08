abstract type Model end

struct Sequential <: Model
    layers::Vector{Any}
end

Sequential(layers...) = Sequential(collect(layers))

function (model::Sequential)(x::Grid)
    for layer in model.layers
        x = layer(x)
    end
    return x
end

struct GenericModel <: Model
    layers::Dict{Symbol, Any}
    forward::Function
end

function (model::GenericModel)(x::Grid)
    model.forward(model, x)
end

function get_parameters(model::Sequential)
    params = []
    for layer in model.layers
        if hasfield(typeof(layer), :weights)
            push!(params, layer.weights)
        end
        if hasfield(typeof(layer), :biases)
            push!(params, layer.biases)
        end
        if hasfield(typeof(layer), :kernels)
            append!(params, layer.kernels)
        end
    end
    return params
end

function count_parameters(model::Sequential)
    total = 0
    for param in get_parameters(model)
        total += length(param)
    end
    return total
end
