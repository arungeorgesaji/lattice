using Lattice

println("=== Audio Processing Examples ===")

println("1. Generating Audio Signals")

sine_440 = Lattice.Audio.generate_sine_wave(440.0, 0.5, 44100)  
println("Sine wave shape: ", size(sine_440))

function generate_square_wave(freq, duration, sample_rate)
    t = range(0, duration, length=Int(duration*sample_rate))
    wave = zeros(length(t))
    for harmonic in 1:2:9  
        wave .+= sin.(2π * freq * harmonic * t) / harmonic
    end
    return Lattice.Grid(wave')
end

square_440 = generate_square_wave(440.0, 0.5, 44100)

println("\n2. Audio Processing")

normalized = Lattice.Audio.normalize_audio(sine_440)
println("Max amplitude after normalization: ", maximum(abs.(normalized.data)))

amplified = Lattice.Audio.apply_gain(sine_440, 6.0)  
println("Max amplitude after +6dB gain: ", maximum(amplified.data))

println("\n3. Audio Feature Extraction")

rms = Lattice.Audio.compute_rms(sine_440)
println("RMS energy: ", rms)

zcr = Lattice.Audio.zero_crossing_rate(sine_440)
println("Zero crossing rate: ", zcr)

sine_zcr = Lattice.Audio.zero_crossing_rate(sine_440)
square_zcr = Lattice.Audio.zero_crossing_rate(square_440)

println("Zero crossing rate comparison:")
println("  Sine wave: ", sine_zcr)
println("  Square wave: ", square_zcr)

println("\n4. Audio Processing Pipeline")

processed_audio = sine_440 |>
    x -> Lattice.Audio.apply_gain(x, -3.0) |>  
    x -> Lattice.Audio.normalize_audio(x)      

println("Processing pipeline completed!")
println("Original max: ", maximum(abs.(sine_440.data)))
println("Processed max: ", maximum(abs.(processed_audio.data)))
