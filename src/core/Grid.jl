struct Grid{T, N}
    data::Array{T, N}
    function Grid(data::AbstractArray{T, N}) where {T, N}
        new{T, N}(Array(data))  
    end
end

Base.size(g::Grid) = size(g.data)
Base.size(g::Grid, d::Int) = size(g.data, d)
Base.getindex(g::Grid, I...) = g.data[I...]
Base.IndexStyle(::Type{<:Grid}) = IndexStyle(Array)
Base.broadcastable(g::Grid) = g
Base.ndims(::Grid{T, N}) where {T, N} = N
Base.eltype(::Grid{T, N}) where {T, N} = T
Base.length(g::Grid) = length(g.data)
Base.iterate(g::Grid, args...) = iterate(g.data, args...)
Base.collect(g::Grid) = g.data

struct GridStyle{N} <: Base.Broadcast.AbstractArrayStyle{N} end

Base.Broadcast.BroadcastStyle(::Type{<:Grid{T, N}}) where {T, N} = GridStyle{N}()
GridStyle{N}(::Val{N}) where {N} = GridStyle{N}()

Base.Broadcast.combine_styles(::GridStyle{M}, ::Base.Broadcast.DefaultArrayStyle{N}) where {M, N} =
    GridStyle{max(M, N)}()
Base.Broadcast.combine_styles(::Base.Broadcast.DefaultArrayStyle{M}, ::GridStyle{N}) where {M, N} =
    GridStyle{max(M, N)}()

function Base.similar(bc::Base.Broadcast.Broadcasted{GridStyle{N}}, ::Type{T}) where {N, T}
    Grid(similar(Array{T, N}, axes(bc)))
end

function Base.copyto!(dest::Grid, bc::Base.Broadcast.Broadcasted{GridStyle{N}}) where {N}
    copyto!(dest.data, bc)
    return dest
end

zeros_grid(dims...) = Grid(zeros(dims...))
ones_grid(dims...)  = Grid(ones(dims...))
random_grid(dims...) = Grid(rand(dims...))
