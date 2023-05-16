
function Solve(f,g,h,Ω,∂Ω,is∂Ωn,sample_s,sample_b ; ngrid=50,nwalks=200,ϵ=0.001)
    xs,ys,us = create_datastructures(Ω,ngrid)

    # Is there source terms and/or boundary terms ?
    issource = true ; isbounds = true
    f==0 && (issource=false)
    g==0 && (isbounds=false)

    # Source solution
    if issource
        sourcewalks = gensourcewalks(f,∂Ω,sample_s,nwalks,ϵ)
        for i ∈ 1:ngrid, j ∈ 1:ngrid
            us[i,j] += lookupwalks(xs[i],ys[j],sourcewalks)
        end
    end

    # Boundary solution
    if isbounds
        boundswalks = genboundswalks(g,h,∂Ω,is∂Ωn,sample_b,nwalks,ϵ)
        for i ∈ 1:ngrid, j ∈ 1:ngrid
            us[i,j] += lookupwalks(xs[i],ys[j],boundswalks)
        end
    end

    [xs,ys],us
end

function lookupwalks(x,y,walks)
    u = 0.
    ntotwalks = length(walks.x)
    for i ∈ 1:ntotwalks
        if norm([x,y] - [walks.x[i],walks.y[i]]) < walks.r[i]
            u += walks.h[i] * greens(walks.x[i],walks.y[i],x,y,walks.r[i])
        end
    end
    u
end

function create_datastructures(Ω,ngrid)
    xs = range(Ω[1]...;length=ngrid)
    ys = range(Ω[2]...;length=ngrid)
    us = zeros(Float32,ngrid,ngrid)
    xs,ys,us
end