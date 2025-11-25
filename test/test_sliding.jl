include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
Random.seed!(1)

n = 50
P = rand(n,2)

angles = PointsetAngles(P)

α = 5π/6
θ = π/8
p = 46

q, b = ConeRotationNextPivot(p, α, θ, angles[p,:])

fig = EmptyFig()

PlotAlphaCone!(P[p,:], α, angles[p,q] + (-1)^b * α/2)

b == 1 ? PlotCapableArc!(α, P[p,:], P[q,:]) : PlotCapableArc!(α, P[q,:], P[p,:])

PlotPointset!(P)

fig
