function convolve(grid::Grid, kernel::Grid; mode::Symbol=:valid)
    data = grid.data
    kh, kw = size(kernel.data)
    pad_h, pad_w = div(kh, 2), div(kw, 2)

    function padarray(arr, ph, pw)
        h, w = size(arr)
        padded = zeros(eltype(arr), h + 2ph, w + 2pw)
        padded[ph+1:ph+h, pw+1:pw+w] .= arr

        padded[1:ph, pw+1:pw+w] .= arr[1:ph, :]            
        padded[ph+h+1:end, pw+1:pw+w] .= arr[end-ph+1:end, :]  
        padded[:, 1:pw] .= padded[:, pw+1:pw+1]            
        padded[:, pw+w+1:end] .= padded[:, pw+w:pw+w]      
        return padded
    end

    if ndims(data) == 3
        h, w, c = size(data)
        if mode == :same
            padded = padarray(data[:, :, 1], pad_h, pad_w)
            result = zeros(eltype(data), h, w, c)
            for ch in 1:c
                padded = padarray(data[:, :, ch], pad_h, pad_w)
                for i in 1:h, j in 1:w
                    region = padded[i:i+kh-1, j:j+kw-1]
                    result[i, j, ch] = sum(region .* kernel.data)
                end
            end
        elseif mode == :valid
            out_h, out_w = h - kh + 1, w - kw + 1
            result = zeros(eltype(data), out_h, out_w, c)
            for ch in 1:c
                for i in 1:out_h, j in 1:out_w
                    region = data[i:i+kh-1, j:j+kw-1, ch]
                    result[i, j, ch] = sum(region .* kernel.data)
                end
            end
        else
            error("Invalid mode. Use :same or :valid.")
        end
        return Grid(result)
    else
        h, w = size(data)
        if mode == :same
            padded = padarray(data, pad_h, pad_w)
            result = zeros(eltype(data), h, w)
            for i in 1:h, j in 1:w
                region = padded[i:i+kh-1, j:j+kw-1]
                result[i, j] = sum(region .* kernel.data)
            end
        elseif mode == :valid
            out_h, out_w = h - kh + 1, w - kw + 1
            result = zeros(eltype(data), out_h, out_w)
            for i in 1:out_h, j in 1:out_w
                region = data[i:i+kh-1, j:j+kw-1]
                result[i, j] = sum(region .* kernel.data)
            end
        else
            error("Invalid mode. Use :same or :valid.")
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
