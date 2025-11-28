function Base.atan(
        p::Vector{<:Real}
)
    length(p) == 2 || DimensionMismatch()
    return atan(p[2],p[1])
end

function pang(
        θ::Real
)
    θ_pos = mod(θ, 2π)
    if isnan(θ_pos)
        return Inf
    else
        return θ_pos
    end
end

function PointAngleLinesInt(
        p::Vector{<:Real}, 
        α::Real,
        q::Vector{<:Real},
        β::Real
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()

    if α == β
        v = [Inf, Inf]
    else
        a = sin(β) * (p[1] - q[1]) - cos(β) * (p[2] - q[2])
        a = a / sin(α - β)
        v = p + a * [cos(α), sin(α)] 
    end

    return v
end

function CapableArcCenter(
        α::Real,
        p::Vector{<:Real}, 
        q::Vector{<:Real}
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()
    0 < α < π || DomainError(α, "0 < α < π is needed.")

    if α == π/2
        c = (p + q) / 2
    else
        c = (p + q) / 2 - [0 1;-1 0] * (p - q) / (2tan(α))
    end

    return c
end

function PointsetAngles(
        P::Array{<:Real};
        positive = true::Bool
)
    n, d = size(P)
    d == 2 || DimensionMismatch("size(P) should be (n,2)")

    angles = zeros(Float64,n,n)

    for i = 1:n
        for j = 1:n 
            if P[i,:] != P[j,:]
                β = atan(P[j,:] - P[i,:])
                
                if positive
                    β ≥ 0 ? angles[i, j] = β : angles[i, j] = β + 2π
                else
                    angles[i, j] = β    
                end
            else
                angles[i, j] = Inf
            end
        end
    end

    return angles
end