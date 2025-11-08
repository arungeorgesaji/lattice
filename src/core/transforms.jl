function convolve(grid::Grid, kernel::Grid)
    if ndims(grid) == 3
        h, w, c = size(grid)
        kh, kw = size(kernel)
        out_h, out_w = h - kh + 1, w - kw + 1
        
        result = zeros(eltype(grid), out_h, out_w)
        for ch in 1:c
            for i in 1:out_h, j in 1:out_w
                region = grid.data[i:i+kh-1, j:j+kw-1, ch]
                result[i, j] += sum(region .* kernel.data)
            end
        end
        return Grid(result)
    else
        h, w = size(grid)
        kh, kw = size(kernel)
        out_h, out_w = h - kh + 1, w - kw + 1
        
        result = zeros(eltype(grid), out_h, out_w)
        for i in 1:out_h, j in 1:out_w
            region = grid.data[i:i+kh-1, j:j+kw-1]
            result[i, j] = sum(region .* kernel.data)
        end
        return Grid(result)
    end
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
