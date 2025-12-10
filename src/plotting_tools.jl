using Plots

function EmptyFig(;
        lims = (-.1, 1.1), 
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

function PlotCapableArc!(
        α::Real,
        p::Vector{<:Real}, 
        q::Vector{<:Real},
        θ_0::Real,
        θ_1::Real;
        o = 1::Integer,
        color = :red::Symbol,
        linestyle = :dash
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()
    c = CapableArcCenter(α, p, q, o = o)
    r = sqrt(sum((c - p).^2))

    x_0 = PointAngleLinesInt(p, θ_0 + o * α/2, q, θ_0 - o * α/2)  
    x_1 = PointAngleLinesInt(p, θ_1 + o * α/2, q, θ_1 - o * α/2)
    
    β_0 = pang(atan(x_0 - c))
    β_1 = pang(atan(x_1 - c))

    β = LinRange(β_0, β_1, 60)
    
    plot!(
        c[1] .+ r*cos.(β), 
        c[2] .+ r*sin.(β), 
        color = color,
        linestyle = linestyle,
        label = false
    )
end


function PlotCapableArc!(
        α::Real,
        p::Vector{<:Real}, 
        q::Vector{<:Real};
        o = 1::Integer,
        color = :red::Symbol,
        linestyle = :dash
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()
    c = CapableArcCenter(α, p, q, o = o)
    r = sqrt(sum((c - p).^2))
    
    β_0 = atan(p - c) + 2π
    β = LinRange(β_0, β_0 + o * (2π - 2α), 60)
    plot!(
        c[1] .+ r*cos.(β), 
        c[2] .+ r*sin.(β), 
        color = color,
        linestyle = linestyle,
        label = false
    )
end

function PlotLine!(
        p::Vector{<:Real}, 
        q::Vector{<:Real}; 
        forwardmark = false::Bool,
        pointmark = false::Bool,
        color = :red::Symbol,
        linestyle = :solid::Symbol,
        len = 10::Real
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()
    
    θ = atan(q - p)
    PlotLine!(p, θ, forwardmark = forwardmark, pointmark = pointmark, color = color, linestyle = linestyle, len = len)
end

function PlotLine!(
        p::Vector{<:Real}, 
        θ::Real; 
        forwardmark = false::Bool,
        pointmark = false::Bool,
        color = :red::Symbol,
        linestyle = :solid::Symbol,
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
        linestyle = linestyle,
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
        linestyle = :solid::Symbol,
        len = 10::Real
)
    length(p) == 2 && length(q) == 2 || DimensionMismatch()
    
    θ = atan(q - p)
    PlotRay!(p, θ, pointmark = pointmark, color = color, linestyle = linestyle, len = len)
end

function PlotRay!(
        p::Vector{<:Real}, 
        θ::Real;
        pointmark = false::Bool,
        color = :red::Symbol,
        linestyle = :solid::Symbol,
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
        linestyle = linestyle,
        label = false
    )
end

function PlotAlphaCone!(
        p::Vector{<:Real},
        q::Vector{<:Real},
        α::Real,
        θ::Real;
        pointmark = false::Bool,
        color = :red::Symbol,
        len = 10::Real
) 
    x = PointAngleLinesInt(p, θ + α/2, q, θ - α/2)
    PlotRay!(x, θ + α/2, color = color)
    PlotRay!(x, θ - α/2, color = color)
end    

function PlotAlphaCone!(
        x::Vector{<:Real},
        α::Real,
        θ::Real;
        pointmark = false::Bool,
        color = :red::Symbol,
        len = 10::Real
)
    if pointmark
        scatter!(
            [x[1]], 
            [x[2]], 
            color = color, 
            markerstrokewidth = 0, 
            label = false
        )
    end

    plot!(
        [x[1], x[1] + len*cos(θ + α/2)], 
        [x[2], x[2] + len*sin(θ + α/2)], 
        color = color, 
        label = false
    )
    plot!(
        [x[1], x[1] + len*cos(θ - α/2)], 
        [x[2], x[2] + len*sin(θ - α/2)], 
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
    
    θ = atan(q - p)
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
        indices = true::Bool,
        markersize = 3::Integer
)
    n, d = size(P)
    d == 2 || DimensionMismatch("size(P) should be (n,2)")

    scatter!(
        P[:,1],
        P[:,2],
        color = color,
        label = false,
        markersize = markersize,
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


