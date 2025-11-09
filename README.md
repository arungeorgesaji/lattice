# Lattice

A powerful Julia-based grid computation engine for unified data processing across multiple domains including neural networks, image processing, audio analysis, and text processing.

## Overview

Lattice provides a unified `Grid` abstraction that represents multi-dimensional data consistently across different domains. This enables seamless transformations, operations, and domain-specific processing through a common interface.

## Features

- **Universal Grid Abstraction**: Single data structure for images, audio, text, and neural network tensors
- **Neural Networks**: Complete deep learning framework with layers, optimizers, and training utilities
- **Image Processing**: Convolution, edge detection, blurring, and filtering operations
- **Audio Processing**: Waveform generation, normalization, gain control, and feature extraction
- **Text Processing**: Character and one-hot encoding, sliding windows, and similarity metrics
- **File I/O**: Binary and text-based serialization for grid data
- **Visualization**: ASCII rendering and plotting utilities

## Installation

### From Julia REPL
```julia
using Pkg
Pkg.add(url="https://github.com/arungeorgesaji/lattice")
```

### From Command Line
```bash
julia -e 'using Pkg; Pkg.add(url="https://github.com/arungeorgesaji/lattice")'
```

## Quick Start

### Basic Grid Operations

```julia
using Lattice

# Create grids
zeros = Lattice.zeros_grid(3, 3)
ones = Lattice.ones_grid(3, 3)
random = Lattice.random_grid(3, 3)

# Grid arithmetic
result = ones + random * 2
scaled = result / 3

# Element-wise operations
mapped = Lattice.map_grid(x -> x^2, ones)
transformed = Lattice.transform(random, x -> sin(x))

# Indexing and iteration
value = result[1, 1]
for element in result
    println(element)
end
```

### Neural Networks

```julia
using Lattice.NN

# Build a sequential model
model = Lattice.NN.Sequential(
    Lattice.NN.DenseLayer(784, 128),
    Lattice.NN.relu,
    Lattice.NN.DenseLayer(128, 64),
    Lattice.NN.relu,
    Lattice.NN.DenseLayer(64, 10),
    Lattice.NN.sigmoid
)

# Forward pass
input = Lattice.random_grid(784, 1)
output = model(input)

# CNN for image classification
cnn = Lattice.NN.Sequential(
    Lattice.NN.ConvLayer(1, 16, 3),
    Lattice.NN.relu,
    Lattice.NN.MaxPool(2),
    Lattice.NN.ConvLayer(16, 32, 3),
    Lattice.NN.relu,
    Lattice.NN.GlobalAvgPool(),
    Lattice.NN.DenseLayer(32, 10)
)

# Training with optimizers
optimizer = Lattice.NN.Adam(0.001)
loss = Lattice.NN.mse_loss(predictions, targets)

# Update parameters
for param in Lattice.NN.get_parameters(model)
    gradient = compute_gradient(param)  # Your gradient computation
    Lattice.NN.update!(optimizer, param, gradient)
end
```

### Image Processing

```julia
# Load or create an image
image = Lattice.Grid(rand(256, 256))

# Apply blur
blurred = Lattice.blur_image(image, kernel_size=5)

# Edge detection
edges = Lattice.edge_detect_image(image)

# Custom convolution
kernel = Lattice.blur_kernel(3)
result = Lattice.convolve(image, kernel)

# Visualization
Lattice.show_ascii(image)
Lattice.show_comparison(image, blurred)
```

### Audio Processing

```julia
using Lattice.Audio

# Generate audio
sine_wave = Lattice.Audio.generate_sine_wave(440.0, duration=1.0, sample_rate=44100)

# Process audio
normalized = Lattice.Audio.normalize_audio(sine_wave)
amplified = Lattice.Audio.apply_gain(sine_wave, 6.0)  # +6 dB

# Extract features
rms_energy = Lattice.Audio.compute_rms(sine_wave)
zero_crossings = Lattice.Audio.zero_crossing_rate(sine_wave)
```

### Text Processing

```julia
using Lattice.Domains.TextRep

# Character encoding
text = "hello world"
grid = Lattice.text_to_grid(text, method=:character)
reconstructed = Lattice.grid_to_text(grid, method=:character)

# One-hot encoding
vocab = ['h', 'e', 'l', 'o', 'w', 'r', 'd', ' ']
one_hot = Lattice.text_to_grid(text, method=:one_hot, vocab=vocab)

# Sliding windows for sequence processing
windows = Lattice.text_sliding_window(text, window_size=5)

# Text similarity
grid1 = Lattice.text_to_grid("hello", method=:character)
grid2 = Lattice.text_to_grid("hello", method=:character)
similarity = Lattice.text_similarity(grid1, grid2)  # Returns 1.0
```

### File I/O

```julia
# Save grids
grid = Lattice.random_grid(100, 100)
Lattice.save_grid(grid, "data.bin")           # Binary format
Lattice.save_grid_text(grid, "data.txt")       # Text format

# Load grids
loaded_binary = Lattice.load_grid("data.bin")
loaded_text = Lattice.load_grid_text("data.txt")
```

## Neural Network Components

### Layers

- **DenseLayer**: Fully connected layer
- **ConvLayer**: 2D convolutional layer with stride and padding
- **RNNLayer**: Recurrent neural network layer
- **AttentionLayer**: Self-attention mechanism
- **MaxPool**: Max pooling operation
- **GlobalAvgPool**: Global average pooling

### Activation Functions

- `relu`: Rectified Linear Unit
- `sigmoid`: Sigmoid activation
- `tanh`: Hyperbolic tangent
- `softplus`: Smooth approximation of ReLU

### Loss Functions

- `mse_loss`: Mean squared error
- `binary_cross_entropy`: Binary classification loss
- `categorical_cross_entropy`: Multi-class classification loss
- `huber_loss`: Robust regression loss

### Optimizers

- **SGD**: Stochastic gradient descent with momentum
- **Adam**: Adaptive moment estimation

### Training Utilities

- **Accuracy**: Metric for classification and regression evaluation
- **Sequential**: Container for building layer-wise models
- `get_parameters`: Extract trainable parameters
- `count_parameters`: Count total trainable parameters

## Examples

Check the `examples/` directory for complete working examplesof the various features of Lattice.
