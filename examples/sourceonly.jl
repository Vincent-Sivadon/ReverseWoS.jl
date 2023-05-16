using ReverseWoS
using CairoMakie

# Problem definition
f(x,y) = 1.
Ω = ((-1,1),(-1,1))
function ∂Ω(x,y)
    vx = abs(x)-1   ; vy = abs(y)-1 ;
    dx = max(vx,0)  ; dy = max(vy,0)
    - (sqrt(dx*dx + dy*dy) + min(max(vx,vy),0))
end
function sample_s()
    x = 2 * rand() - 1
    y = 2 * rand() - 1
    (x,y),1/4
end

ngrid = 200
nwalks = 1e6
axs,u = ReverseWoS.SolveGPU(f,0,0,Ω,∂Ω,0,sample_s,0,ngrid=ngrid,nwalks=nwalks)

ReverseWoS.plot2D(axs,u,figure=(;resolution=(700,700)))