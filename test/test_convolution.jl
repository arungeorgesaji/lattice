using Test, Lattice

@testset "Convolution" begin
    grid = Lattice.Grid([1 2 3 4; 5 6 7 8; 9 10 11 12])
    kernel = Lattice.Grid([1 0; 0 1])

    result = Lattice.convolve(grid, kernel)
    @test size(result) == (2, 3)
    @test result.data == [7 9 11; 15 17 19]

    blur = Lattice.blur_kernel(3)
    @test size(blur) == (3, 3)
    @test all(blur.data .≈ 1/9)
end
