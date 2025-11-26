include("../src/plotting_tools.jl")
include("../src/geometry_tools.jl")
include("../src/ak_hull.jl")

function PlotKhullRes!(θs, ps, bs) 
    N = length(ps)
# plot!(
    #     background_color = :lightgray, 
    #     background_color_outside = :white
    # )
    X = [
        0 0
        1 0
        1 1
        0 1
        0 0
    ]
    plot!(
        X[:,1],
        X[:,2],
        linecolor = false,
        fill = 1,
        fillalpha = 0.1,
        fillcolor = :black,
        label = false
    )
    for i = 1:N
        if bs[i] == 1
             PlotHalfPlane!(
                P[ps[i],:], 
                θs[i], 
                color = :white, 
                alpha = 1
            )
        end    
    end
end


n = 40
P = rand(n,2)

angles = PointsetAngles(P)
fig = EmptyFig(lims = (0, 1))

for k = ceil(Int64,n/2):-1:1
        
    θs, ps, bs = LineLovasz(P, k, maxiter = 5*n, angles = angles)
    
    PlotKhullRes!(θs, ps, bs) 

    #sleep(2)

end

PlotPointset!(P, color = :red, indices = false)
    
display(fig)