using Plots

function show_ascii(grid::Grid; chars=" ░▒▓█", threshold=nothing)
    data = grid.data
    chars_vec = collect(chars)  
    
    if threshold === nothing
        min_val, max_val = extrema(data)
        normalized = (data .- min_val) ./ (max_val - min_val)
    else
        normalized = data .>= threshold
    end

    char_array = map(n -> chars_vec[clamp(floor(Int, n * length(chars_vec)) + 1, 1, length(chars_vec))], normalized)
    
    for i in 1:size(char_array, 1)
        println(join(char_array[i, :], ""))
    end
    
    return nothing
end

function show_heatmap(grid::Grid; title="Grid")
    heatmap(grid.data, title=title, aspect_ratio=:equal)
end

function show_surface(grid::Grid; title="Grid Surface")
    surface(grid.data, title=title)
end

function show_comparison(grid1::Grid, grid2::Grid; titles=["Grid 1", "Grid 2"])
    @assert size(grid1) == size(grid2) "Grids must have same size for comparison"
    
    p1 = heatmap(grid1.data, title=titles[1], aspect_ratio=:equal)
    p2 = heatmap(grid2.data, title=titles[2], aspect_ratio=:equal) 
    p3 = heatmap(grid1.data .- grid2.data, title="Difference", aspect_ratio=:equal)
    
    plot(p1, p2, p3, layout=(1, 3), size=(1200, 400))
end

function animate_transformation(initial::Grid, transform_func; steps=10, fps=5)
    results = [initial]
    current = initial
    
    for i in 1:steps
        current = transform_func(current)
        push!(results, current)
    end
    
    anim = @animate for grid in results
        heatmap(grid.data, aspect_ratio=:equal, title="Step $(findfirst(==(grid), results))")
    end
    
    gif(anim, fps=fps)
    return results
end

function visualize_convolution(grid::Grid, kernel::Grid)
    result = convolve(grid, kernel)
    show_comparison(grid, result, titles=["Original", "Convolved"])
    return result
end

function visualize_filters(grid::Grid)
    blurred = convolve(grid, blur_kernel(3))
    sharpened = convolve(grid, sharpen_kernel()) 
    edges = convolve(grid, edge_detection_kernel())
    
    p1 = heatmap(grid.data, title="Original", aspect_ratio=:equal)
    p2 = heatmap(blurred.data, title="Blurred", aspect_ratio=:equal)
    p3 = heatmap(sharpened.data, title="Sharpened", aspect_ratio=:equal)
    p4 = heatmap(edges.data, title="Edges", aspect_ratio=:equal)
    
    plot(p1, p2, p3, p4, layout=(2, 2), size=(800, 600))
end
