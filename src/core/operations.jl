Base.:+(a::Grid, b::Grid)     = Grid(a.data .+ b.data)
Base.:+(a::Grid, b::Number)   = Grid(a.data .+ b)
Base.:+(a::Number, b::Grid)   = Grid(a .+ b.data)

Base.:-(a::Grid, b::Grid)     = Grid(a.data .- b.data)
Base.:-(a::Grid, b::Number)   = Grid(a.data .- b)
Base.:-(a::Number, b::Grid)   = Grid(a .- b.data)

Base.:*(a::Grid, b::Grid)     = Grid(a.data .* b.data)
Base.:*(a::Grid, b::Number)   = Grid(a.data .* b)
Base.:*(a::Number, b::Grid)   = Grid(a .* b.data)

Base.:/(a::Grid, b::Grid) = begin
    @assert all(b.data .!= 0) "Division by zero in Grid / Grid"
    Grid(a.data ./ b.data)
end

Base.:/(a::Grid, b::Number) = begin
    @assert b != 0 "Division by zero in Grid / Number"
    Grid(a.data ./ b)
end

Base.:/(a::Number, b::Grid) = begin
    @assert all(b.data .!= 0) "Division by zero in Number / Grid"
    Grid(a ./ b.data)
end

function map_grid(f, grid::Grid)
    Grid(map(f, grid.data))
end

function transform(grid::Grid, op)
    Grid(op.(grid.data))
end
