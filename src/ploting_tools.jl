using Plots

function EmptyFig(lims = (-.2, 1.2), size = (1200,1200))
    fig = plot(
        ratio = 1,
        grid = false,
        axis = false,
        lims = lims,
        size = size
    )
    return fig
end