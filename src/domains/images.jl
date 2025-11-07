using Images, FileIO

function load_image(path::String)::Grid
    img = load(path)
    array = channelview(float.(img))
    if ndims(array) == 3
        gray = dropdims(mean(array, dims=1), dims=1)
        return Grid(gray)
    else
        return Grid(array)
    end
end

function save_image(grid::Grid, path::String)
    array = clamp.(grid.data, 0.0, 1.0)  
    img = colorview(Gray, array)
    save(path, img)
end

function blur_image(grid::Grid, kernel_size=3)
    kernel = blur_kernel(kernel_size)
    convolve(grid, kernel)
end

function sharpen_image(grid::Grid)
    kernel = sharpen_kernel()
    convolve(grid, kernel)
end

function edge_detect_image(grid::Grid)
    kernel = edge_detection_kernel()
    convolve(grid, kernel)
end
