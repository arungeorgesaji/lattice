using Test, Lattice

@testset "Neural Networks - Expanded" begin
    @testset "Basic Layers" begin
        dense = Lattice.NN.DenseLayer(3, 2)
        input = Lattice.Grid([1.0 2.0 3.0]')  
        output = dense(input)
        @test size(output) == (2, 1)
        @test output isa Lattice.Grid
        
        conv = Lattice.NN.ConvLayer(1, 4, 3, stride=2, padding=1)
        image = Lattice.random_grid(10, 10)
        conv_out = conv(image)
        @test conv_out isa Lattice.Grid
        @test ndims(conv_out) == 3  
    end

    @testset "Advanced Layers" begin
        rnn = Lattice.NN.RNNLayer(4, 8)
        sequence = Lattice.random_grid(4, 5)  
        outputs, final_hidden = rnn(sequence)
        @test length(outputs) == 5  
        @test size(final_hidden) == (8, 1)
        
        attn = Lattice.NN.AttentionLayer(6)
        query = Lattice.random_grid(6, 1)
        keys = Lattice.random_grid(6, 4)   
        values = Lattice.random_grid(6, 4)  
        context, weights = attn(query, keys, values)
        @test context isa Lattice.Grid
        @test weights isa Lattice.Grid
        @test size(weights) == (4, 1)  
    end

    @testset "Pooling Layers" begin
        pool = Lattice.NN.MaxPool(2, 2)
        input = Lattice.random_grid(6, 6)
        pooled = pool(input)
        @test size(pooled) == (3, 3)
        
        gap = Lattice.NN.GlobalAvgPool()
        conv_output = Lattice.random_grid(8, 8, 4)  
        pooled_global = gap(conv_output)
        @test size(pooled_global) == (4, 1)  
    end

    @testset "Activation Functions" begin
        test_grid = Lattice.Grid([-2.0, -1.0, 0.0, 1.0, 2.0])
        
        relu_out = Lattice.NN.relu(test_grid)
        @test all(relu_out.data .== [0.0, 0.0, 0.0, 1.0, 2.0])
        
        sigmoid_out = Lattice.NN.sigmoid(test_grid)
        @test all(0.0 .<= sigmoid_out.data .<= 1.0)
        
        tanh_out = Lattice.NN.tanh(test_grid)
        @test all(-1.0 .<= tanh_out.data .<= 1.0)
        
        softplus_out = Lattice.NN.softplus(test_grid)
        @test all(softplus_out.data .>= 0.0)
    end

    @testset "Loss Functions" begin
        y_pred = Lattice.Grid([0.8, 0.2, 0.9])
        y_true = Lattice.Grid([1.0, 0.0, 1.0])
        
        mse = Lattice.NN.mse_loss(y_pred, y_true)
        @test mse >= 0.0
        
        ce = Lattice.NN.binary_cross_entropy(y_pred, y_true)
        @test ce >= 0.0
        
        y_pred_oh = Lattice.Grid([0.7 0.3; 0.2 0.8; 0.9 0.1])
        y_true_oh = Lattice.Grid([1.0 0.0; 0.0 1.0; 1.0 0.0])
        ce_cat = Lattice.NN.categorical_cross_entropy(y_pred_oh, y_true_oh)
        @test ce_cat >= 0.0
        
        huber = Lattice.NN.huber_loss(y_pred, y_true)
        @test huber >= 0.0
    end

    @testset "Optimizers" begin
        sgd = Lattice.NN.SGD(0.01, momentum=0.9)
        param = Lattice.random_grid(3, 3)
        grad = Lattice.Grid(ones(3, 3))
        
        original_data = copy(param.data)
        Lattice.NN.update!(sgd, param, grad)
        @test param.data != original_data  
        
        adam = Lattice.NN.Adam(0.001)
        param2 = Lattice.random_grid(2, 2)
        grad2 = Lattice.Grid(ones(2, 2))
        
        original_data2 = copy(param2.data)
        Lattice.NN.update!(adam, param2, grad2)
        @test param2.data != original_data2
    end

    @testset "Models" begin
        model = Lattice.NN.Sequential(
            Lattice.NN.DenseLayer(10, 20),
            Lattice.NN.relu,
            Lattice.NN.DenseLayer(20, 5),
            Lattice.NN.sigmoid
        )
        
        input = Lattice.random_grid(10, 1)
        output = model(input)
        @test size(output) == (5, 1)
        
        params = Lattice.NN.get_parameters(model)
        @test length(params) >= 2  
        
        param_count = Lattice.NN.count_parameters(model)
        @test param_count == 10*20 + 20 + 20*5 + 5  
    end

    @testset "Training Utilities" begin
        acc = Lattice.NN.Accuracy()
        y_pred = Lattice.Grid([0.8, 0.3, 0.9, 0.1])
        y_true = Lattice.Grid([1.0, 0.0, 1.0, 0.0])
        accuracy = acc(y_pred, y_true)
        @test 0.0 <= accuracy <= 1.0
        
        y_pred_reg = Lattice.Grid([1.1, 2.2, 3.3])
        y_true_reg = Lattice.Grid([1.0, 2.0, 3.0])
        r2_score = acc(y_pred_reg, y_true_reg)
        @test r2_score <= 1.0  
    end

    @testset "Complex Architectures" begin
        cnn = Lattice.NN.Sequential(
            Lattice.NN.ConvLayer(1, 8, 3),
            Lattice.NN.relu,
            Lattice.NN.MaxPool(2),
            Lattice.NN.ConvLayer(8, 16, 3),
            Lattice.NN.relu,
            Lattice.NN.MaxPool(2),
            Lattice.NN.GlobalAvgPool(),
            Lattice.NN.DenseLayer(16, 10),
            Lattice.NN.softplus
        )
        
        image = Lattice.random_grid(28, 28)  
        output = cnn(image)
        @test size(output) == (10, 1)
        
        rnn_model = Lattice.NN.Sequential(
            Lattice.NN.DenseLayer(10, 20),
            x -> Lattice.NN.RNNLayer(20, 16)(x)[2],  
            Lattice.NN.DenseLayer(16, 5),
            Lattice.NN.sigmoid
        )
        
        sequence = Lattice.random_grid(10, 8)  
        rnn_output = rnn_model(sequence)
        @test size(rnn_output) == (5, 1)
    end

    println("All Neural Network tests passed!")
end
