using Test, Lattice

@testset "Audio Domain" begin
    sine_wave = Lattice.Audio.generate_sine_wave(440.0, 0.1, 44100)
    @test size(sine_wave) == (4410, 1)
    @test maximum(abs.(sine_wave.data)) ≈ 1.0 atol=0.1
    
    normalized = Lattice.Audio.normalize_audio(sine_wave)
    @test maximum(abs.(normalized.data)) ≈ 1.0 atol=0.01
    
    amplified = Lattice.Audio.apply_gain(sine_wave, 6.0)  
    @test maximum(amplified.data) > maximum(sine_wave.data)
    
    rms = Lattice.Audio.compute_rms(sine_wave)
    @test 0.6 <= rms <= 0.8  
    
    zcr = Lattice.Audio.zero_crossing_rate(sine_wave)
    @test zcr > 0.0
    
    println("Audio domain tests passed!")
end
