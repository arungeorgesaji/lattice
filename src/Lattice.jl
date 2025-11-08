module Lattice

module Core
    include("core/Grid.jl")
    include("core/operations.jl")
    include("core/transforms.jl")
    export Grid, zeros_grid, ones_grid, random_grid, map_grid, transform
end
using .Core

module Images
    include("domains/images.jl")
    export load_image, save_image, blur_image, sharpen_image, edge_detect_image
end
using .Images

module Text
    include("domains/text.jl")
    export text_to_grid, grid_to_text, text_sliding_window, text_similarity, generate_text
end
using .Text

module IO
    include("io/fileio.jl")
    include("io/visualization.jl")
    export save_grid, load_grid, save_grid_text, load_grid_text, save_grid_json, load_grid_json
    export show_ascii, show_heatmap, show_surface, show_comparison, animate_transformation, visualize_convolution, visualize_filters
end
using .IO

module NN
    include("domains/nn.jl")
end
using .NN

export Grid, zeros_grid, ones_grid, random_grid
export map_grid, transform
export convolve, blur_kernel, edge_detection_kernel, sharpen_kernel
export load_image, save_image, blur_image, sharpen_image, edge_detect_image
export text_to_grid, grid_to_text, text_sliding_window, text_similarity, generate_text
export save_grid, load_grid, save_grid_text, load_grid_text, save_grid_json, load_grid_json
export show_ascii, show_heatmap, show_surface, show_comparison, animate_transformation, visualize_convolution, visualize_filters
export DenseLayer, ConvLayer, relu, sigmoid

end
