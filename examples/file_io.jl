using Lattice

println("=== File I/O and Serialization Examples ===")

grids = Dict(
    "random_10x10" => Lattice.random_grid(10, 10),
    "ones_5x5" => Lattice.ones_grid(5, 5),
    "gradient_8x8" => Lattice.Grid([i*j for i in 1:8, j in 1:8] ./ 64)
)

println("1. Binary Serialization")
for (name, grid) in grids
    filename = "$name.bin"
    Lattice.save_grid(grid, filename)
    loaded_grid = Lattice.load_grid(filename)
    
    println("$name:")
    println("  Original shape: ", size(grid))
    println("  Loaded shape: ", size(loaded_grid))
    println("  Data preserved: ", grid.data ≈ loaded_grid.data)
    
    rm(filename)
end

println("\n2. Text Serialization")
for (name, grid) in grids
    if size(grid)[1] <= 8  
        filename = "$name.txt"
        Lattice.save_grid_text(grid, filename)
        loaded_grid = Lattice.load_grid_text(filename)
        
        println("$name:")
        println("  Original:")
        Lattice.show_ascii(grid)
        println("  Loaded:")
        Lattice.show_ascii(loaded_grid)
        println("  Data preserved: ", grid.data ≈ loaded_grid.data)
        
        rm(filename)
    end
end

println("\n3. Domain-Specific Serialization Example")

domains = []

image = Lattice.random_grid(20, 20)
blurred_image = Lattice.blur_image(image, 3)
push!(domains, ("image", image, blurred_image))

sine_wave = Lattice.Audio.generate_sine_wave(440.0, 0.1, 44100)
normalized_audio = Lattice.Audio.normalize_audio(sine_wave)
push!(domains, ("audio", sine_wave, normalized_audio))

for (domain_name, original, processed) in domains
    Lattice.save_grid(original, "$(domain_name)_original.bin")
    Lattice.save_grid(processed, "$(domain_name)_processed.bin")
    
    println("Saved $domain_name data:")
    println("  Original shape: ", size(original))
    println("  Processed shape: ", size(processed))
end

for (domain_name, _, _) in domains
    rm("$(domain_name)_original.bin")
    rm("$(domain_name)_processed.bin")
end
