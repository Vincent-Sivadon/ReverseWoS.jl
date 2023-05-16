using ReverseWoS
using CairoMakie

# Problem definition
g(x,y) = 0.
h(x,y) = 1.
Ω = ((-1,1),(-1,1))
∂Ω(x,y) = 1.0 - sqrt(x^2+y^2)
is∂Ωn(x,y) = x>0.8
function sample_b()
    θ = 2π*rand()
    (cos(θ),sin(θ)),1/(2π)
end

ngrid = 50
nwalks = 1e4
axs,u = ReverseWoS.SolveGPU(0,g,h,Ω,∂Ω,is∂Ωn,0,sample_b,ngrid=ngrid,nwalks=nwalks)

ReverseWoS.plot2D(axs,u)