using Test, Lattice, Plots

@testset "Visualization" begin
    test_grid = Lattice.Grid([0.1 0.9; 0.5 0.2])
    
    @test nothing == Lattice.show_ascii(test_grid)
    
    grid2 = Lattice.Grid([0.9 0.1; 0.2 0.5])
    plot_obj = Lattice.show_comparison(test_grid, grid2)
    @test plot_obj isa Plots.Plot
    
    println("Visualization tests passed!")
end
