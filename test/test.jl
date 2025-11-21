include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

# fig = EmptyFig()
# p = [.4,.3]
# q = [.5,.7]
# PlotLine!(p, q, forwardmark = true)
# PlotHalfPlane!(p, q, side = :left)
# PlotRay!([0,.5], -π/4, color = :blue)

# X = [
#     0 0
#     1 0
#     1 1
#     0 1
#     0 0
# ]

# plot!(X[:,1], X[:,2], label = false, color = :black)

# display(PointsetAngles(X))

# fig

P = [
    .1  .45
    .25 .85
    .3  .15
    .75 .25
    .7  .5
    .8  .8
]

fig = EmptyFig()

scatter!(
    P[:,1],
    P[:,2],
    color = :black,
    label = false,
    markersize = 2
)

for i = 1:size(P)[1]
    annotate!(P[i,1], P[i,2]-.04, text("$i", :black, :left, 6))
end

display(fig)

θs, ps, ds = LineLovasz(P,2)

