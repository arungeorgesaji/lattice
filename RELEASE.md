# Release Notes

### Overview
A Julia-based grid computation framework integrating AI, scientific computing, and data processing in a single system.

### See It In Action

Watch the demo video to see a quick demo of some basic features without having to download it for yourself

<p align="center">
  <a href="">
    <img src="https://dummyimage.com/800x450/000/fff&text=▶+Watch+Lattice+Demo" alt="Watch the Lattice Demo Video" width="600"/>
  </a>
</p>

### Core Features
- **Grid Abstraction**: Universal data structure for multi-dimensional operations
- **Neural Networks**: Complete deep learning framework with layers, optimizers, and training utilities
- **Image Processing**: Convolution operations, edge detection, and filtering
- **Audio Processing**: Waveform generation and feature extraction
- **Text Processing**: Encoding methods and similarity metrics
- **Physics Simulation**: Fluid dynamics, heat diffusion, particle systems, and cellular automata
- **Computer Graphics**: 2D/3D shape generation, ray marching, transformations, and morphological operations
- **File I/O**: Binary and text-based grid serialization

### Installation

### From Julia REPL
```julia
using Pkg
Pkg.add(url="https://github.com/arungeorgesaji/lattice")
```

### From Command Line
```bash
julia -e 'using Pkg; Pkg.add(url="https://github.com/arungeorgesaji/lattice")'
```

### Running Examples

```bash
julia examples/example_name.jl
```

### Components

#### Core 

- Grid — Base data abstraction supporting N-dimensional arrays
- Arithmetic, transformation, and mapping operations 
- Broadcasting and iteration support
- Grid creation helpers: **zeros_grid**, **ones_grid**, **random_grid**

#### I/O 

- **save_grid**, **load_grid** — Binary serialization
- **save_grid_text**, **load_grid_text** — Human-readable text serialization

#### Neural Networks

- Layers: **DenseLayer**, **ConvLayer**, **RNNLayer**, **AttentionLayer**, **MaxPool**, **GlobalAvgPool**
- Activations: **relu**, **sigmoid**, **tanh**, **softplus**
- Loss Functions: **mse_loss**, **binary_cross_entropy**, **categorical_cross_entropy**, **huber_loss**
- Optimizers: **SGD** (momentum), **Adam** 
- Utilities: **Sequential**, **get_parameters**, **count_parameters** 

#### Image Operations 

- Blur, edge detection, and custom convolution 
- Supports convolution modes **:valid** and **:same**
- Visualization tools: **show_ascii**, **show_comparison**

#### Audio Processing 

- Sine wave generation, normalization, gain control 
- Feature extraction: RMS energy, zero-crossing rate 
- Compatible with **Grid** operations and transformations

#### Text processing

- Character and one-hot encoding 
- Sliding window generation for sequence data 
- Text-to-grid and grid-to-text conversion 
- Similarity scoring between text grids 

#### Physics Simulations 

- **Fluid Dynamics**: Density and velocity field simulation 
- **Heat Diffusion**: Temperature propagation over time 
- **Wave Propagation**: Basic wave equation solver 
- **Particle Systems**: Gravity-based particle simulation 
- **Cellular Automata**: Game of Life and custom rule support 

#### Computer Graphics 

- **2D Shape Generation**: Circles, rectangles, lines with customizable parameters 
- **3D Voxel Operations**: Sphere and cube generation in 3D space
- **Ray Marching**: Signed distance field rendering for 3D shapes
- **Transformations**: Rotation and scaling operations 
- **Pattern Generation**: Checkerboards, gradients, and procedural textures 
- **Morphological Operations**: Dilation and erosion for shape processing

### Visualization 

- ASCII renderers for console-based visualization 
- Comparative visual outputs for transformations 
