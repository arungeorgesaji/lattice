using Test, Lattice

@testset "Grid Basics" begin
    grid = Lattice.zeros_grid(2, 2)
    @test size(grid) == (2, 2)
    @test Lattice.ndims(grid) == 2
    @test Lattice.eltype(grid) == Float64
end
