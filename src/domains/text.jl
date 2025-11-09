module TextRep

using ...GridCore: Grid
using LinearAlgebra: dot, norm

function text_to_grid(text::String; method=:one_hot, vocab=nothing)
    if method == :one_hot
        return _text_to_one_hot(text, vocab)
    elseif method == :embedding
        return _text_to_embedding(text)
    elseif method == :character
        return _text_to_character_grid(text)
    else
        error("Unknown method: $method")
    end
end

function _text_to_character_grid(text::String)
    codes = [Float64(c) for c in text]
    Grid(reshape(codes, (length(codes), 1)))
end

function _text_to_one_hot(text::String, vocab=nothing)
    if vocab === nothing
        vocab = sort(unique(collect(text)))
    end
    
    one_hot = zeros(Float64, length(vocab), length(text))
    for (i, char) in enumerate(text)
        idx = findfirst(==(char), vocab)
        if idx !== nothing
            one_hot[idx, i] = 1.0
        end
    end
    
    Grid(one_hot)
end

function _text_to_embedding(text::String)
    embeddings = Dict(
        'a' => [0.1, 0.2], 'b' => [0.3, 0.4],
        'c' => [0.5, 0.6], 'd' => [0.7, 0.8],
        'e' => [0.9, 0.1], ' ' => [0.0, 0.0]
    )
    
    default_embed = [0.5, 0.5]
    
    emb_matrix = []
    for char in text
        emb = get(embeddings, char, default_embed)
        push!(emb_matrix, emb)
    end
    
    emb_array = reduce(hcat, emb_matrix)
    Grid(emb_array)
end

function grid_to_text(grid::Grid; method=:character, vocab=nothing)
    if method == :character
        return _character_grid_to_text(grid)
    elseif method == :one_hot
        return _one_hot_to_text(grid, vocab)
    else
        error("Unknown method: $method")
    end
end

function _character_grid_to_text(grid::Grid)
    if ndims(grid) == 2 && size(grid, 2) == 1
        chars = [Char(round(Int, x)) for x in vec(grid.data)]
    else
        chars = [Char(round(Int, x)) for x in vec(grid.data)]
    end
    return String(chars)
end

function _one_hot_to_text(grid::Grid, vocab)
    text_chars = Char[]
    for i in 1:size(grid, 2)  
        col = grid.data[:, i]
        idx = findmax(col)[2]  
        push!(text_chars, vocab[idx])
    end
    return String(text_chars)
end

function text_sliding_window(text::String, window_size::Int)
    windows = []
    for i in 1:length(text)-window_size+1
        window = text[i:i+window_size-1]
        grid = text_to_grid(window, method=:character)
        push!(windows, vec(grid.data))  
    end
    window_matrix = reduce(vcat, transpose.(windows))
    Grid(window_matrix)
end

function text_similarity(grid1::Grid, grid2::Grid)
    v1 = vec(grid1.data)
    v2 = vec(grid2.data)
    dot_product = dot(v1, v2)
    norm1 = norm(v1)
    norm2 = norm(v2)
    return norm1 == 0 || norm2 == 0 ? 0.0 : dot_product / (norm1 * norm2)
end

function generate_text(seed::String, length::Int; temperature=0.5)
    current = seed
    for i in 1:length
        last_char = current[end]
        vowels = "aeiou"
        consonants = "bcdfghjklmnpqrstvwxyz"
        
        if last_char in vowels
            next_char = rand(collect(consonants))
        else
            next_char = rand(collect(vowels))
        end
        current *= next_char
    end
    return current
end

export text_to_grid, grid_to_text, text_sliding_window, text_similarity, generate_text

end
