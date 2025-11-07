using Test, Lattice

@testset "File I/O" begin
    test_grid = Lattice.Grid([1.0 2.0; 3.0 4.0])
    
    Lattice.save_grid(test_grid, "test_grid.bin")
    loaded = Lattice.load_grid("test_grid.bin")
    @test loaded.data == test_grid.data
    
    Lattice.save_grid_text(test_grid, "test_grid.txt")
    loaded_text = Lattice.load_grid_text("test_grid.txt")
    @test loaded_text.data ≈ test_grid.data
    
    rm("test_grid.bin", force=true)
    rm("test_grid.txt", force=true)
end
