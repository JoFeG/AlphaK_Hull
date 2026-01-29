K = size(RES)[1]
COLORS = [:red,:orange,:black]


ANGLES = zeros(K)
C = zeros(Int,K)

ANGLES[1] = RES[1,3]
C[1] = 1

for k = 2:K
    ANGLES[k] = RES[k,3]
    if RES[k-1,2] == :rotate
        C[k] = 1
    elseif RES[k-1,7] == 1
        C[k] = 2
    else
        C[k] = 3
    end
    
end

for i = 1:6
    for k = 2:K
        if C[k] == 1 && ANGLES[k-1] > ANGLES[k]
            ANGLES[k] = ANGLES[k] + 2π
        end
        if C[k] == 3 && ANGLES[k-1] < ANGLES[k]
            ANGLES[k] = ANGLES[k] - 2π
        end
        if C[k] == 2 && ANGLES[k-1] > ANGLES[k]
            ANGLES[k-1] = ANGLES[k-1] - 2π
        end
    end
end



plot(1:K-1,ANGLES[1:end-1],color=COLORS[C[2:end]],label=false)