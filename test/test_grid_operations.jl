using Test, Lattice

@testset "Grid Operations" begin
    a = Lattice.ones_grid(2, 2)
    b = Lattice.random_grid(2, 2)
    c = Lattice.zeros_grid(2, 2)

    @test size(a) == (2, 2)
    @test a isa Lattice.Grid
    @test eltype(a.data) == Float64
    @test all(c.data .== 0)

    @test all((a + b).data .≈ (a.data .+ b.data))
    @test all((a + 1).data .== 2)
    @test all((1 + a).data .== 2)
    @test all((a - 1).data .== 0)
    @test all((1 - a).data .== 0)
    @test all((a * 2).data .== 2)
    @test all((2 * a).data .== 2)
    @test all((a / 2).data .== 0.5)
    @test all((2 / a).data .== 2)

    mapped = Lattice.map_grid(x -> x + 1, a)
    @test all(mapped.data .== 2)

    transformed = Lattice.transform(a, x -> x^2)
    @test all(transformed.data .== 1)

    @test a[1, 1] == 1.0
    @test collect(a) == collect(a.data)
    @test length(a) == 4

    broadcasted_sum = a .+ b
    @test broadcasted_sum isa Lattice.Grid
    @test size(broadcasted_sum) == size(a)
end
