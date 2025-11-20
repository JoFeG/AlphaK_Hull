using Plots

function EmptyFig(
        lims = (-.2, 1.2), 
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
        color = :red::Symbol,
        len = 10::Real
)
    θ = atan(q[2] - p[2], q[1] - p[1])
    PlotLine!(p, θ, forwardmark = forwardmark, color = color, len = len)
end

function PlotLine!(
        p::Vector{<:Real}, 
        θ::Real; 
        forwardmark = false::Bool, 
        color = :red::Symbol,
        len = 10::Real
)
    scatter!(
        [p[1]], 
        [p[2]], 
        color = color, 
        markerstrokewidth = 0, 
        label = false
    )
    
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
        color = :red::Symbol,
        len = 10::Real
)
    θ = atan(q[2] - p[2], q[1] - p[1])
    PlotRay!(p, θ, color = color, len = len)
end

function PlotRay!(
        p::Vector{<:Real}, 
        θ::Real;
        color = :red::Symbol,
        len = 10::Real
) 
    scatter!(
        [p[1]], 
        [p[2]], 
        color = color, 
        markerstrokewidth = 0, 
        label = false
    )
    
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
        alpha = 0.08,
        len = 10::Real
)
    θ = atan(q[2] - p[2], q[1] - p[1])
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
        linewidth = 0,
        fill = 0,
        fillalpha = alpha,
        fillcolor = color,
        label = false
    )
    

end