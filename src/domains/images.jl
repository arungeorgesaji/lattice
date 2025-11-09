module Images

using ...GridCore: Grid, convolve, blur_kernel, sharpen_kernel, edge_detection_kernel

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
    convolve(grid, kernel; mode=:same)
end

function sharpen_image(grid::Grid)
    convolve(grid, sharpen_kernel(); mode=:same)
end

function edge_detect_image(grid::Grid)
    convolve(grid, edge_detection_kernel(); mode=:same)
end

export load_image, save_image, blur_image, sharpen_image, edge_detect_image

end
