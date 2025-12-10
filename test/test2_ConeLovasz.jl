include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
Random.seed!(3)

n = 16
P = rand(n,2)
angles = PointsetAngles(P)

function LineLovasz()
    n = size(P)[1]
    slp = 0
    
    α = 13π/16
    
    θ = pang(-α/2)   
    p = 5
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
    

    
    while step ≤ 41
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
                sector_4 = (pang(θ - α/2    ) .< Aq .< pang(Aq[p] - α    ))
                sector_3 = (pang(θ - α/2 + π) .< Aq .< pang(Aq[p] - α + π)) .& indisk
                sector_2 = (pang(θ + α/2 + π) .< Ap .< pang(Ap[q]        )) .& indisk .& (sector_3 .== false)
                sector_1 = (pang(θ + α/2    ) .< Ap .< pang(Ap[q] + π    ))
            else
                sector_4 = (pang(Aq[p] + α    ) .< Aq .< pang(θ + α/2    ))
                sector_3 = (pang(Aq[p] + α + π) .< Aq .< pang(θ + α/2 + π)) .& indisk
                sector_2 = (pang(Ap[q]        ) .< Ap .< pang(θ - α/2 + π)) .& indisk .& (sector_3 .== false)
                sector_1 = (pang(Ap[q] + π    ) .< Ap .< pang(θ - α/2    ))
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
        elseif (i == 5) & is[end] == 0
            PlotCapableArc!(α, P[ps[end],:], P[qs[end],:], o = o, color = :red, linestyle = :solid)
        else
            PlotCapableArc!(α, P[ps[end],:], P[qs[end],:], θs[end], θ, o = o, color = :red, linestyle = :solid)
        end
        display(fig)
        sleep(slp)

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

θs, ps, qs, os, bs, is, fig = LineLovasz()

cat(0:length(ps)-1,round.(Int,(θs - 2π*(θs .> π))*180/π),ps,qs,os,bs,is,dims=2)

