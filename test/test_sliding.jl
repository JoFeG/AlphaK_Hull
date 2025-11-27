include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
#Random.seed!(1)

n = 200

P = [
    .28 .22
    .78 .59
]

p =  rand(1:n)
q =  rand(1:n)

println("p=$p q=$q")
α = π * rand()


if p≠q


P = cat(P, rand(n - 2, 2), dims = 1)
angles = PointsetAngles(P)


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
include_q = (α .< pang.(Aq[p] .- Aq) .< π) .| ((pang(π + α) .< pang.(Aq[p] .- Aq) .< 2π) .& incirc)

Ap = angles[p,:]
include_p = (α .< pang.(Ap .- Ap[q]) .< π) # .| ((pang(α - π) .< pang.(Ap .- Ap[q]) .< 2π) .& incirc)
##############################################################################################

PlotPointset!(P[include_q, :], indices = false, color = :green1, markersize = 5)
PlotPointset!(P[include_p, :], indices = false, color = :cyan, markersize = 5) 

θ = pang(angles[p,q] + α/2)
println(θ)
PlotAlphaCone!(P[p,:], α, θ, pointmark = true, color = :lightblue)


Ap[include_p .== false] .= Inf 
p_angs = Ap
Aq[include_q .== false] .= Inf 
q_angs = Aq


# # Nearest point FORWARD SIDE (right ray)
# p_angs_r = pang.(p_angs .- (θp + α/2))
# min_p_angs_r = minimum(p_angs_r)

# Nearest point BACKWARD SIDE (left ray)
p_angs_l = pang.(p_angs .- (θ + α/2))
min_p_angs_l = minimum(p_angs_l)

# Nearest point FORWARD SIDE (right ray)
q_angs_r = pang.(q_angs .- angles[p,q])
min_q_angs_r = minimum(q_angs_r)

# Nearest point BACKWARD SIDE (left ray)
q_angs_l = pang.(q_angs .- (angles[p,q] + π))
min_q_angs_l = minimum(q_angs_l)

i = argmin([min_p_angs_l, min_q_angs_r, min_q_angs_l,2π])
if i == 1
    bump = argmin(p_angs_l)
    θ = pang(angles[p,bump] - α/2)
elseif i == 2
    bump = argmin(q_angs_r)
    θ = pang(angles[q,bump] + α/2)
elseif i == 3
    bump = argmin(q_angs_l)
    θ = pang(angles[bump,q] + α/2)
elseif i == 4
    bump = q
    θ = pang(angles[p,q] + π - α/2)
end

if i ≠ 4
    PlotAlphaCone!(P[p,:], P[q,:], α, θ, color = :blue)
else
    PlotAlphaCone!(P[q,:], α, θ, color = :blue)
end
    println(bump)
fig
end