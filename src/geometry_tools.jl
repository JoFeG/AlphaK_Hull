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
        c = (p + q) / 2 - [0 1;-1 0] * ((p - q) / (2tan(α)))
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
                x = P[j,1] - P[i,1]
                y = P[j,2] - P[i,2]
                β = atan(y, x)
                
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