function LineLovaszNextPivot(
        p::Integer, 
        θ::Real, 
        p_angs::Vector{<:Real}; 
        excluded::Vector{<:Integer}
)
    p_angs[excluded] .= Inf

    # Nearest point FORWARD SIDE (right ray)
    p_angs_r = mod.(p_angs .- θ, 2π)
    p_angs_r[isnan.(p_angs_r)] .= Inf 
    min_p_angs_r = minimum(p_angs_r)

    # Nearest point BACKWRD SIDE (left ray)
    p_angs_l = mod.(p_angs .- (θ + π), 2π)
    p_angs_l[isnan.(p_angs_l)] .= Inf
    min_p_angs_l = minimum(p_angs_l)
    
    if min_p_angs_r < min_p_angs_l
        return argmin(p_angs_r)
    elseif min_p_angs_l < min_p_angs_r
        return argmin(p_angs_l)
    else
        error("Double bump: not yet implemented!
            p = $p
            θ = $θ
            ")
    end
end

function LineLovasz(
        P::Array{<:Real},
        k::Integer;
        maxiter = 1000::Integer
)
    n, d = size(P)
    d == 2 || DimensionMismatch("size(P) should be (n,2)")
    0 < k < ceil(n/2) || DomainError(k, "0 < k < ceil(n/2) is needed.")

    ## Initialization
    angles = PointsetAngles(P)
    θ = 0.0
    p = sortperm(P[:,2])[k] # Index of first apex 
    # HERE WE ARE ASSUMING p IS NOT SPECIAL, FIX THAT CASE LATER.
    
    θs = zeros(Float64,0) # Vector of special dividers angles at each step
    ds = zeros(Int64,0) # Vector of special divider type at each step (1 strict, 0 not) 
    
    step = 1
    ps = [p] # Vector of apex index at each step
    
    while step <= maxiter
        step > 1 ? excluded = [ps[end-1]] : excluded = [ps[end]] 
        q = LineLovaszNextPivot(p, θ, angles[p,:], excluded = excluded)
        β = angles[p, q]

        # CHECK THIS LATER, AFTER IMPLEMENTING FOR (α,k)
        # IS RIGHT BUMP EQUIVALENT TO STRICT DIVIDER? (WRITE AS A LEMMA AND PROVE)
        if 0 < β - θ < π
            θ = β
            push!(ds, 1)
        else
            θ = mod(β - π, 2π)
            push!(ds, 0)
        end
        
        push!(θs, θ)
        push!(ps, q)
        
        p = q

        ## Termination condition 
        if step == 1 || θs[end-1] < θ
            step += 1
        else
            return θs[1:end-1], ps[1:end-2], ds[1:end-1]
        end
    end

    return θs, ps[1:end-1], ds 
end