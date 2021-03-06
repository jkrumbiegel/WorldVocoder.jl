using WorldVocoder
using Test

@testset "WorldVocoder.jl" begin
    fs = 44100
    x = [sinpi(2t * 200) for t in 0:1/fs:5]
    f0, timestamps = dio(x, fs)
    refined_f0 = stonemask(x, fs, timestamps, f0)
    spectrogram = cheaptrick(x, fs, timestamps, refined_f0)
    fft_size = (size(spectrogram, 1) - 1) * 2
    aperiodicity = d4c(x, fs, timestamps, refined_f0, fft_size)
    y = synthesis(refined_f0, spectrogram, aperiodicity, fs)

    f0, sp, ap = world(x, fs)
end

@testset "Harvest" begin
    fs = 44100
    x = [sinpi(2t * 200) for t in 0:1/fs:5]

    f0, temporal_positions = harvest(x, fs)
end
