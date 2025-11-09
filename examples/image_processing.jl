using Lattice, Plots

println("=== Image Processing Examples ===")

function create_gradient_image(width, height)
    data = zeros(Float64, height, width)
    for i in 1:height
        for j in 1:width
            data[i, j] = (i/height + j/width) / 2
        end
    end
    return Lattice.Grid(data)
end

image = create_gradient_image(20, 20)
println("Original image:")
Lattice.show_ascii(image)

blurred = Lattice.blur_image(image, 5)
println("\nBlurred image:")
Lattice.show_ascii(blurred)

edges = Lattice.edge_detect_image(image)
println("\nEdge detection:")
Lattice.show_ascii(edges)

kernel = Lattice.Grid([-1.0 0.0 1.0; -2.0 0.0 2.0; -1.0 0.0 1.0]) 
convolved = Lattice.convolve(image, kernel)
println("\nSobel filter applied:")
Lattice.show_ascii(convolved)

plot_obj = Lattice.show_comparison(image, blurred)
savefig(plot_obj, "image_comparison.png")
println("\nComparison plot saved as 'image_comparison.png'")

println("\nImage processing pipeline:")
processed = image |>
    x -> Lattice.blur_image(x, 3) |>
    x -> Lattice.edge_detect_image(x) |>
    x -> Lattice.map_grid(abs, x)

Lattice.show_ascii(processed)
