struct Grid{T, N}
    data::Array{T, N}

    function Grid(data::Array{T, N}) where {T, N}
        new{T, N}(data)
    end
end

function zeros_grid(dims...)
    Grid(zeros(dims...))
end

function ones_grid(dims...)
    Grid(ones(dims...))
end

function random_grid(dims...)
    Grid(rand(dims...))
end

Base.size(grid::Grid) = size(grid.data)
Base.ndims(grid::Grid{T, N}) where {T, N} = N
Base.eltype(grid::Grid{T, N}) where {T, N} = T
