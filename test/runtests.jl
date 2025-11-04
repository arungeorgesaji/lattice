using Lattice
using Test

grid = Lattice.zeros_grid(2, 2)
@test size(grid) == (2, 2)

double = grid * 2
@test double.data == zeros(2, 2) * 2

println("All tests passed!")
