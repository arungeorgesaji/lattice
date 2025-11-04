function Base.:+(a::Grid, b::Grid)
    Grid(a.data .+ b.data)
end

function Base.:*(a::Grid, b::Number)
    Grid(a.data .* b)
end

function Base.:*(a::Number, b::Grid)
    Grid(a .* b.data)
end

function map_grid(f, grid::Grid)
    Grid(map(f, grid.data))
end

function transform(grid::Grid, op)
    Grid(op.(grid.data))
end
