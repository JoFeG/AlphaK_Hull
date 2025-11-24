include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

# P = [
#     .1  .45
#     .25 .85
#     .3  .15
#     .75 .25
#     .7  .5
#     .8  .8
# ]

n = 20
P = rand(n,2)
k = 4

θs, ps, bs = LineLovasz(P, k)

N = length(ps)

fig = EmptyFig()

for i=1:N
    color = [:pink, :red]
    PlotLine!(P[ps[i],:], θs[i], color = color[bs[i]+1])
end

PlotPointset!(P)
display(fig)

function foo(i) 
    fig = EmptyFig()
    PlotPointset!(P)
    PlotLine!(P[ps[i],:], θs[i])
    return fig
end

function boo()
    N = length(ps)
    for i = 1:N
        display(foo(i))
        sleep(1)
    end
end
