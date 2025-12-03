include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

using Random
Random.seed!(1)

n = 20
P = rand(n,2)
angles = PointsetAngles(P)

function LineLovasz()
    
    
    
    slp = 5
    
    α = 13π/16
    θ = -α/2
    b = 0
    o = 0
    i = 0
    p = 11
    q = 0
    

    θs = [θ]
    bs = [b]
    os = [o]
    is = [i]
    ps = [p]
    qs = [q]
    
    fig = EmptyFig()
    PlotPointset!(P, indices = true)
    PlotAlphaCone!(P[p,:], α, θ, color = :pink)
    display(fig)
    sleep(slp)
    
    state = :rotate
    step = 1
    
    while step ≤ 3
        # fig = EmptyFig()
        # PlotPointset!(P, indices = true)
        
        println("
            step = $step
            state = $state
            θ = $θ
            o = $o
            p = $p
            q = $q
            ")
        if state == :rotate
            
            q, b = ConeRotationNextPivot(p, α, θ, angles[p,:])
            β = angles[p,q]
            o = (-1)^b
            θ = β + o * α/2
            
            PlotAlphaCone!(P[p,:], α, θ, color = :pink)
            display(fig)
            sleep(1)
            
            
            if o == -1
                p, q = q, p
            end
            state = :slide
            
        elseif state == :slide
            PlotCapableArc!(α, P[p,:], P[q,:], color = :pink, linestyle = :solid)
            C = CapableArcCenter(α, P[p,:], P[q,:])
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
            
            q_excluded = (include_q.==false)
            p_excluded = (include_p.==false)
            
            try p_excluded[ps[end-1]] = true catch nothing end
            #try p_excluded[qs[end-1]] = true catch nothing end
            #try q_excluded[ps[end-1]] = true catch nothing end
            try q_excluded[qs[end-1]] = true catch nothing end

            # println("p_ex = $p_excluded")
            # println("q_ex = $q_excluded")
            
            r, i = ConeSlidingNextPivot(
                    o,
                    p,
                    q,
                    α,
                    θ,
                    Ap,
                    Aq,
                    p_excluded = p_excluded ,
                    q_excluded = q_excluded 
                )

            
            println("r = $r, i = $i")
            if i == 1
                θ = pang(angles[p,r] - α/2)
                p = r
            elseif i == 2
                θ = pang(angles[r,p] - α/2)
                p = r
            elseif i == 3
                θ = pang(angles[r,q] + α/2)
                q = r
            elseif i == 4
                θ = pang(angles[q,r] + α/2)
                q = r
            elseif i == 5
                θ = pang(angles[p,q] + π - α/2)
                state = :rotate
            end

            if i ≠ 5
                PlotAlphaCone!(P[p,:], P[q,:], α, θ, color = :pink)
            else
                PlotAlphaCone!(P[q,:], α, θ, color = :pink)
            end

            println("
ps = $(ps[end]) 
qs = $(qs[end]) 
θs = $(θs[end]) 
θ  = $θ                
            ")
                
            PlotCapableArc!(α, P[ps[end],:], P[qs[end],:], θs[end], θ, color = :red, linestyle = :solid)

            display(fig)
            sleep(slp)
        end
        step += 1  
                
        push!(θs, θ)
        push!(bs, b)
        push!(os, o)
        push!(is, i)
        push!(ps, p)
        push!(qs, q)
    end
    return fig, θs, bs, os, is, ps, qs
end

fig, θs, bs, os, is, ps, qs = LineLovasz()