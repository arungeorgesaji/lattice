using Lattice
using Plots

println("\n1. 2D SHAPE GENERATION")
println("   Creating geometric shapes...")

circle = Lattice.Graphics.create_circle(6, 10, 10, (20, 20))
rectangle = Lattice.Graphics.create_rectangle(8, 4, 6, 8, (20, 20))
line = Lattice.Graphics.create_line(2, 2, 18, 18, (20, 20))

println("   Circle:")
Lattice.show_ascii(circle)
println("\n   Rectangle:")
Lattice.show_ascii(rectangle)
println("\n   Diagonal Line:")
Lattice.show_ascii(line)

println("\n2. PATTERN GENERATION")
checkerboard = Lattice.Graphics.create_checkerboard(12, 3)
gradient = Lattice.Graphics.create_gradient(12, :vertical)

println("   Checkerboard:")
Lattice.show_ascii(checkerboard)
println("\n   Vertical Gradient:")
Lattice.show_ascii(gradient)

println("\n3. 2D TRANSFORMATIONS")
triangle = Lattice.zeros_grid(8, 8)
triangle.data[2, 4] = 1.0
triangle.data[3, 3:5] .= 1.0
triangle.data[4, 2:6] .= 1.0

println("   Original Triangle:")
Lattice.show_ascii(triangle)

rotated = Lattice.Graphics.rotate_2d(triangle, π/6)  
println("\n   Rotated Triangle (30°):")
Lattice.show_ascii(rotated)

println("\n4. MORPHOLOGICAL OPERATIONS")
small_shape = Lattice.zeros_grid(10, 10)
small_shape.data[4:6, 4:6] .= 1.0

println("   Original Shape:")
Lattice.show_ascii(small_shape)

dilated = Lattice.Graphics.dilate(small_shape, 3)
println("\n   After Dilation:")
Lattice.show_ascii(dilated)

eroded = Lattice.Graphics.erode(dilated, 3)
println("\n   After Erosion:")
Lattice.show_ascii(eroded)

println("\n5. 3D RAY MARCHING")
println("   Generating 3D sphere using ray marching...")

output_dir = "output"
if !isdir(output_dir)
    mkdir(output_dir)
    println("   Created output directory: $output_dir")
else
    ray_march_files = filter(x -> occursin("ray_marched", x), readdir(output_dir))
    for file in ray_march_files
        rm(joinpath(output_dir, file))
        println("   Removed previous file: $file")
    end
end

timestamp = round(Int, time())
output_path = joinpath(output_dir, "ray_marched_sphere_$(timestamp).png")

sphere_render = Lattice.Graphics.ray_march_sdf(Lattice.Graphics.sphere_sdf, 50, 3.0)

heatmap(sphere_render.data, 
        title="Ray Marched Sphere - $(timestamp)",
        aspect_ratio=:equal,
        color=:viridis,
        size=(600, 600))
savefig(output_path)
println("   Saved as '$output_path'")

println("\n   Generating multiple 3D shapes for comparison...")

shapes = [
    ("Sphere", Lattice.Graphics.sphere_sdf),
    ("Box", (x,y,z) -> Lattice.Graphics.box_sdf(x,y,z, 0.4))
]

for (name, sdf_func) in shapes
    render = Lattice.Graphics.ray_march_sdf(sdf_func, 64, 3.0)
    output_file = joinpath(output_dir, "ray_marched_$(lowercase(name))_$(timestamp).png")
    
    heatmap(render.data,
            title="Ray Marched $name",
            aspect_ratio=:equal,
            color=:viridis,
            size=(600, 600))
    savefig(output_file)
    println("   Saved $name as '$output_file'")
end

