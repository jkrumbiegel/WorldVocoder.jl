module WorldVocoder

const libworld = "/Users/juliuskrumbiegel/dev/c++/World/build/libworld.dylib"
const DEFAULT_FRAME_PERIOD = 5

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
function world(x, fs; kwargs...)
    f0, timestamps = dio(x, fs)
    refined_f0 = stonemask(x, fs, timestamps, f0)
    spectrogram = cheaptrick(x, fs, timestamps, refined_f0)
    fft_size = (size(spectrogram, 1) - 1) * 2
    aperiodicity = d4c(x, fs, timestamps, refined_f0, fft_size)
    refined_f0, spectrogram, aperiodicity
end

end
