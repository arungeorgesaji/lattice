using Lattice

println("=== Basic Grid Operations ===")

zeros_grid = Lattice.zeros_grid(3, 3)
ones_grid = Lattice.ones_grid(3, 3)
random_grid = Lattice.random_grid(3, 3)

println("Zeros grid:")
Lattice.show_ascii(zeros_grid)

println("\nOnes grid:")
Lattice.show_ascii(ones_grid)

println("\nRandom grid:")
Lattice.show_ascii(random_grid)

result = ones_grid + random_grid * 2
println("\nArithmetic operations:")
Lattice.show_ascii(result)

mapped = Lattice.map_grid(x -> x^2, ones_grid)
println("\nSquared elements:")
Lattice.show_ascii(mapped)

broadcasted = ones_grid .+ random_grid
println("\nBroadcasted addition:")
Lattice.show_ascii(broadcasted)

println("\nGrid indexing:")
println("Element at (1,1): ", result[1, 1])

println("\nGrid iteration:")
for (i, element) in enumerate(result)
    println("Element $i: $element")
end
