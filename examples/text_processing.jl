using Lattice
using Lattice.Domains.TextRep

println("=== Text Processing Examples ===")

texts = [
    "hello world",
    "machine learning",
    "neural networks",
    "hello universe"
]

println("1. Character Encoding")
for text in texts[1:2]
    grid = Lattice.text_to_grid(text, method=:character)
    reconstructed = Lattice.grid_to_text(grid, method=:character)
    println("Original: '$text'")
    println("Encoded shape: ", size(grid))
    println("Reconstructed: '$reconstructed'")
    println()
end

println("2. One-Hot Encoding")
chars_set = Set{Char}()
for t in texts
    for c in collect(t)
        push!(chars_set, c)
    end
end
vocab = sort(collect(chars_set))         
println("Vocabulary (chars): ", join(vocab))

for text in texts[1:2]
    one_hot = Lattice.text_to_grid(text, method=:one_hot, vocab=vocab)
    reconstructed = Lattice.grid_to_text(one_hot, method=:one_hot, vocab=vocab)
    println("Original: '$text'")
    println("One-hot shape: ", size(one_hot))
    println("Reconstructed: '$reconstructed'")
    println()
end

println("3. Sliding Windows")
text = "hello world"
window_size = 5
windows = Lattice.text_sliding_window(text, window_size)

println("Text: '$text'")
println("Window size: $window_size")
println("Windows grid shape: ", size(windows))

for i in 1:size(windows, 1)
    row = windows.data[i, :]                     
    row2d = reshape(row, 1, length(row))         
    window_grid = Lattice.Grid(row2d)
    window_text = Lattice.grid_to_text(window_grid, method=:character)
    println("Window $i: '$window_text'")
end

println("\n4. Text Similarity")
base_text = "hello world"
base_grid = Lattice.text_to_grid(base_text, method=:character)

for text in texts
    compare_grid = Lattice.text_to_grid(text, method=:character)
    similarity = Lattice.text_similarity(base_grid, compare_grid)
    println("Similarity between '$base_text' and '$text': $similarity")
end

println("\n5. Text Processing Pipeline")
function process_text_pipeline(text, vocab)
    grid = text |>
        x -> Lattice.text_to_grid(x, method=:one_hot, vocab=vocab)
    processed = Lattice.map_grid(x -> x > 0 ? 1.0 : 0.0, grid)
    return processed
end

processed = process_text_pipeline("hello", vocab)
println("Processed text grid shape: ", size(processed))

