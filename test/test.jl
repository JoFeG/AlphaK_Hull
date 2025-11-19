include("../src/plotting_tools.jl")

fig = EmptyFig()
PlotPointAngleLine!(rand(2), 2π*rand(), forwardmark = true)
PlotPointAngleRay!(rand(2), 2π*rand(), color = :blue)

X = [
    0 0
    1 0
    1 1
    0 1
    0 0
]

plot!(X[:,1], X[:,2], label = false)

fig