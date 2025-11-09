using Test, Lattice

@testset "Physics Domain" begin
    @testset "Fluid Dynamics" begin
        fluid = Lattice.Physics.FluidSimulation(10, 10)
        @test size(fluid.density) == (10, 10)
        
        Lattice.Physics.add_density!(fluid, 5, 5, 1.0)
        @test fluid.density.data[5, 5] ≈ 1.0
        
        initial = Lattice.zeros_grid(5, 5)
        initial.data[3, 3] = 1.0
        diffused = Lattice.Physics.diffuse!(initial, 0.1, 0.1)
        @test maximum(diffused.data) <= 1.0
    end
    
    @testset "Heat Diffusion" begin
        initial_temp = Lattice.zeros_grid(8, 8)
        initial_temp.data[4, 4] = 100.0        
        cooled = Lattice.Physics.heat_diffusion(initial_temp, 0.1, 10)
        @test maximum(cooled.data) < 100.0  
        @test sum(cooled.data) ≈ sum(initial_temp.data)  
    end
    
    @testset "Particle Systems" begin
        system = Lattice.Physics.ParticleSystem(5, 10, 10)
        @test length(system.particles) == 5
        
        initial_y = system.particles[1].y
        Lattice.Physics.step!(system, 0.1)
        @test system.particles[1].y > initial_y  
        
        grid = Lattice.Physics.particles_to_grid(system)
        @test size(grid) == (10, 10)
    end
    
    @testset "Cellular Automata" begin
        initial = Lattice.zeros_grid(5, 5)
        initial.data[2, 2:4] .= 1.0  
        
        evolved = Lattice.Physics.game_of_life(initial, 1)
        @test evolved.data[2, 2] ≈ 0.0  
        @test evolved.data[1, 3] ≈ 1.0
        @test evolved.data[2, 3] ≈ 1.0
        @test evolved.data[3, 3] ≈ 1.0
    end
    
    println("Physics domain tests passed!")
end
