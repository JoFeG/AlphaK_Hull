include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

w = -π/6
star = [
    .8  .8
    .25 .85
    .1  .45
    .3  .15
    .75 .25
    .65  .45  
]

P = (star .- 0.5) * [cos(w) sin(w); -sin(w) cos(w)] .+ 0.5

α = 7π/8

fig = EmptyFig()

for (i,j) in [(1,2), (2,3), (3,4), (4,5), (5,1)]
    #PlotLine!(P[i,:],P[j,:], color = :black, linestyle = :dot, linewidth = 2.5)
    PlotCapableArc!(α, P[i,:], P[j,:], o=-1, color = :red, linestyle = :solid, linewidth = 2.5)
end

for (i,j) in [(1,3), (3,5), (5,6), (6,2), (2,4), (4,6), (6,1)]
    #PlotLine!(P[i,:],P[j,:], color = :black, linestyle = :dash, linewidth = 2.5)
    PlotCapableArc!(α, P[i,:], P[j,:], o=-1, color = :red, linestyle = :solid, linewidth = 2.5)
end

PlotAlphaCone!(P[6,:], α, 0, color = :black)


PlotPointset!(P, markersize = 10, indices = false)
display(fig)

savefig(fig,"./out/example_star.pdf")