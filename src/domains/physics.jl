module Physics

using ...GridCore: Grid, zeros_grid, ones_grid, random_grid, transform, map_grid, convolve

mutable struct FluidSimulation
    velocity_x::Grid
    velocity_y::Grid
    density::Grid
    diffusion_rate::Float64
    viscosity::Float64
end

function FluidSimulation(width::Int, height::Int; diffusion=0.1, viscosity=0.1)
    velocity_x = zeros_grid(height, width)
    velocity_y = zeros_grid(height, width)
    density = zeros_grid(height, width)
    FluidSimulation(velocity_x, velocity_y, density, diffusion, viscosity)
end

function add_density!(fluid::FluidSimulation, x::Int, y::Int, amount::Float64)
    fluid.density.data[y, x] += amount
end

function add_velocity!(fluid::FluidSimulation, x::Int, y::Int, dx::Float64, dy::Float64)
    fluid.velocity_x.data[y, x] += dx
    fluid.velocity_y.data[y, x] += dy
end

function diffuse!(grid::Grid, diffusion_rate::Float64, dt::Float64)
    kernel_data = [
        [0.0, diffusion_rate * dt, 0.0],
        [diffusion_rate * dt, 1.0 - 4 * diffusion_rate * dt, diffusion_rate * dt],
        [0.0, diffusion_rate * dt, 0.0]
    ]
    diffusion_kernel = Grid(reshape([item for row in kernel_data for item in row], (3, 3)))
    return convolve(grid, diffusion_kernel, mode=:same)
end

function project!(velocity_x::Grid, velocity_y::Grid)
    h, w = size(velocity_x)
    divergence = zeros_grid(h, w)
    
    for y in 2:h-1, x in 2:w-1
        divergence.data[y, x] = -0.5 * (
            velocity_x.data[y, x+1] - velocity_x.data[y, x-1] +
            velocity_y.data[y+1, x] - velocity_y.data[y-1, x]
        )
    end
    
    pressure = zeros_grid(h, w)
    for _ in 1:20  
        for y in 2:h-1, x in 2:w-1
            pressure.data[y, x] = (
                divergence.data[y, x] +
                pressure.data[y, x+1] + pressure.data[y, x-1] +
                pressure.data[y+1, x] + pressure.data[y-1, x]
            ) / 4.0
        end
    end
    
    for y in 2:h-1, x in 2:w-1
        velocity_x.data[y, x] -= 0.5 * (pressure.data[y, x+1] - pressure.data[y, x-1])
        velocity_y.data[y, x] -= 0.5 * (pressure.data[y+1, x] - pressure.data[y-1, x])
    end
    
    return velocity_x, velocity_y
end

function step!(fluid::FluidSimulation, dt::Float64=0.1)
    fluid.velocity_x = diffuse!(fluid.velocity_x, fluid.viscosity, dt)
    fluid.velocity_y = diffuse!(fluid.velocity_y, fluid.viscosity, dt)
    
    fluid.velocity_x, fluid.velocity_y = project!(fluid.velocity_x, fluid.velocity_y)
    
    fluid.density = advect!(fluid.density, fluid.velocity_x, fluid.velocity_y, dt)
    fluid.velocity_x = advect!(fluid.velocity_x, fluid.velocity_x, fluid.velocity_y, dt)
    fluid.velocity_y = advect!(fluid.velocity_y, fluid.velocity_x, fluid.velocity_y, dt)
    
    fluid.density = diffuse!(fluid.density, fluid.diffusion_rate, dt)
    
    return fluid
end

function advect!(quantity::Grid, vel_x::Grid, vel_y::Grid, dt::Float64)
    h, w = size(quantity)
    new_quantity = zeros_grid(h, w)
    
    for y in 1:h, x in 1:w
        src_x = x - dt * vel_x.data[y, x]
        src_y = y - dt * vel_y.data[y, x]
        
        src_x = clamp(src_x, 1, w)
        src_y = clamp(src_y, 1, h)
        
        x1 = floor(Int, src_x)
        x2 = min(x1 + 1, w)
        y1 = floor(Int, src_y)
        y2 = min(y1 + 1, h)
        
        tx = src_x - x1
        ty = src_y - y1
        
        value = (1 - tx) * (1 - ty) * quantity.data[y1, x1] +
                tx * (1 - ty) * quantity.data[y1, x2] +
                (1 - tx) * ty * quantity.data[y2, x1] +
                tx * ty * quantity.data[y2, x2]
        
        new_quantity.data[y, x] = value
    end
    
    return new_quantity
