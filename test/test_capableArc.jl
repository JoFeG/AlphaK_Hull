include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

p = .8 * rand(2) .+ .1
q = .8 * rand(2) .+ .1
α = π * rand()

# α = 5π/8

# p = [0.5, 0.1]
# q = [0.1, 0.8]

c = CapableArcCenter(α, p, q)




r = sqrt(sum((c - p).^2))
γ_0 = atan(p - c)


for γ in LinRange(γ_0, γ_0 + 2π - 2α - 0.001, 60)
    fig = EmptyFig()

    PlotCapableArc!(α, p, q)
    
    scatter!([p[1]],[p[2]], color = :black, label=false)
    annotate!(p[1], p[2] - .015, text("p", :black, :center, 8))
    scatter!([q[1]],[q[2]], color = :black, label=false)
    annotate!(q[1], q[2] - .015, text("q", :black, :center, 8))
    scatter!([c[1]],[c[2]], color = :red, label=false, markerstrokewidth = 0)
    
    x = [c[1]+r*cos(γ), c[2]+r*sin(γ)]
    v = q - x
    θ = atan(v[2], v[1]) + α/2
    PlotAlphaCone!(x, α, θ, color = :blue, pointmark = true)

    display(fig)
    sleep(.1)
end
