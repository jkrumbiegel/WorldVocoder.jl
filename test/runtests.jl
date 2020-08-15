using WorldVocoder
using Test

@testset "WorldVocoder.jl" begin
    
    fs = 44100
    x = [sinpi(2t * 200) for t in 0:1/fs:5]
    f0, timestamps = dio(x, fs)
    spectrogram = cheaptrick(x, fs, timestamps, f0)
    @show extrema(spectrogram)
end
