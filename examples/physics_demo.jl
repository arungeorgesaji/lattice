using Lattice

println("Lattice Physics Simulation Demo")

println("1. Fluid Dynamics")
fluid = Lattice.Physics.FluidSimulation(20, 20)

Lattice.Physics.add_density!(fluid, 10, 10, 5.0)
Lattice.Physics.add_velocity!(fluid, 10, 10, 2.0, 1.0)

println("Initial fluid state:")
Lattice.show_ascii(fluid.density)

for i in 1:5
    Lattice.Physics.step!(fluid, 0.1)
    println("\nStep $i:")
    Lattice.show_ascii(fluid.density)
end

println("\n2. Heat Diffusion")
hot_plate = Lattice.zeros_grid(15, 15)
hot_plate.data[7:9, 7:9] .= 1.0  

cooled = Lattice.Physics.heat_diffusion(hot_plate, 0.1, 20)
println("Heat diffusion result:")
Lattice.show_ascii(cooled)

println("\n3. Particle System")
particles = Lattice.Physics.ParticleSystem(10, 12, 12)

println("Particle positions over time:")
for step in 1:3
    Lattice.Physics.step!(particles, 0.2)
    grid = Lattice.Physics.particles_to_grid(particles)
    println("Step $step:")
    Lattice.show_ascii(grid)
end

println("\n4. Cellular Automata - Game of Life")
glider = Lattice.zeros_grid(8, 8)
glider.data[2, 3] = 1.0
glider.data[3, 4] = 1.0
glider.data[4, 2:4] .= 1.0

println("Glider initial:")
Lattice.show_ascii(glider)

evolved = Lattice.Physics.game_of_life(glider, 4)
println("Glider after 4 steps:")
Lattice.show_ascii(evolved)

println("Physics simulations complete!")
