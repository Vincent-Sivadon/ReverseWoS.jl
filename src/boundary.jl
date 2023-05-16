
function genboundswalks(g,h,∂Ω,is∂Ωn,sample_b,nwalks,ϵ)
    boundswalks = WalksData(Float32[],Float32[],Float32[],Float32[])
    ξ = 20*ϵ
    
    # Is there Neumann conditions ?
    neumann = true
    is∂Ωn == 0 && (neumann = false)

    for _ ∈ 1:nwalks
        z,pz = sample_b()
        val = g(z...)
        neumann && is∂Ωn(z...) && (val=h(z...))
        n = normal(z...,∂Ω)
        y = z .- ξ .* n
        ry = ∂Ω(y...)
        
        while ry > ϵ
            push!(boundswalks.x,y[1])
            push!(boundswalks.y,y[2])
            push!(boundswalks.h,val/(pz*nwalks*ξ))
            push!(boundswalks.r,ry)

            y = rand_on_ball(y...,ry)
            ry = ∂Ω(y...)
        end
    end
    boundswalks
end