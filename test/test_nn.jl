using Test, Lattice

@testset "Neural Networks" begin
    layer = Lattice.DenseLayer(3, 2)
    input = Lattice.Grid([1.0 2.0 3.0]')  
    
    output = layer(input)
    @test size(output) == (2, 1)
    @test output isa Lattice.Grid
    
    relu_out = Lattice.relu(Lattice.Grid([-1.0, 0.0, 1.0]))
    @test all(relu_out.data .== [0.0, 0.0, 1.0])
    
    conv_layer = Lattice.ConvLayer(1, 2, 3)
    image = Lattice.random_grid(10, 10)
    conv_out = conv_layer(image)
    @test conv_out isa Lattice.Grid
end
