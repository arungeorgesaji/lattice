module IO

using ..Core: Grid

include("io/fileio.jl")
include("io/visualization.jl")

export save_grid, load_grid, save_grid_text, load_grid_text, save_grid_json, load_grid_json
export show_ascii, show_heatmap, show_surface, show_comparison
export animate_transformation, visualize_convolution, visualize_filters

end
