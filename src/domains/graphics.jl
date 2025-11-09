module Graphics

using ...GridCore: Grid, zeros_grid, ones_grid, random_grid, transform, map_grid

function create_circle(radius::Int, center_x::Int, center_y::Int, grid_size::Tuple{Int,Int})
    grid = zeros_grid(grid_size...)
    for y in 1:grid_size[1], x in 1:grid_size[2]
        distance = sqrt((x - center_x)^2 + (y - center_y)^2)
        if distance <= radius
            grid.data[y, x] = 1.0
        end
    end
    return grid
end

function create_rectangle(width::Int, height::Int, start_x::Int, start_y::Int, grid_size::Tuple{Int,Int})
    grid = zeros_grid(grid_size...)
    for y in start_y:min(start_y+height-1, grid_size[1]), x in start_x:min(start_x+width-1, grid_size[2])
        grid.data[y, x] = 1.0
    end
    return grid
end

function create_line(x1::Int, y1::Int, x2::Int, y2::Int, grid_size::Tuple{Int,Int})
    grid = zeros_grid(grid_size...)
    dx = abs(x2 - x1)
    dy = abs(y2 - y1)
    sx = x1 < x2 ? 1 : -1
    sy = y1 < y2 ? 1 : -1
    err = dx - dy
    
    x, y = x1, y1
    while true
        if 1 <= x <= grid_size[2] && 1 <= y <= grid_size[1]
            grid.data[y, x] = 1.0
        end
        (x == x2 && y == y2) && break
        e2 = 2 * err
        if e2 > -dy
            err -= dy
            x += sx
        end
        if e2 < dx
            err += dx
            y += sy
        end
    end
    return grid
end

struct VoxelGrid
    data::Array{Float64, 3}
end

function VoxelGrid(width::Int, height::Int, depth::Int)
    VoxelGrid(zeros(width, height, depth))
end

function create_sphere_voxel(radius::Int, center::Tuple{Int,Int,Int}, grid_size::Tuple{Int,Int,Int})
    voxels = VoxelGrid(grid_size...)
    cx, cy, cz = center
    for z in 1:grid_size[3], y in 1:grid_size[2], x in 1:grid_size[1]
        distance = sqrt((x - cx)^2 + (y - cy)^2 + (z - cz)^2)
        if distance <= radius
            voxels.data[x, y, z] = 1.0
        end
    end
    return voxels
end

function create_cube_voxel(size::Int, start::Tuple{Int,Int,Int}, grid_size::Tuple{Int,Int,Int})
    voxels = VoxelGrid(grid_size...)
    sx, sy, sz = start
    for z in sz:min(sz+size-1, grid_size[3]),
        y in sy:min(sy+size-1, grid_size[2]),
        x in sx:min(sx+size-1, grid_size[1])
        voxels.data[x, y, z] = 1.0
    end
    return voxels
end

function ray_march_sdf(sdf::Function, steps::Int, max_distance::Float64)
    results = zeros_grid(steps, steps)
    
    for i in 1:steps, j in 1:steps
        x = (i / steps) * 2 - 1
        y = (j / steps) * 2 - 1
        
        ray_pos = (x, y, -2.0)
        ray_dir = (0.0, 0.0, 1.0)
        
        distance = 0.0
        for _ in 1:50 
            current_pos = (ray_pos[1] + ray_dir[1] * distance,
                          ray_pos[2] + ray_dir[2] * distance, 
                          ray_pos[3] + ray_dir[3] * distance)
            
            dist_to_surface = sdf(current_pos...)
            distance += dist_to_surface
            
            if dist_to_surface < 0.001
                results.data[i, j] = 1.0 - (distance / max_distance)
                break
            elseif distance > max_distance  
                results.data[i, j] = 0.0
                break
            end
        end
    end
    
    return results
end

function sphere_sdf(x::Float64, y::Float64, z::Float64, radius::Float64=0.5)
    return sqrt(x^2 + y^2 + z^2) - radius
end

function box_sdf(x::Float64, y::Float64, z::Float64, size::Float64=0.4)
    d = abs.((x, y, z)) .- size
    return min(max(d[1], d[2], d[3]), 0.0) + length(max.(d, 0.0))
end

function rotate_2d(grid::Grid, angle::Float64)
    h, w = size(grid)
    result = zeros_grid(h, w)
    cos_θ, sin_θ = cos(angle), sin(angle)
    center_x, center_y = w/2, h/2
    
    for y in 1:h, x in 1:w
        dx, dy = x - center_x, y - center_y
        src_x = dx * cos_θ - dy * sin_θ + center_x
        src_y = dx * sin_θ + dy * cos_θ + center_y
        
        src_x_int = round(Int, src_x)
        src_y_int = round(Int, src_y)
        
        if 1 <= src_x_int <= w && 1 <= src_y_int <= h
            result.data[y, x] = grid.data[src_y_int, src_x_int]
        end
    end
    
    return result
end

function scale_2d(grid::Grid, scale_x::Float64, scale_y::Float64)
    h, w = size(grid)
    new_h, new_w = round(Int, h * scale_y), round(Int, w * scale_x)
    result = zeros_grid(new_h, new_w)
    
    for y in 1:new_h, x in 1:new_w
        src_x = x / scale_x
        src_y = y / scale_y
        src_x_int = clamp(round(Int, src_x), 1, w)
        src_y_int = clamp(round(Int, src_y), 1, h)
        result.data[y, x] = grid.data[src_y_int, src_x_int]
    end
    
    return result
end

function create_checkerboard(size::Int, square_size::Int)
    grid = zeros_grid(size, size)
    for y in 1:size, x in 1:size
        if ((x ÷ square_size) + (y ÷ square_size)) % 2 == 0
            grid.data[y, x] = 1.0
        end
    end
    return grid
end

function create_gradient(size::Int, direction::Symbol=:horizontal)
    grid = zeros_grid(size, size)
    if direction == :horizontal
        for y in 1:size, x in 1:size
            grid.data[y, x] = x / size
        end
    else
        for y in 1:size, x in 1:size
            grid.data[y, x] = y / size
        end
    end
    return grid
end

function dilate(grid::Grid, kernel_size::Int=3)
    h, w = size(grid)
    result = copy(grid.data)
    
    for y in 1:h, x in 1:w
        if grid.data[y, x] > 0
            for dy in -kernel_size÷2:kernel_size÷2
                for dx in -kernel_size÷2:kernel_size÷2
                    ny, nx = y + dy, x + dx
                    if 1 <= ny <= h && 1 <= nx <= w
                        result[ny, nx] = max(result[ny, nx], grid.data[y, x])
                    end
                end
            end
        end
    end
    
    return Grid(result)
end

function erode(grid::Grid, kernel_size::Int=3)
    h, w = size(grid)
    result = copy(grid.data)
    
    for y in 1:h, x in 1:w
        if grid.data[y, x] > 0
            all_present = true
            for dy in -kernel_size÷2:kernel_size÷2
                for dx in -kernel_size÷2:kernel_size÷2
                    ny, nx = y + dy, x + dx
                    if 1 <= ny <= h && 1 <= nx <= w && grid.data[ny, nx] == 0
                        all_present = false
                        break
                    end
                end
                !all_present && break
            end
            if !all_present
                result[y, x] = 0.0
            end
        end
    end
    
    return Grid(result)
end

export create_circle, create_rectangle, create_line
export VoxelGrid, create_sphere_voxel, create_cube_voxel
export ray_march_sdf, sphere_sdf, box_sdf
export rotate_2d, scale_2d
export create_checkerboard, create_gradient
export dilate, erode

end
