include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")

fig = EmptyFig()
p = [.4,.3]
q = [.5,.7]
PlotLine!(p, q, forwardmark = true)
PlotHalfPlane!(p, q, side = :left)
PlotRay!([0,.5], -π/4, color = :blue)

X = [
    0 0
    1 0
    1 1
    0 1
    0 0
]

plot!(X[:,1], X[:,2], label = false, color = :black)

display(PointsetAngles(X))

fig