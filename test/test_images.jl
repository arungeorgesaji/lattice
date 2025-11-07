using Test, Lattice

@testset "Image Domain" begin
    test_grid = Lattice.Grid(rand(10, 10))
    
    blurred = Lattice.blur_image(test_grid, 3)
    @test size(blurred) == (8, 8)  
    
    edges = Lattice.edge_detect_image(test_grid)
    @test size(edges) == (8, 8)
    
    @test blurred isa Lattice.Grid
    @test edges isa Lattice.Grid
end
