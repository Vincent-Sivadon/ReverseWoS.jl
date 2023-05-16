using ReverseWoS
using CairoMakie

# Problem definition
g(x,y) = 1.
Ω = ((-1,1),(-1,1))
function ∂Ω(x,y)
    vx = abs(x)-1   ; vy = abs(y)-1 ;
    dx = max(vx,0)  ; dy = max(vy,0)
    - (sqrt(dx*dx + dy*dy) + min(max(vx,vy),0))
end
function sample_b()
    x = 2 * rand() - 1
    y = 1
    (x,y),1/2
end

ngrid = 50
nwalks = 1e4
axs,u = ReverseWoS.SolveGPU(0,g,0,Ω,∂Ω,0,0,sample_b,ngrid=ngrid,nwalks=nwalks)

ReverseWoS.plot2D(axs,u)