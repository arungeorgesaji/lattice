module Images

using ..Core: Grid

include("domains/images.jl")

export load_image, save_image, blur_image, sharpen_image, edge_detect_image

end
