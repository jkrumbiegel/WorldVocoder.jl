module WorldVocoder

export dio

const libworld = "/Users/juliuskrumbiegel/dev/c++/World/build/libworld.dylib"

mutable struct DioOption
    f0_floor::Cdouble
    f0_ceil::Cdouble
    channels_in_octave::Cdouble
    frame_period::Cdouble  # msec
    speed::Cint  # (1, 2, ..., 12)
    allowed_range::Cdouble  # Threshold used for fixing the F0 contour.

    # allow uninitialized creation
    DioOption() = new()
end

function dio(x::Vector{Float64}, fs::Int; kwargs...)

    diooption = Ref(DioOption())
    @ccall libworld.InitializeDioOption(diooption::Ptr{DioOption})::Cvoid

    for (symbol, value) in kwargs
        setproperty!(diooption[], symbol, value)
    end
    frame_period = diooption[].frame_period
    
    n_dio_samples = @ccall libworld.GetSamplesForDIO(fs::Cint, length(x)::Cint, frame_period::Cdouble)::Cint

    # allocate f0 vector
    f0 = Vector{Cdouble}(undef, n_dio_samples)

    duration_ms = 1000 * length(x) / fs
    temporal_positions = collect(0.0:frame_period:duration_ms)

    @ccall libworld.Dio(x::Ptr{Cdouble}, length(x)::Cint, fs::Cint, diooption::Ptr{DioOption},
        temporal_positions::Ptr{Cdouble}, f0::Ptr{Cdouble})::Cvoid

    f0
end

end
