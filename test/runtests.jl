using Test, Lattice

println("Running Lattice test suite...\n")

test_files = [
    "test_grid_basics.jl",
    "test_grid_operations.jl",
    "test_convolution.jl",
    "test_images.jl",
    "test_fileio.jl",
    "test_text.jl",
    "test_nn.jl",
    "test_visualization.jl",
    "test_audio.jl"
]

for file in test_files
    fullpath = joinpath(@__DIR__, file)
    println("Running $(basename(file))...")
    include(fullpath)
end

println("\nAll tests executed.")
