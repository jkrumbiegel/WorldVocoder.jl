function synthesis(f0, spectrogram, aperiodicity, fs, frame_period = DEFAULT_FRAME_PERIOD)

    if size(spectrogram) != size(aperiodicity)
        error("Sizes of spectrogram $(size(spectrogram)) and aperiodicity $(size(aperiodicity)) don't match.")
    end

    nfreqs = size(spectrogram, 1)

    aperiodicity_pointer_vector = [Ref(aperiodicity, offset)
        for offset in 1:nfreqs:length(aperiodicity)]

    spectrogram_pointer_vector = [Ref(spectrogram, offset)
        for offset in 1:nfreqs:length(spectrogram)]

    fft_size = (nfreqs - 1) * 2

    f0_length = length(f0)
    y_length = trunc(Int, f0_length * frame_period * fs / 1000)
    y = Vector{Float64}(undef, y_length)

    @ccall libworld.Synthesis(
        f0::Ptr{Cdouble},
        f0_length::Cint,
        spectrogram_pointer_vector::Ptr{Ptr{Cdouble}},
        aperiodicity_pointer_vector::Ptr{Ptr{Cdouble}},
        fft_size::Cint,
        frame_period::Cdouble,
        fs::Cint,
        y_length::Cint,
        y::Ptr{Cdouble}
    )::Cvoid

    y
end