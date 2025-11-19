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

function PlotPointAngleLine!(
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

function PlotPointAngleRay!(
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