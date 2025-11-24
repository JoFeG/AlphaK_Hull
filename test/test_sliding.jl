include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

# n = 50
# P = rand(n,2)

P = [
    .1  .45
    .25 .85
    .3  .15
    .75 .25
    .7  .5
    .8  .8
]

angles = PointsetAngles(P)

α = 5π/6
θ = mod(0 - α/2, 2π)
p = 3

q, b = ConeRotationNextPivot(p, α, θ, angles[p,:])

fig = EmptyFig()

PlotAlphaCone!(P[p,:], α, angles[p,q] + (-1)^b * α/2)

PlotPointset!(P)

fig