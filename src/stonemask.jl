function stonemask(
    x::Vector{Float64},
    fs::Int,
    temporal_positions::Vector{Float64},
    f0::Vector{Float64})

    refined_f0 = similar(f0)

    @ccall libworld.StoneMask(
        x::Ptr{Float64},
        length(x)::Cint,
        fs::Cint,
        temporal_positions::Ptr{Float64},
        f0::Ptr{Float64},
        length(f0)::Cint,
        refined_f0::Ptr{Float64})::Cvoid

    refined_f0
end