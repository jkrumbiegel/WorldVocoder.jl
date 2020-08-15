mutable struct CheapTrickOption
    q1::Cdouble
    f0_floor::Cdouble
    fft_size::Cint  # (1, 2, ..., 12)

    # allow uninitialized creation
    CheapTrickOption() = new()
end


function cheaptrick(x::Vector{Float64}, fs::Int, temporal_positions::Vector{Float64}, f0::Vector{Float64})
    cheaptrick_option = Ref(CheapTrickOption())
    @ccall libworld.InitializeCheapTrickOption(
        fs::Cint,
        cheaptrick_option::Ptr{CheapTrickOption})::Cvoid

    fft_size = @ccall libworld.GetFFTSizeForCheapTrick(
        fs::Cint,
        cheaptrick_option::Ptr{CheapTrickOption})::Cint

    f0_floor = @ccall libworld.GetF0FloorForCheapTrick(fs::Cint, fft_size::Cint)::Cdouble

    nfreqs = fft_size ÷ 2 + 1
    nbins = length(f0)

    spectrogram = Matrix{Float64}(undef, nfreqs, nbins) # transposed for C

    spectrogram_pointer_vector = [Ref(spectrogram, offset)
        for offset in 1:nfreqs:length(spectrogram)]

    @ccall libworld.CheapTrick(
        x::Ptr{Cdouble},
        length(x)::Cint,
        fs::Cint,
        temporal_positions::Ptr{Cdouble},
        f0::Ptr{Cdouble},
        length(f0)::Cint,
        cheaptrick_option::Ptr{CheapTrickOption},
        spectrogram_pointer_vector::Ptr{Ptr{Cdouble}}
    )::Cvoid

    spectrogram
end