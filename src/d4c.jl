mutable struct D4COption
    threshold::Float64

    # allow uninitialized creation
    D4COption() = new()
end

function d4c(x::Vector{Float64}, fs::Int, temporal_positions::Vector{Float64}, f0::Vector{Float64}, fft_size::Int)

    d4c_option = Ref(D4COption())
    @ccall libworld.InitializeD4COption(d4c_option::Ptr{D4COption})::Cvoid

    nbins = length(temporal_positions)
    nfreqs = (fft_size ÷ 2) + 1
    aperiodicity = Matrix{Float64}(undef, nfreqs, nbins) # transposed for C

    aperiodicity_pointer_vector = [Ref(aperiodicity, offset)
        for offset in 1:nfreqs:length(aperiodicity)]

    @ccall libworld.D4C(
        x::Ptr{Float64},
        length(x)::Cint,
        fs::Cint,
        temporal_positions::Ptr{Float64},
        f0::Ptr{Float64},
        length(f0)::Cint,
        fft_size::Cint,
        d4c_option::Ptr{D4COption},
        aperiodicity_pointer_vector::Ptr{Ptr{Cdouble}})::Cvoid

    aperiodicity
end