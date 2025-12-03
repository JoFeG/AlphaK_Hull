include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
#Random.seed!(1)

n = 20

P = [
    .28 .22
    .78 .59
]

p =   rand(1:n)
q =  rand(1:n)

println("p=$p q=$q")
α = π/2 + .1 # 
α = π * rand()

if p≠q


P = cat(P, rand(n - 2, 2), dims = 1)
angles = PointsetAngles(P)

θ =  pang(angles[p,q] + .6π) 
#θ = pang(angles[p,q] + .72π)
o = rand([1,-1])
    if o == 1
        θ =  pang(angles[p,q] + α/2)
        
    elseif o == -1
        θ =  pang(angles[q,p] - α/2)
    end
    

fig = EmptyFig()
PlotPointset!(P, indices = true)
PlotPointset!(P[(1:n .!= p) .& (1:n .!= q), :], indices = false)
PlotPointset!(P[(1:n .== p) .| (1:n .== q), :], color = :red, indices = false)
annotate!(P[p,1] + .01, P[p,2] - .01, text("p", :red, :center, 8))
annotate!(P[q,1] + .01, P[q,2] - .01, text("q", :red, :center, 8))

PlotCapableArc!(α, P[p,:], P[q,:])
PlotLine!(P[p,:], P[q,:], color = :red, linestyle = :dash)
PlotRay!(P[q,:], angles[p,q] + π - α, color = :red, linestyle = :dash)
PlotRay!(P[p,:], angles[p,q] + α, color = :red, linestyle = :dash)

C = CapableArcCenter(α, P[p,:], P[q,:])
scatter!([C[1]],[C[2]], color = :red, label=false, markerstrokewidth = 0)
r2 = sum((C - P[p,:]).^2)
incirc = [sum((C - P[i,:]).^2) < r2 for i = 1:n]

###### THIS NEEDS CHECKING AND A FORMAL WRITING! #############################################
Aq = angles[q,:]
Ap = angles[p,:]    
if o == 1    
    include_q = (α .< pang.(Aq[p] .- Aq) .< pang(Aq[p] + α/2 - θ)) .| ((pang(π + α) .< pang.(Aq[p] .- Aq) .< pang(Aq[p] + α/2 - θ  + π)) .& incirc)
    include_p = (pang(θ + α/2 - Ap[q]) .< pang.(Ap .- Ap[q]) .< π) .| ((pang(θ + α/2 - Ap[q] + π) .< pang.(Ap .- Ap[q]) .< 2π) .& incirc)    
elseif o == -1
    include_q = (pang(Aq[p] + α/2 - θ) .< pang.(Aq[p] .- Aq) .< π) .| ((pang(Aq[p] + α/2 - θ  + π) .< pang.(Aq[p] .- Aq) .< 2π) .& incirc)
    include_p = (α .< pang.(Ap .- Ap[q]) .< pang(θ + α/2 - Ap[q])) .| ((pang(α - π) .< pang.(Ap .- Ap[q]) .< pang(θ + α/2 - Ap[q] + π)) .& incirc)    
end
##############################################################################################


PlotPointset!(P[include_p, :], indices = false, color = :cyan, markersize = 5) 
PlotPointset!(P[include_q, :], indices = false, color = :blue, markersize = 3)

println(θ)
PlotAlphaCone!(P[p,:], P[q,:], α, θ, color = :lightblue)

bump, i = ConeSlidingNextPivot(
        o,
        p,
        q,
        α,
        θ,
        Ap,
        Aq,
        p_excluded = (include_p.==false),
        q_excluded = (include_q.==false)
    )

println("i=$i")
if i == 1
    θold = θ
    θ = pang(angles[p,bump] - α/2)
elseif i == 2
    θold = θ
    θ = pang(angles[bump,p] - α/2)
elseif i == 3
    θold = θ
    θ = pang(angles[bump,q] + α/2)
elseif i == 4
    θold = θ
    θ = pang(angles[q,bump] + α/2)
elseif i == 5
    θold = θ
    θ = pang(angles[p,q] + π - α/2)
end
    
    
if i ≠ 5
    PlotAlphaCone!(P[p,:], P[q,:], α, θ, color = :blue)
else
    PlotAlphaCone!(P[q,:], α, θ, color = :blue)
end
    println(bump)
    PlotCapableArc!(α, P[p,:], P[q,:], θold, θ, color = :black, linestyle = :solid)
fig
end