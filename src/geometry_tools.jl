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
                    β >= 0 ? angles[i, j] = β : angles[i, j] = β + 2π
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