function convolve(grid::Grid, kernel::Grid)
    data = grid.data
    k = kernel.data
    k_height, k_width = size(k)
    g_height, g_width = size(data)
    
    out_height = g_height - k_height + 1
    out_width = g_width - k_width + 1
    result = zeros(eltype(data), out_height, out_width)
    
    for i in 1:out_height
        for j in 1:out_width
            region = data[i:i+k_height-1, j:j+k_width-1]
            result[i, j] = sum(region .* k)
        end
    end
    
    return Grid(result)
end

function blur_kernel(size=3)
    k = ones(size, size) / (size * size)
    return Grid(k)
end

function edge_detection_kernel()
    k = [-1 -1 -1; -1 8 -1; -1 -1 -1]
    return Grid(k)
end

function sharpen_kernel()
    k = [0 -1 0; -1 5 -1; 0 -1 0]
    return Grid(k)
end
