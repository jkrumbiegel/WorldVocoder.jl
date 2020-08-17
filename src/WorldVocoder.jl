module WorldVocoder

using WORLD_jll: libworld

const DEFAULT_FRAME_PERIOD = 5.0

include("dio.jl")
export dio

include("cheaptrick.jl")
export cheaptrick

include("stonemask.jl")
export stonemask

include("d4c.jl")
export d4c

include("synthesis.jl")
export synthesis

export world

"""
    world(x::Vector{Float64}, fs::Int)

Returns `(refined_f0, spectrogram, aperiodicity)` after running the full WORLD pipeline
consisting of

- `dio` (f0 extraction)
- `stonemask` (f0 refinement)
- `cheaptrick` (spectrogram extraction)
- `d4c` (aperiodicity extraction)
"""
function world(x::Vector{Float64}, fs::Int)
    f0, timestamps = dio(x, fs)
    refined_f0 = stonemask(x, fs, timestamps, f0)
    spectrogram = cheaptrick(x, fs, timestamps, refined_f0)
    fft_size = (size(spectrogram, 1) - 1) * 2
    aperiodicity = d4c(x, fs, timestamps, refined_f0, fft_size)
    refined_f0, spectrogram, aperiodicity
end

end
