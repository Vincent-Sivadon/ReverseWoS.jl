using ReverseWoS
using CairoMakie

f(x,y) = 2.
g(x,y) = 1.
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
function sample_b()
    x = 2 * rand() - 1
    y = 1
    (x,y),1/2
end

ngrid = 200
nwalks = 1e5
axs,u = ReverseWoS.SolveGPU(f,g,0,Ω,∂Ω,0,sample_s,sample_b,ngrid=ngrid,nwalks=nwalks)

ReverseWoS.plot2D(axs,u,figure=(;resolution=(700,700)))