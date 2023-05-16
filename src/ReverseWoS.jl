module ReverseWoS

using Revise
using Requires
using LinearAlgebra
using CUDA

struct WalksData
    x::Vector{Float32}  # x coordinate of the sphere's center
    y::Vector{Float32}  # y coordinate of the sphere's center
    h::Vector{Float32}  # value (depends on the walk type)
    r::Vector{Float32}  # sphere radius
end

include("utils.jl")
include("solve.jl")
include("solvegpu.jl")
include("source.jl")
include("boundary.jl")

# Code loading
function __init__()
    @require CairoMakie="13f3f980-e62b-5c42-98c6-ff1f3baf88f0"  include("plotutils/plot2D.jl")
    @require GLMakie="e9467ef8-e4e7-5192-8a1a-b1aee30e663a"     include("plotutils/plot3D.jl")
end

end # module ReverseWoS
