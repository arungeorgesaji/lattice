using Serialization, JSON3

function save_grid(grid::Grid, filename::String)
    open(filename, "w") do io
        serialize(io, grid.data)
    end
end

function load_grid(filename::String)::Grid
    data = open(deserialize, filename)
    return Grid(data)
end

function save_grid_text(grid::Grid, filename::String)
    open(filename, "w") do io
        println(io, "# Grid: ", size(grid))
        println(io, "# Element type: ", eltype(grid))
        for i in 1:size(grid, 1)
            row = [string(grid.data[i, j]) for j in 1:size(grid, 2)]
            println(io, join(row, ", "))
        end
    end
end

function load_grid_text(filename::String)::Grid
    lines = readlines(filename)
    data_lines = filter(line -> !startswith(strip(line), "#"), lines)
    
    rows = [permutedims([parse(Float64, x) for x in split(line, ",")]) for line in data_lines]
    return Grid(vcat(rows...))
end

function save_grid_json(grid::Grid, filename::String)
    json_data = Dict(
        "type" => "Grid",
        "dims" => size(grid),
        "eltype" => string(eltype(grid)),
        "data" => grid.data
    )
    open(filename, "w") do io
        JSON3.write(io, json_data)
    end
end

function load_grid_json(filename::String)::Grid
    json_str = read(filename, String)
    data = JSON3.read(json_str)
    return Grid(data.data)
end
