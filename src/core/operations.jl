for op in [:+, :-, :*]
    @eval begin
        Base.$op(a::Grid, b::Grid)     = Grid($op.(a.data, b.data))
        Base.$op(a::Grid, b::Number)   = Grid($op.(a.data, b))
        Base.$op(a::Number, b::Grid)   = Grid($op.(a, b.data))
    end
end

@inline _safe_div(x, y, msg) = (@assert all(!=(0), y) msg; x ./ y)

for (T1, T2, x, y, msg) in [
    (:Grid, :Grid,   :(a.data), :(b.data), "Division by zero in Grid / Grid"),
    (:Grid, :Number, :(a.data), :(b),      "Division by zero in Grid / Number"),
    (:Number, :Grid, :(a),      :(b.data), "Division by zero in Number / Grid")
]
    @eval Base.:/(a::$T1, b::$T2) = Grid(_safe_div($x, $y, $msg))
end

function map_grid(f, grid::Grid)
    Grid(map(f, grid.data))
end

function transform(grid::Grid, op)
    Grid(op.(grid.data))
end
