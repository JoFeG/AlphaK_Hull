include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
Random.seed!(2)

X = [
       -620.5 -72.0
       -585.5 55.0
       -438.5 157.0
       -249.5 226.0
       12.5 251.0
       207.5 212.0
       333.5 -27.0
       -53.5 -362.0
       -433.5 -299.0
       -146.5 -148.0
       120.5 -125.0
       -92.5 130.0
       -390.5 -169.0
       173.5 57.0
       340.5 -238.0
       75.5 -272.0
       -269.5 -54.0
       ]
function foo!(X)
           Mx = maximum(X[:,1])
           mx = minimum(X[:,1])
           My = maximum(X[:,2])
           my = minimum(X[:,2])
           X = X .- [mx my]
           X = X / max(Mx-mx, My-my)
           return X
       end
P = foo!(X)

angles = PointsetAngles(P)


function LineLovasz()
    n = size(P)[1]
    slp = 0# 0.2
    
    α = 1.2π/2
    
    θ = 0.0   
    p = 11
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
    
#     println("
# step = $step
#             θ = $θ
#             p = $p
#             q = $q
#             o = $o
#             b = $b
#             i = $i
# nextstate = $state")
    
    fig = EmptyFig()
    PlotPointset!(P, indices = true)
    PlotAlphaCone!(P[p,:], α, θ, color = :pink)
    display(fig)
    sleep(slp)

    
    while step < 500
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
                pang(θ - α/2) < pang(Aq[p] - α) ? ϕ = 0 : ϕ = π
                sector_4 = (pang(θ - α/2 + ϕ) .< pang.(Aq .+ ϕ) .< pang(Aq[p] - α + ϕ))
                try sector_4[qs[end-1]] = false catch nothing end
                
                pang(θ - α/2 + π) < pang(Aq[p] - α + π) ? ϕ = 0 : ϕ = π
                sector_3 = (pang(θ - α/2 + π + ϕ) .< pang.(Aq .+ ϕ) .< pang(Aq[p] - α + π + ϕ)) .& indisk
                try sector_3[qs[end-1]] = false catch nothing end

                pang(θ + α/2 + π) < pang(Ap[q]) ? ϕ = 0 : ϕ = π
                sector_2 = (pang(θ + α/2 + π + ϕ) .< pang.(Ap .+ ϕ) .< pang(Ap[q] + ϕ)) .& indisk .& (sector_3 .== false)
                
                pang(θ + α/2) < pang(Ap[q] + π) ? ϕ = 0 : ϕ = π
                sector_1 = (pang(θ + α/2 + ϕ) .< pang.(Ap .+ ϕ) .< pang(Ap[q] + π + ϕ))
            else
                pang(Aq[p] + α) < pang(θ + α/2) ? ϕ = 0 : ϕ = π
                sector_4 = (pang(Aq[p] + α + ϕ) .< pang.(Aq .+ ϕ) .< pang(θ + α/2 + ϕ))
                try sector_4[qs[end-1]] = false catch nothing end
                
                pang(Aq[p] + α + π) < pang(θ + α/2 + π) ? ϕ = 0 : ϕ = π
                sector_3 = (pang(Aq[p] + α + π + ϕ) .< pang.(Aq .+ ϕ) .< pang(θ + α/2 + π + ϕ)) .& indisk
                try sector_3[qs[end-1]] = false catch nothing end   

                pang(Ap[q]) < pang(θ - α/2 + π) ? ϕ = 0 : ϕ = π
                sector_2 = (pang(Ap[q] + ϕ) .< pang.(Ap .+ ϕ) .< pang(θ - α/2 + π + ϕ)) .& indisk .& (sector_3 .== false)

                pang(Ap[q] + π) < pang(θ - α/2) ? ϕ = 0 : ϕ = π
                sector_1 = (pang(Ap[q] + π + ϕ) .< pang.(Ap .+ ϕ) .< pang(θ - α/2 + ϕ))
            end
            p_excluded =  (sector_1 .== false) .& (sector_2 .== false)
            q_excluded =  (sector_3 .== false) .& (sector_4 .== false)

            ## CHECK HERE
            try p_excluded[ps[end-1]] = true catch nothing end
            #try p_excluded[qs[end-1]] = true catch nothing end
            #try q_excluded[ps[end-1]] = true catch nothing end
            #try q_excluded[qs[end-1]] = true catch nothing end

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
#             println("
# step = $step
#             θ = $θ
#             p = $p
#             q = $q
#             o = $o
#             b = $b
#             i = $i
# nextstate = $state")

#if step > 39
        if i == 0
        elseif (i == 5) & (i == 0) ## CHECK HERE
            o == 1 ? COLOR = :orange : COLOR = :black
            PlotCapableArc!(α, P[ps[end],:], P[qs[end],:], o = o, color = COLOR, linestyle = :solid)
        else
            o == 1 ? COLOR = :orange : COLOR = :black
            PlotCapableArc!(α, P[ps[end],:], P[qs[end],:], θs[end], θ, o = o, color = COLOR, linestyle = :solid)
        end
#end
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
        
        if step > 2 && ps[end] == ps[3] && qs[end] == qs[3] && pang(θs[end] - θs[3]) < 1e-5 # CHECK pang in angle termination
            println("BREAK")
            break
        end            
    end
    return θs, ps, qs, os, bs, is, fig, state
end

θs, ps, qs, os, bs, is, fig, state = LineLovasz()

RES = cat(0:length(ps)-1,push!([is[i] == 0 ? :rotate : :slide for i = 2:length(is)],state),round.(θs, digits=3), round.((θs - 2π*(θs .> π))*180/π, digits=1),ps,qs,os,bs,is,dims=2)

