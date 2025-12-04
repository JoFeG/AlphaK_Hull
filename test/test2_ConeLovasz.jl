include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
Random.seed!(1)

n = 10
P = rand(n,2)
angles = PointsetAngles(P)

function LineLovasz()
    n = size(P)[1]
    slp = 2
    
    α = 13π/16
    
    θ = pang(-α/2)   
    p = 1
    q = 0
    o = 0
    b = 0
    i = 0
    
    θs = [θ]
    ps = [p]
    qs = [q]
    os = [o]
    bs = [b]
    is = [i]

    state = :rotate
    step = 0    
    
    println("
step = $step
            θ = $θ
            p = $p
            q = $q
            o = $o
            b = $b
            i = $i
nextstate = $state")
    
    fig = EmptyFig()
    PlotPointset!(P, indices = true)
    PlotAlphaCone!(P[p,:], α, θ, color = :pink)
    display(fig)
    sleep(slp)
    

    
    while step ≤ 40
###### ROTATE STEP ###########################################################
        if state == :rotate

            # CHEK HERE!!  excluded 
            step ≥ 1 ? excluded = [ps[end-1]] : excluded = [ps[end]]
            
            q, b = ConeRotationNextPivot(p, α, θ, angles[p,:], excluded = excluded)
            o = (-1)^b
            θ = pang(angles[p,q] + o * α/2)
            i = 0
            state = :slide
##############################################################################
            
###### SLIDE STEP ############################################################
        elseif state == :slide

            C = CapableArcCenter(α, P[p,:], P[q,:], o = o)
            r² = sum((C - P[p,:]) .^ 2)
            indisk = [sum((C - P[j,:]) .^ 2) < r² for j = 1:n]

            Ap = angles[p,:]
            Aq = angles[q,:]
            if o == 1
                sector_4 = (pang(θ - α/2 - Aq[p])     .< pang.(Aq .- Aq[p]) .< pang(-α))
                sector_3 = (pang(θ - α/2 - Aq[p] + π) .< pang.(Aq .- Aq[p]) .< pang(-α + π)) .& indisk
                sector_2 = (pang(θ + α/2 - Ap[q] + π) .< pang.(Ap .- Ap[q]) .< 2π) .& indisk .& (sector_3 .== false)
                sector_1 = (pang(θ + α/2 - Ap[q])     .< pang.(Ap .- Ap[q]) .< π)
            else
                sector_4 = (α     .< pang.(Aq .- Aq[p]) .< pang(θ + α/2 - Aq[p]))
                sector_3 = (α + π .< pang.(Aq .- Aq[p]) .< pang(θ + α/2 - Aq[p] + π)) .& indisk
                sector_2 = (0     .< pang.(Ap .- Ap[q]) .< pang(θ - α/2 - Ap[q] + π)) .& indisk .& (sector_3 .== false)
                sector_1 = (π     .< pang.(Ap .- Ap[q]) .< pang(θ - α/2 - Ap[q]))
            end
            p_excluded =  (sector_1 .== false) .& (sector_2 .== false)
            q_excluded =  (sector_3 .== false) .& (sector_4 .== false)

            ## CHECK HERE
            try p_excluded[ps[end-1]] = true catch nothing end
            try p_excluded[qs[end-1]] = true catch nothing end
            try q_excluded[ps[end-1]] = true catch nothing end
            try q_excluded[qs[end-1]] = true catch nothing end
            
            r, i = ConeSlidingNextPivot(o, p, q, α, θ, Ap, Aq,
                    p_excluded = p_excluded,
                    q_excluded = q_excluded 
                )

            if i == 1
                θ = pang(angles[p,r] - o * α/2)
                p = r
            elseif i == 2
                θ = pang(angles[p,r] - o * α/2 + π)
                p  = r
            elseif i == 3
                θ = pang(angles[q,r] + o * α/2 + π)
                q = r
            elseif i == 4
                θ = pang(angles[q,r] + o * α/2)
                q = r
            elseif i == 5
                θ = pang(angles[q,p] - o * α/2)
                p = q
                state = :rotate
            end
            b = 0
            
        end
##############################################################################
        
        step += 1          
        push!(θs, θ)
        push!(ps, p)
        push!(qs, q)
        push!(os, o)
        push!(bs, b)
        push!(is, i)

#### PLOTING #################################################################
            println("
step = $step
            θ = $θ
            p = $p
            q = $q
            o = $o
            b = $b
            i = $i
nextstate = $state")
        if i == 0
            PlotAlphaCone!(P[p,:], α, θ, color = :pink)
        elseif i == 5
            PlotAlphaCone!(P[p,:], α, θ, color = :pink)
            #PlotCapableArc!(α, P[ps[end-1],:], P[qs[end-1],:], o = o, color = :red, linestyle = :solid)
            PlotCapableArc!(α, P[ps[end-1],:], P[qs[end-1],:], θs[end-1], θ, o = o, color = :red, linestyle = :solid)
        else
            PlotAlphaCone!(P[p,:], P[q,:], α, θ, color = :pink)
            #PlotCapableArc!(α, P[ps[end-1],:], P[qs[end-1],:], o = o, color = :pink, linestyle = :solid)
            PlotCapableArc!(α, P[ps[end-1],:], P[qs[end-1],:], θs[end-1], θ, o = o, color = :red, linestyle = :solid)
        end
        display(fig)
        sleep(slp)

##############################################################################

    end
    return θs, ps, qs, os, bs, is, fig
end

θs, ps, qs, os, bs, is, fig = LineLovasz()