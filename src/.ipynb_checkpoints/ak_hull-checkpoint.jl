function ConeSlidingNextPivot(
        or::Integer, # Orientation shoul be 1 for counterclockwise, -1 for clockwise
        p::Integer,
        q::Integer,
        α::Real,
        θ::Real,
        p_angs::Vector{<:Real},
        q_angs::Vector{<:Real}; 
        p_excluded = Array{Integer}(undef,0)::Vector{<:Integer},  
        q_excluded = Array{Integer}(undef,0)::Vector{<:Integer}  
)
    if !isempty(p_excluded)
        p_angs[p_excluded] .= Inf
    end
    if !isempty(q_excluded)
        q_angs[q_excluded] .= Inf
    end


    p_angs_l = pang.(or*(p_angs .- (θ + α/2)))
    p_angs_r = pang.(or*(p_angs .- (θ + α/2 + π)))
    q_angs_l = pang.(or*(q_angs .- (θ - α/2 + π)))
    q_angs_r = pang.(or*(q_angs .- (θ - α/2)))

    
    min_p_angs_l = minimum(p_angs_l)
    min_p_angs_r = minimum(p_angs_r)
    min_q_angs_l = minimum(q_angs_l)
    min_q_angs_r = minimum(q_angs_r)


    
    ##### FOR TESTING #####
    T = [min_p_angs_l,min_p_angs_r, min_q_angs_l, min_q_angs_r]
    T = T[T .≠ Inf]
    length(T) ≠ length(unique(T)) && print("MULTIPLE BUMP!!")
    #######################

    i = argmin([
                min_p_angs_l,
                min_p_angs_r, 
                min_q_angs_l, 
                min_q_angs_r,
                2π
            ])
    if i == 1
        bump = argmin(p_angs_l)
    elseif i == 2
        bump = argmin(p_angs_r)
    elseif i == 3
        bump = argmin(q_angs_l)
    elseif i == 4
        bump = argmin(q_angs_r)
    elseif i == 5
        bump = q
    end

    return bump, i
end

function ConeRotationNextPivot(
        p::Integer,
        α::Real,
        θ::Real, 
        p_angs::Vector{<:Real}; 
        excluded = Array{Integer}(undef,0)::Vector{<:Integer}
)
    if !isempty(excluded)
        p_angs[excluded] .= Inf
    end

    p_angs_l = pang.(p_angs .- (θ + α/2))
    min_p_angs_l = minimum(p_angs_l)
        
    p_angs_r = pang.(p_angs .- (θ - α/2))
    min_p_angs_r = minimum(p_angs_r)

    if min_p_angs_l < min_p_angs_r 
        r = argmin(p_angs_l)
        b = 1
    elseif min_p_angs_r < min_p_angs_l
        r = argmin(p_angs_r)
        b = 2
    else
        error("Double bump: not yet implemented!
            p = $p
            θ = $θ
            ")
    end

    return r, b
end
    

function LineLovaszNextPivot(
        p::Integer, 
        θ::Real, 
        p_angs::Vector{<:Real}; 
        excluded = Array{Integer}(undef,0)::Vector{<:Integer}
)
    if !isempty(excluded)
        p_angs[excluded] .= Inf
    end
    
    # Nearest point FORWARD SIDE (right ray)
    p_angs_r = pang.(p_angs .- θ)
    min_p_angs_r = minimum(p_angs_r)

    # Nearest point BACKWARD SIDE (left ray)
    p_angs_l = pang.(p_angs .- (θ + π))
    min_p_angs_l = minimum(p_angs_l)
    
    if min_p_angs_r < min_p_angs_l
        return argmin(p_angs_r), 1
    elseif min_p_angs_l < min_p_angs_r
        return argmin(p_angs_l), 0
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
        maxiter = 1000::Integer,
        angles = Array{Real}(undef,0,0)::Array{<:Real}
)
    n, d = size(P)
    d == 2 || DimensionMismatch("size(P) should be (n,2)")
    0 < k < ceil(n/2) || DomainError(k, "0 < k < ceil(n/2) is needed.")

    ## Initialization
    if isempty(angles)
        angles = PointsetAngles(P)
    end
    θ = 0.0
    p = sortperm(P[:,2])[k] # Index of first apex 
    # HERE WE ARE ASSUMING p IS NOT SPECIAL, FIX THAT CASE LATER.
    
    θs = zeros(Float64,0) # Vector of special dividers angles at each step
    bs = zeros(Int64,0) # Vector of bump side: 0 BACKWARD bump (left), 1 FORWARD bump (right)
    # CONJECTURE: ALL BACKWARD BUMPS GIVE NON-STRICT SPECIAL DIVIDERS  
    # FACT: SOME FOWARD BUMPS GIVE STRICT DIVIDERS BUT NOT ALL
    # CHECK FOR THE RULE; WRITE AS A LEMMA
    
    step = 1
    ps = [p] # Vector of apex index at each step
    
    while step ≤ maxiter
        step > 1 ? excluded = [ps[end-1]] : excluded = [ps[end]] 
        q, b = LineLovaszNextPivot(p, θ, angles[p,:], excluded = excluded)
        # q, b = ConeRotationNextPivot(p, π, θ - π/2, angles[p,:], excluded = excluded)
        β = angles[p, q]

        # b == 1 ? θ = β : θ = pang(β - π)
        θ = pang(β + (1 + (-1)^b) * π/2)
        
        push!(bs, b)
        push!(θs, θ)
        push!(ps, q)
        
        p = q

        ## Termination condition 
        if step == 1 || θs[end-1] < θ
            step += 1
        else
            return θs[1:end-1], ps[1:end-2], bs[1:end-1]
        end
    end

    return θs, ps[1:end-1], bs 
end