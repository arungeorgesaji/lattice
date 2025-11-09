module Audio

using ...GridCore: Grid, random_grid, zeros_grid, transform, map_grid
using Statistics: mean 
using WAV, FFTW 

function load_audio(path::String)::Grid
    try
        samples, sample_rate = wavread(path)
        if ndims(samples) == 2
            samples = mean(samples, dims=2)
        end
        return Grid(samples)
    catch e
        @warn "Audio loading failed: $e. Returning test audio."
        return generate_sine_wave(440.0, 1.0, 44100) 
    end
end

function save_audio(grid::Grid, path::String; sample_rate=44100)
    try
        data = clamp.(grid.data, -1.0, 1.0)
        wavwrite(data, path, Fs=sample_rate)
    catch e
        @warn "Audio saving failed: $e"
    end
end

function generate_sine_wave(freq::Float64, duration::Float64, sample_rate=44100)
    t = range(0, duration, length=Int(duration * sample_rate))
    samples = sin.(2π * freq * t)
    Grid(reshape(samples, (length(samples), 1)))
end

function generate_noise(duration::Float64, sample_rate=44100)
    samples = randn(Int(duration * sample_rate)) * 0.1  
    Grid(reshape(samples, (length(samples), 1)))
end

function apply_gain(audio::Grid, gain_dB::Float64)
    gain_linear = 10^(gain_dB / 20)
    transform(audio, x -> x * gain_linear)
end

function normalize_audio(audio::Grid)
    max_val = maximum(abs.(audio.data))
    if max_val > 0
        transform(audio, x -> x / max_val)
    else
        audio
    end
end

function trim_silence(audio::Grid; threshold=0.01)
    data = audio.data
    start_idx = findfirst(x -> abs(x) > threshold, data)
    end_idx = findlast(x -> abs(x) > threshold, data)
    
    if start_idx === nothing || end_idx === nothing
        return audio  
    end
    
    Grid(data[start_idx:end_idx])
end

function fft(audio::Grid)
    spectrum = fft(audio.data)
    return Grid(spectrum)
end

function stft(audio::Grid; window_size=1024, hop_size=512)
    data = vec(audio.data)
    n_frames = (length(data) - window_size) ÷ hop_size + 1
    stft_matrix = zeros(ComplexF64, window_size, n_frames)
    
    for i in 1:n_frames
        start_idx = (i-1)*hop_size + 1
        window = data[start_idx:start_idx+window_size-1] .* hanning(window_size)
        stft_matrix[:, i] = fft(window)
    end
    
    return Grid(stft_matrix)
end

function hanning(n::Int)
    [0.5 - 0.5 * cos(2π * i / (n-1)) for i in 0:n-1]
end

function spectrogram(audio::Grid; window_size=1024, hop_size=512)
    stft_result = stft(audio, window_size=window_size, hop_size=hop_size)
    transform(stft_result, x -> log(abs(x) + 1e-8))
end

function add_reverb(audio::Grid, delay_ms=100, decay=0.5)
    delay_samples = Int(round(delay_ms * 44.1))  
    original = audio.data
    delayed = zeros(size(original))
    
    if length(original) > delay_samples
        delayed[delay_samples+1:end] = original[1:end-delay_samples] * decay
    end
    
    Grid(original + delayed)
end

function low_pass_filter(audio::Grid, cutoff_freq::Float64, sample_rate=44100)
    window_size = Int(round(sample_rate / cutoff_freq))
    if window_size < 2
        return audio
    end
    
    data = vec(audio.data)
    filtered = zeros(size(data))
    
    for i in 1:length(data)
        start_idx = max(1, i - window_size ÷ 2)
        end_idx = min(length(data), i + window_size ÷ 2)
        filtered[i] = mean(data[start_idx:end_idx])
    end
    
    Grid(filtered)
end

function compute_rms(audio::Grid)
    sqrt(mean(audio.data .^ 2))
end

function zero_crossing_rate(audio::Grid)
    data = vec(audio.data)
    crossings = sum((data[1:end-1] .* data[2:end]) .< 0)
    crossings / (length(data) - 1)
end

export load_audio, save_audio, generate_sine_wave, generate_noise
export apply_gain, normalize_audio, trim_silence
export fft, stft, spectrogram, add_reverb, low_pass_filter
export compute_rms, zero_crossing_rate

end
