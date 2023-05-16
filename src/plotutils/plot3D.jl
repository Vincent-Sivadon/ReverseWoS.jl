@info "Loading WalkOnSphereSim 3D plot utilities"

using .GLMakie

"Plot WoS 3D solutions"
function plot3D(axs,u;kwargs...)
    GLMakie.activate!()

    # Output dimension
    odim = length(u[1])
    if odim==1
        return plot3Dscalar(axs,u;kwargs...)
    elseif odim==3
        return plot3Dvector(axs,u;kwargs...)
    end

    println("WalkOnSphereSim Error : can't handle this output dimension")
end

"Plots the 3D scalar field `u`"
function plot3Dscalar(axs,u;kwargs...)   
    u[abs.(u).<=0.00001] .= NaN

    f,ax,ct = contour(
        axs[1], axs[2], axs[3], u;
        levels=10,
        colormap=:viridis, transparency=true,
        figure = (; resolution=(800,800)),
        axis=(;
            type = Axis3, title="3D scalar field",
            perspectiveness=0.5,azimuth=2.19,elevation=0.57,
            aspect=:data
        ),
        kwargs...
    )
    Colorbar(f[1,2],ct,width = 20)
    f,ax,ct
end

"Plots the 3D vector field `u`"
function plot3Dvector(axs,u;kwargs...)
    ngrid = size(u)[1]
    minlen = round(minimum(norm,u[:]))
    maxlen = round(maximum(norm,u[:]))
    scale = 2/10 * maxlen / abs(max(axs[1]...) - min(axs[1]...))
    @show scale

    coords  = [Point3f(x, y, z) for x in axs[1] for y in axs[2] for z in axs[3]]
    indices = [Point3(i, j, k) for i in 1:ngrid for j in 1:ngrid for k in 1:ngrid]
    ns = map(p -> scale * Vec3f(u[p[1], p[2], p[3]]), indices)

    # 0 -> NaN (out of bounds values)
    for i ∈ eachindex(ns)
        tobenaned = false
        for el in ns[i]
            abs(el) < 0.0001 && (tobenaned = true)
        end
        tobenaned && (ns[i] =Vec3f(NaN))
    end
    lengths = norm.(ns)
    
    f,ax,ar = arrows(
        coords,ns,
        fxaa=true,
        color=lengths, colormap=:viridis,
        linewidth = scale/5, arrowsize = Vec3f(scale/2, scale/2, scale/2),
        align = :center,
        figure = (; resolution=(800,800)),
        axis=(;
            type = Axis3, title="3D Vector field",
            perspectiveness=0.5,azimuth=2.19,elevation=0.57,
            aspect=:data
        ),
        kwargs...
    )
    #hidedecorations!(ax)
    Colorbar(
        f[1,2], limits=(minlen,maxlen), colormap=:viridis,width = 20
    )
    f,ax,ar
end
