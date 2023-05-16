@info "Loading WalkOnSphereSim 2D plot utilities"

using .CairoMakie

"Plot WoS 2D solutions"
function plot2D(axs,u;kwargs...)
    CairoMakie.activate!()

    # Output dimension
    odim = length(u[1])
    if odim==1
        return plot2Dscalar(axs,u;kwargs...)
    elseif odim==2
        return plot2Dvector(axs,u;kwargs...)
    end

    println("WalkOnSphereSim Error : can't handle this output dimension")
end

"Plots the 2D scalar field `u`"
function plot2Dscalar(axs,u;kwargs...)
    # u[abs.(u).<=1e-10] .= NaN

    # Makie
    f,_,hm = heatmap(
        axs[1],axs[2],u;
        colormap=:viridis,
        figure = (; resolution=(600,600)),
        axis = (; title="2D scalar field", xlabel="x", ylabel="y",aspect=1),
        kwargs...
    )
    Colorbar(f[1,2],hm)
    f
end

"Plots the 2D vector field `u`"
function plot2Dvector(axs,u;kwargs...)
    ngrid=size(u)[1]
    ux = [u[i,j][1] for i ∈ 1:ngrid, j ∈ 1:ngrid]
    uy = [u[i,j][2] for i ∈ 1:ngrid, j ∈ 1:ngrid]
    
    strength = vec(sqrt.(ux.^2 .+ uy .^ 2))
    mins = min(strength...)
    maxs = max(strength...)
    lscale = 1.4 * abs(max(axs[1]...) - min(axs[1]...)) / (ngrid * maxs)
    
    # OutOfBounds values -> NaN
    ux[abs.(ux).<=1e-10] .= NaN
    uy[abs.(uy).<=1e-10] .= NaN
    strength = vec(sqrt.(ux.^2 .+ uy .^ 2))
    
    f = Figure(resolution=(600,600))
    ax = Axis(
        f[1,1], title="2D vector field",
        xlabel="x", ylabel="y",
        backgroundcolor = :black,
        aspect=DataAspect()
    )
    # heatmap!(ax,axs[1],axs[2],log10.(sqrt.(ux.^2 .+ uy.^2)),colormap=:viridis)
    arrows!(ax,axs[1],axs[2],ux,uy,
        lengthscale=lscale,
        colormap=:viridis,
        arrowcolor=strength,
        linecolor=strength
    )
    Colorbar(
        f[1,2], width = 20,
        limits=(mins,maxs),
        colormap=:viridis,
    )
    f,ax
end