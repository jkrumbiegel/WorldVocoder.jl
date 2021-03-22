module WorldVocoder

using WORLD_jll: libworld

const DEFAULT_FRAME_PERIOD = 5.0

include("dio.jl")
export dio

include("harvest.jl")
export harvest

include("cheaptrick.jl")
export cheaptrick

include("stonemask.jl")
export stonemask

include("d4c.jl")
export d4c

include("synthesis.jl")
export synthesis

export world

struct Harvest end
struct Dio end

"""
    world(x::Vector{Float64}, fs::Int)

Returns `(f0 = refined_f0, sp = spectrogram, ap = aperiodicity)` after running the full WORLD pipeline
consisting of

- `dio` (f0 extraction)
- `stonemask` (f0 refinement)
- `cheaptrick` (spectrogram extraction)
- `d4c` (aperiodicity extraction)
"""
function world(x::Vector{Float64}, fs::Int, algorithm = Harvest())
    f0, timestamps = extract_f0(x, fs, algorithm)
    spectrogram = cheaptrick(x, fs, timestamps, f0)
    fft_size = (size(spectrogram, 1) - 1) * 2
    aperiodicity = d4c(x, fs, timestamps, f0, fft_size)
    (f0 = f0, sp = spectrogram, ap = aperiodicity)
end

function world(x::AbstractVector{<:Real}, fs, algorithm = Harvest())
    world(convert(Vector{Float64}, x), convert(Int, fs), algorithm)
end

function world(x::AbstractMatrix{<:Real}, fs, algorithm = Harvest())
    if any(==(1), size(x))
        x = vec(x)
    else
        error("Only signals that are vector-like (one dimension length 1) are allowed.")
    end
    world(convert(Vector{Float64}, x), convert(Int, fs), algorithm)
end

function extract_f0(x, fs, ::Harvest)
    refined_f0, timestamps = harvest(x, fs)
end

function extract_f0(x, fs, ::Dio)
    f0, timestamps = dio(x, fs)
    refined_f0 = stonemask(x, fs, timestamps, f0)
    refined_f0, timestamps
end
end