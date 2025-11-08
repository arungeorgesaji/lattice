using Test, Lattice, Lattice.Domains.TextRep

@testset "Text Domain" begin
    test_text = "hello"
    
    grid = Lattice.text_to_grid(test_text, method=:character)
    @test size(grid) == (5, 1)
    reconstructed = Lattice.grid_to_text(grid, method=:character)
    @test reconstructed == test_text
    
    vocab = ['h', 'e', 'l', 'o']
    one_hot = Lattice.text_to_grid(test_text, method=:one_hot, vocab=vocab)
    @test size(one_hot) == (4, 5)
    reconstructed = Lattice.grid_to_text(one_hot, method=:one_hot, vocab=vocab)
    @test reconstructed == test_text
    
    windowed = Lattice.text_sliding_window("hello", 3)
    @test size(windowed) == (3, 3)  
    
    expected_windows = [
        "hel", "ell", "llo"
    ]
    for (i, expected) in enumerate(expected_windows)
        window_text = Lattice.grid_to_text(Lattice.Grid(windowed.data[i:i, :]), method=:character)
        @test strip(window_text) == expected
    end
    
    grid1 = Lattice.text_to_grid("hello", method=:character)
    grid2 = Lattice.text_to_grid("hello", method=:character)
    sim = Lattice.text_similarity(grid1, grid2)
    @test sim ≈ 1.0  
    
    grid3 = Lattice.text_to_grid("world", method=:character)
    sim2 = Lattice.text_similarity(grid1, grid3)
    @test sim2 < 0.999
    
    println("Text domain tests passed!")
end
