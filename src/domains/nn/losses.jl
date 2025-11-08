function mse_loss(y_pred::Grid, y_true::Grid)
    diff = y_pred - y_true
    mean(diff .* diff)
end

function cross_entropy_loss(y_pred::Grid, y_true::Grid)
    eps = 1e-8
    -mean(y_true.data .* log.(y_pred.data .+ eps))
end

function binary_cross_entropy(y_pred::Grid, y_true::Grid)
    eps = 1e-8
    term1 = y_true.data .* log.(y_pred.data .+ eps)
    term2 = (1 .- y_true.data) .* log.(1 .- y_pred.data .+ eps)
    -mean(term1 + term2)
end

function categorical_cross_entropy(y_pred::Grid, y_true::Grid)
    eps = 1e-8
    -mean(sum(y_true.data .* log.(y_pred.data .+ eps), dims=1))
end

function huber_loss(y_pred::Grid, y_true::Grid; delta=1.0)
    diff = abs.(y_pred.data - y_true.data)
    mask = diff .< delta
    loss = zeros(size(diff))
    loss[mask] = 0.5 .* diff[mask].^2
    loss[.!mask] = delta .* (diff[.!mask] .- 0.5 * delta)
    mean(loss)
end
