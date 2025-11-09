using Test, Lattice

@testset "Graphics Domain" begin
    @testset "2D Shapes" begin
        circle = Lattice.Graphics.create_circle(5, 8, 8, (16, 16))
        @test size(circle) == (16, 16)
        @test maximum(circle.data) == 1.0
        
        rect = Lattice.Graphics.create_rectangle(4, 3, 2, 2, (10, 10))
        @test sum(rect.data) == 12.0 
    end
    
    @testset "3D Voxels" begin
        sphere = Lattice.Graphics.create_sphere_voxel(3, (5, 5, 5), (10, 10, 10))
        @test size(sphere.data) == (10, 10, 10)
        @test maximum(sphere.data) == 1.0
    end
    
    @testset "Transformations" begin
        square = Lattice.Graphics.create_rectangle(4, 4, 1, 1, (6, 6))
        rotated = Lattice.Graphics.rotate_2d(square, π/4)  
        @test size(rotated) == (6, 6)
        
        scaled = Lattice.Graphics.scale_2d(square, 2.0, 2.0)
        @test size(scaled) == (12, 12)
    end
    
    @testset "Patterns" begin
        checker = Lattice.Graphics.create_checkerboard(8, 2)
        @test size(checker) == (8, 8)
        
        gradient = Lattice.Graphics.create_gradient(10, :horizontal)
        @test gradient.data[5, 1] ≈ 0.1
        @test gradient.data[5, 10] ≈ 1.0
    end
    
    @testset "Morphological Operations" begin
        test_grid = Lattice.zeros_grid(5, 5)
        test_grid.data[3, 3] = 1.0
        
        dilated = Lattice.Graphics.dilate(test_grid, 3)
        @test sum(dilated.data) > 1.0 
        
        eroded = Lattice.Graphics.erode(dilated, 3)
        @test sum(eroded.data) >= 1.0
    end
    
    println("Graphics domain tests passed!")
end
