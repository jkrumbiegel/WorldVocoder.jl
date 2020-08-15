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

end
