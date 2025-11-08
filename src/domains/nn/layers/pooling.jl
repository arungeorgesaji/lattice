struct MaxPool
    pool_size::Int
    stride::Int
end

MaxPool(pool_size=2) = MaxPool(pool_size, pool_size)

function (pool::MaxPool)(input::Grid)
    if ndims(input) == 3
        h, w, c = size(input)
        out_h = (h - pool.pool_size) ÷ pool.stride + 1
        out_w = (w - pool.pool_size) ÷ pool.stride + 1
        
        result = zeros(eltype(input), out_h, out_w, c)
        for ch in 1:c, i in 1:out_h, j in 1:out_w
            h_start = (i-1)*pool.stride + 1
            w_start = (j-1)*pool.stride + 1
            region = input.data[h_start:h_start+pool.pool_size-1, 
                               w_start:w_start+pool.pool_size-1, ch]
            result[i, j, ch] = maximum(region)
        end
        Grid(result)
    else
        h, w = size(input)
        out_h = (h - pool.pool_size) ÷ pool.stride + 1
        out_w = (w - pool.pool_size) ÷ pool.stride + 1
        
        result = zeros(eltype(input), out_h, out_w)
        for i in 1:out_h, j in 1:out_w
            h_start = (i-1)*pool.stride + 1
            w_start = (j-1)*pool.stride + 1
            region = input.data[h_start:h_start+pool.pool_size-1, 
                               w_start:w_start+pool.pool_size-1]
            result[i, j] = maximum(region)
        end
        Grid(result)
    end
end

struct GlobalAvgPool end

function (::GlobalAvgPool)(input::Grid)
    if ndims(input) == 3
        avg = dropdims(mean(input.data, dims=(1, 2)), dims=(1, 2))
        Grid(reshape(avg, (length(avg), 1)))  
    else
        Grid([mean(input.data)])
    end
end