end

function heat_diffusion(initial_temp::Grid, alpha::Float64, time_steps::Int)
    temperature = initial_temp
    kernel_data = [
        [0.0, alpha, 0.0],
        [alpha, 1.0 - 4*alpha, alpha],
        [0.0, alpha, 0.0]
    ]
    kernel = Grid(reshape([item for row in kernel_data for item in row], (3, 3)))
    
    for _ in 1:time_steps
        temperature = convolve(temperature, kernel, mode=:same)
    end
    
    return temperature
end

function wave_propagation(initial_height::Grid, velocity::Grid, c::Float64, dt::Float64, steps::Int)
    height = initial_height
    height_prev = copy(height.data)
    
    k = (c * dt)^2
    
    for _ in 1:steps
        height_new = zeros_grid(size(height)...)
        
        for y in 2:size(height, 1)-1, x in 2:size(height, 2)-1
            laplacian = (height.data[y, x+1] + height.data[y, x-1] +
                         height.data[y+1, x] + height.data[y-1, x] -
                         4 * height.data[y, x])
            
            height_new.data[y, x] = 2 * height.data[y, x] - height_prev[y, x] + k * laplacian
        end
        
        height_prev = copy(height.data)
        height = height_new
    end
    
    return height
end

mutable struct Particle
    x::Float64
    y::Float64
    vx::Float64
    vy::Float64
    mass::Float64
end

struct ParticleSystem
    particles::Vector{Particle}
    width::Int
    height::Int
    gravity::Float64
end

function ParticleSystem(num_particles::Int, width::Int, height::Int; gravity=0.1)
    particles = [
        Particle(rand() * width, rand() * height, 0.0, 0.0, 1.0)
        for _ in 1:num_particles
    ]
    ParticleSystem(particles, width, height, gravity)
end

function step!(system::ParticleSystem, dt::Float64)
    for p in system.particles
        p.vy += system.gravity * dt
        
        p.x += p.vx * dt
        p.y += p.vy * dt
        
        if p.x <= 0 || p.x >= system.width
            p.vx *= -0.8  
            p.x = clamp(p.x, 0, system.width)
        end
        if p.y <= 0 || p.y >= system.height
            p.vy *= -0.8
            p.y = clamp(p.y, 0, system.height)
        end
    end
    return system
end

function particles_to_grid(system::ParticleSystem)::Grid
    grid = zeros_grid(system.height, system.width)
    
    for p in system.particles
        x = Int(round(p.x))
        y = Int(round(p.y))
        if 1 <= x <= system.width && 1 <= y <= system.height
            grid.data[y, x] += p.mass
        end
    end
    
    return grid
end

function game_of_life(initial_state::Grid, steps::Int)
    state = initial_state
    
    for _ in 1:steps
        new_state = zeros_grid(size(state)...)
        
        for y in 1:size(state, 1), x in 1:size(state, 2)
            neighbors = 0
            for dy in -1:1, dx in -1:1
                if dx == 0 && dy == 0
                    continue
                end
                ny = mod1(y + dy, size(state, 1))
                nx = mod1(x + dx, size(state, 2))
                neighbors += state.data[ny, nx]
            end
            
            if state.data[y, x] > 0  
                new_state.data[y, x] = (neighbors == 2 || neighbors == 3) ? 1.0 : 0.0
            else  
                new_state.data[y, x] = (neighbors == 3) ? 1.0 : 0.0
            end
        end
        
        state = new_state
    end
    
    return state
end

export FluidSimulation, add_density!, add_velocity!, step!
export heat_diffusion, wave_propagation
export ParticleSystem, Particle, particles_to_grid, step!
export game_of_life

end
