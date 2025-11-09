using Lattice

function show_enhanced(grid::Lattice.Grid, title::String="")
    if !isempty(title)
        println("\n" * "="^50)
        println(title)
        println("="^50)
    end
    
    max_val = maximum(grid.data)
    min_val = minimum(grid.data)
    range_val = max_val - min_val
    
    if range_val < 1e-10
        range_val = 1.0
    end
    
    chars = [' ', '░', '▒', '▓', '█']
    
    for i in 1:size(grid.data, 1)
        for j in 1:size(grid.data, 2)
            normalized = (grid.data[i, j] - min_val) / range_val
            idx = min(5, max(1, Int(ceil(normalized * 5))))
            print(chars[idx])
        end
        println()
    end
end

println("\n1. FLUID DYNAMICS - Smoke Plume")
println("   Adding strong central source with velocity...")
fluid = Lattice.Physics.FluidSimulation(25, 25, diffusion=0.02, viscosity=0.01)
Lattice.Physics.add_density!(fluid, 13, 20, 100.0)
Lattice.Physics.add_velocity!(fluid, 13, 20, 0.0, -15.0)  
show_enhanced(fluid.density, "Initial State (t=0)")

for i in 1:8
    if i <= 5
        Lattice.Physics.add_density!(fluid, 13, 20, 50.0)
        Lattice.Physics.add_velocity!(fluid, 13, 20, rand(-2.0:0.5:2.0), -10.0)
    end
    
    Lattice.Physics.step!(fluid, 0.1)
    show_enhanced(fluid.density, "Step $i - Fluid Rising")
    sleep(0.3)  
end

println("\n\n2. HEAT DIFFUSION - Hot Spot Spreading")
println("   Central heat source diffusing outward...")
hot_plate = Lattice.zeros_grid(20, 20)
hot_plate.data[9:12, 9:12] .= 100.0
show_enhanced(hot_plate, "Initial Temperature (t=0)")

for step in [5, 10, 15, 20, 30]
    cooled = Lattice.Physics.heat_diffusion(hot_plate, 0.15, step)
    show_enhanced(cooled, "After $step time steps")
end

println("\n\n3. WAVE PROPAGATION - Ripple Effect")
println("   Water drop creating expanding ripples...")
water = Lattice.zeros_grid(20, 20)
velocity = Lattice.zeros_grid(20, 20)
water.data[10, 10] = 50.0
show_enhanced(water, "Initial Disturbance (t=0)")

for step in 1:15
    global water = Lattice.Physics.wave_propagation(water, velocity, 0.5, 0.1, 1)
    if step % 3 == 0
        show_enhanced(water, "Wave at step $step")
    end
end

println("\n\n4. PARTICLE SYSTEM - Gravity Simulation")
println("   Particles falling and bouncing...")
particles = Lattice.Physics.ParticleSystem(30, 20, 20, gravity=2.0)

for p in particles.particles
    p.y = rand(1.0:5.0)
    p.x = rand(5.0:15.0)
    p.vx = rand(-1.0:0.1:1.0)
end

for step in 1:12
    Lattice.Physics.step!(particles, 0.2)
    grid = Lattice.Physics.particles_to_grid(particles)
    show_enhanced(grid, "Particle System - Step $step")
    sleep(0.2)
end

println("\n\n5. CELLULAR AUTOMATA - Game of Life")
println("   Blinker and Glider patterns...")
life_grid = Lattice.zeros_grid(15, 15)
life_grid.data[7, 7:9] .= 1.0
life_grid.data[3, 4] = 1.0
life_grid.data[4, 5] = 1.0
life_grid.data[5, 3:5] .= 1.0
show_enhanced(life_grid, "Game of Life - Initial")

for step in 1:10
    global life_grid = Lattice.Physics.game_of_life(life_grid, 1)
    show_enhanced(life_grid, "Generation $step")
    sleep(0.3)
end

println("\n\n6. COMBINED - Heated Rising Fluid")
println("   Hot fluid rising and diffusing...")
hot_fluid = Lattice.Physics.FluidSimulation(20, 20, diffusion=0.05, viscosity=0.01)

for x in 8:12
    Lattice.Physics.add_density!(hot_fluid, x, 18, 80.0)
    Lattice.Physics.add_velocity!(hot_fluid, x, 18, 0.0, -8.0)
end

show_enhanced(hot_fluid.density, "Hot Fluid - Initial")

for i in 1:10
    if i <= 6
        for x in 8:12
            Lattice.Physics.add_density!(hot_fluid, x, 18, 40.0)
            Lattice.Physics.add_velocity!(hot_fluid, x, 18, rand(-1.0:0.5:1.0), -5.0)
        end
    end
    
    Lattice.Physics.step!(hot_fluid, 0.15)
    show_enhanced(hot_fluid.density, "Hot Fluid - Step $i")
    sleep(0.3)
end
