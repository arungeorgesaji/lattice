module NN

using ..Core: Grid

include("nn/layers/basic.jl")
include("nn/layers/advanced.jl") 
include("nn/layers/pooling.jl")
include("nn/optimizers.jl")
include("nn/losses.jl")
include("nn/models.jl")
include("nn/training.jl")

export DenseLayer, ConvLayer, RNNLayer, LSTMLayer, AttentionLayer
export BatchNorm, Dropout, MaxPool, GlobalAvgPool
export SGD, Adam, RMSprop
export mse_loss, cross_entropy_loss, binary_cross_entropy
export Sequential, Model, train!, evaluate
export Accuracy, Precision, Recall

end
