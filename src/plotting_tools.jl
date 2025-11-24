using Plots

function EmptyFig(
        lims = (-.01, 1.01), 
        size = (1200,1200)
)
    fig = plot(
        ratio = 1,
        grid = false,
        axis = false,
        lims = lims,
        size = size
    )
    return fig
end

function PlotLine!(
        p::Vector{<:Real}, 
        q::Vector{<:Real}; 
        forwardmark = false::Bool,
        pointmark = false::Bool,
        color = :red::Symbol,
        len = 10::Real
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()

    x = q[1] - p[1]
    y = q[2] - p[2]
    θ = atan(y, x)
    
    PlotLine!(p, θ, forwardmark = forwardmark, pointmark = pointmark, color = color, len = len)
end

function PlotLine!(
        p::Vector{<:Real}, 
        θ::Real; 
        forwardmark = false::Bool,
        pointmark = false::Bool,
        color = :red::Symbol,
        len = 10::Real
)
    length(p) == 2 || DimensionMismatch()

    if pointmark
        scatter!(
            [p[1]], 
            [p[2]], 
            color = color, 
            markerstrokewidth = 0, 
            label = false
        )
    end
    plot!(
        [p[1] - len*cos(θ), p[1] + len*cos(θ)], 
        [p[2] - len*sin(θ), p[2] + len*sin(θ)], 
        color = color, 
        label = false
    )
    if forwardmark
        plot!(
            [p[1] + .2*cos(θ), p[1] + .21*cos(θ)], 
            [p[2] + .2*sin(θ), p[2] + .21*sin(θ)], 
            color = color, 
            label = false,
            arrow = true
        )
    end
end

function PlotRay!(
        p::Vector{<:Real}, 
        q::Vector{<:Real};
        pointmark = false::Bool,
        color = :red::Symbol,
        len = 10::Real
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()
    
    x = q[1] - p[1]
    y = q[2] - p[2]
    θ = atan(y, x)
    
    PlotRay!(p, θ, pointmark = pointmark, color = color, len = len)
end

function PlotRay!(
        p::Vector{<:Real}, 
        θ::Real;
        pointmark = false::Bool,
        color = :red::Symbol,
        len = 10::Real
)
    length(p) == 2 || DimensionMismatch()

    if pointmark
        scatter!(
            [p[1]], 
            [p[2]], 
            color = color, 
            markerstrokewidth = 0, 
            label = false
        )
    end
    plot!(
        [p[1], p[1] + len*cos(θ)], 
        [p[2], p[2] + len*sin(θ)], 
        color = color, 
        label = false
    )
end

function PlotHalfPlane!(
        p::Vector{<:Real}, 
        q::Vector{<:Real}; 
        side = :right::Symbol,
        color = :gray::Symbol,
        alpha = 0.08::Real,
        len = 10::Real
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()
    
    x = q[1] - p[1]
    y = q[2] - p[2]
    θ = atan(y, x)
    
    PlotHalfPlane!(p, θ, side = side, color = color, alpha = alpha, len = len)
end


function PlotHalfPlane!(
        p::Vector{<:Real}, 
        θ::Real;
        side = :right::Symbol,
        color = :gray::Symbol,
        alpha = 0.08,
        len = 10::Real
)
    length(p) == 2 || DimensionMismatch()
    
    if side == :right
        X = [
            p[1]+len*cos(θ)          p[2]+len*sin(θ)
            p[1]+len*(cos(θ)+sin(θ)) p[2]+len*(sin(θ)-cos(θ))
            p[1]-len*(cos(θ)-sin(θ)) p[2]-len*(sin(θ)+cos(θ))
            p[1]-len*cos(θ)          p[2]-len*sin(θ)
            p[1]+len*cos(θ)          p[2]+len*sin(θ)
        ]
    elseif side == :left
        X = [
            p[1]+len*cos(θ)          p[2]+len*sin(θ)
            p[1]-len*(cos(θ)+sin(θ)) p[2]-len*(sin(θ)-cos(θ))
            p[1]+len*(cos(θ)-sin(θ)) p[2]+len*(sin(θ)+cos(θ))
            p[1]-len*cos(θ)          p[2]-len*sin(θ)
            p[1]+len*cos(θ)          p[2]+len*sin(θ)
        ]
    end
    
    plot!(
        X[:,1],
        X[:,2],
        linecolor = false,
        fill = 0,
        fillalpha = alpha,
        fillcolor = color,
        label = false
    )
end

function PlotPointset!(
        P::Array{<:Real};
        color = :black::Symbol,
        indices = true::Bool
)
    n, d = size(P)
    d == 2 || DimensionMismatch("size(P) should be (n,2)")

    scatter!(
        P[:,1],
        P[:,2],
        color = color,
        label = false,
        markersize = 3,
        markerstrokewidth = 0
    )
    if indices
        for i = 1:n
            annotate!(
                P[i,1], 
                P[i,2] - .015, 
                text("$i", color, :center, 8)
            )
        end
    end
end


