function train!(model::Sequential, X::Vector{Grid}, Y::Vector{Grid}, 
                loss_fn, optimizer; epochs=10, verbose=true)
    
    losses = Float64[]
    for epoch in 1:epochs
        epoch_loss = 0.0
        
        for (x, y) in zip(X, Y)
            y_pred = model(x)
            loss = loss_fn(y_pred, y)
            epoch_loss += loss
            
            grads = approximate_gradients(model, x, y, loss_fn)
            
            params = get_parameters(model)
            for (param, grad) in zip(params, grads)
                update!(optimizer, param, grad)
            end
        end
        
        avg_loss = epoch_loss / length(X)
        push!(losses, avg_loss)
        
        if verbose && epoch % 10 == 0
            println("Epoch $epoch, Loss: $avg_loss")
        end
    end
    
    return losses
end

function approximate_gradients(model, x, y, loss_fn)
    params = get_parameters(model)
    grads = []
    
    for param in params
        grad = zeros_grid(size(param)...)
        original_data = copy(param.data)
        eps = 1e-6
        
        for idx in eachindex(param.data)
            param.data[idx] += eps
            y_pred_plus = model(x)
            loss_plus = loss_fn(y_pred_plus, y)
            
            param.data[idx] = original_data[idx] - eps
            y_pred_minus = model(x)
            loss_minus = loss_fn(y_pred_minus, y)
            
            grad.data[idx] = (loss_plus - loss_minus) / (2 * eps)
            
            param.data[idx] = original_data[idx]
        end
        
        push!(grads, grad)
    end
    
    return grads
end

struct Accuracy end

function (::Accuracy)(y_pred::Grid, y_true::Grid)
    if size(y_pred) == size(y_true)
        pred_labels = map(x -> x > 0.5, y_pred.data)
        true_labels = map(x -> x > 0.5, y_true.data)
        mean(pred_labels .== true_labels)
    else
        y_mean = mean(y_true.data)
        total_variance = sum((y_true.data .- y_mean).^2)
        residual_variance = sum((y_true.data .- y_pred.data).^2)
        1 - residual_variance / total_variance
    end
end

function save_model(model::Sequential, filename::String)
    model_data = Dict(
        "layers" => model.layers,
        "type" => "Sequential"
    )
    open(filename, "w") do io
        serialize(io, model_data)
    end
end

function load_model(filename::String)::Sequential
    model_data = open(deserialize, filename)
    return Sequential(model_data["layers"])
end
