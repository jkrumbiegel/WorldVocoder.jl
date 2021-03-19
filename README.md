# WorldVocoder

![CI](https://github.com/jkrumbiegel/WorldVocoder.jl/workflows/CI/badge.svg)
[![Coverage](https://codecov.io/gh/jkrumbiegel/WorldVocoder.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jkrumbiegel/WorldVocoder.jl)

`WorldVocoder.jl` is a wrapper package for the WORLD vocoder by mmorise https://github.com/mmorise/World.
It calls the original WORLD binary via the WORLD_jll.jl package.

## Usage

```julia
using WorldVocoder

f0, spectrogram, aperiodicity = world(signal, samplerate)
synthesized_signal = synthesis(f0, spectrogram, aperiodicity, samplerate)
```
