module Text

using ..Core: Grid

include("domains/text.jl")

export text_to_grid, grid_to_text, text_sliding_window, text_similarity, generate_text

end
