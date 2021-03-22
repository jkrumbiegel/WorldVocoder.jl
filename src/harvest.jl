mutable struct HarvestOption
    f0_ceil::Cdouble
    f0_floor::Cdouble
    frame_period::Cdouble

    # allow uninitialized creation
    HarvestOption() = new()
end

function harvest(x::Vector{Float64}, fs::Int; kwargs...)
    harvestoption = Ref(HarvestOption())
    @ccall libworld.InitializeHarvestOption(harvestoption::Ptr{HarvestOption})::Cvoid

    for (symbol, value) in kwargs
        setproperty!(harvestoption[], symbol, value)
    end
    frame_period = harvestoption[].frame_period

    n_harvest_samples = @ccall libworld.GetSamplesForHarvest(fs::Cint, length(x)::Cint, frame_period::Cdouble)::Cint

    # allocate f0 and temporal positions vectors
    f0 = Vector{Cdouble}(undef, n_harvest_samples)
    temporal_positions = similar(f0)

    @ccall libworld.Harvest(x::Ptr{Cdouble}, length(x)::Cint, fs::Cint, harvestoption::Ptr{HarvestOption},
        temporal_positions::Ptr{Cdouble}, f0::Ptr{Cdouble})::Cvoid

    f0, temporal_positions
end