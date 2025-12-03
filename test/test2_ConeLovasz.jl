include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
Random.seed!(1)

n = 20
P = rand(n,2)
angles = PointsetAngles(P)

function LineLovasz()
    n = size(P)[1]
    slp = 2
    
    α = 13π/16
    
    θ = -α/2   
    p = 11
    q = 0
    o = 0
    b = 0
    i = 5
    
    θs = [θ]
    ps = [p]
    qs = [q]
    os = [o]
    bs = [b]
    is = [i]
    
    fig = EmptyFig()
    PlotPointset!(P, indices = true)
    PlotAlphaCone!(P[p,:], α, θ, color = :pink)
    display(fig)
    sleep(slp)
    
    state = :rotate
    step = 0
    
    while step ≤ 3
        println("
step = $step,  state = $state
            θ = $θ
            p = $p
            q = $q
            o = $o
            b = $b
            i = $i
            ")

###### ROTATE STEP ###########################################################
        if state == :rotate
            
            q, b = ConeRotationNextPivot(p, α, θ, angles[p,:])
            o = (-1)^b
            θ = pang(angles[p,q] + o * α/2)
            i = 0
            state = :slide
            
            PlotAlphaCone!(P[p,:], α, θ, color = :pink)
            display(fig)
            sleep(slp)
##############################################################################
            
###### SLIDE STEP ############################################################
        elseif state == :slide

            C = CapableArcCenter(α, P[p,:], P[q,:], o = o)
            r² = sum((C - P[p,:]) .^ 2)
            indisk = [sum((C - P[i,:]) .^ 2) < r² for i = 1:n]

            Ap = angles[p,:]
            Aq = angles[q,:]
            if o == 1
                sector_4 = (pang(θ - α/2 - Aq[p])     .< pang.(Aq .- Aq[p]) .≤ pang(-α))
                sector_3 = (pang(θ - α/2 - Aq[p] + π) .< pang.(Aq .- Aq[p]) .≤ pang(-α + π)) .& indisk
                sector_2 = (pang(θ + α/2 - Ap[q] + π) .< pang.(Ap .- Ap[q]) .≤ 2π) .& indisk .& (sector_3 .== false)
                sector_1 = (pang(θ + α/2 - Ap[q])     .< pang.(Ap .- Ap[q]) .≤ π)
            else
                sector_4 = (α     .≤ pang.(Aq .- Aq[p]) .< pang(θ + α/2 - Aq[p]))
                sector_3 = (α + π .≤ pang.(Aq .- Aq[p]) .< pang(θ + α/2 - Aq[p] + π)) .& indisk
                sector_2 = (0     .≤ pang.(Ap .- Ap[q]) .< pang(θ - α/2 - Ap[q] + π)) .& indisk .& (sector_3 .== false)
                sector_1 = (π     .≤ pang.(Ap .- Ap[q]) .< pang(θ - α/2 - Ap[q]))
            end
            p_excluded =  (sector_1 .== false) .& (sector_2 .== false)
            q_excluded =  (sector_3 .== false) .& (sector_4 .== false)

            r, i = ConeSlidingNextPivot(o, p, q, α, θ, Ap, Aq,
                    p_excluded = p_excluded,
                    q_excluded = q_excluded 
                )
        end
##############################################################################
        
        step += 1          
        push!(θs, θ)
        push!(ps, p)
        push!(qs, q)
        push!(os, o)
        push!(bs, b)
        push!(is, i)

    end
    return θs, ps, qs, os, bs, is, fig
end

fig, θs, bs, os, is, ps, qs = LineLovasz()