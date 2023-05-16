
function SolveGPU(f,g,h,Ω,∂Ω,is∂Ωn,sample_s,sample_b ; ngrid=50,nwalks=200,ϵ=0.001)
    xs,ys,us = create_datastructures_gpu(Ω,ngrid)

    # Is there source terms and/or boundary terms ?
    issource = true ; isbounds = true
    f==0 && (issource=false)
    g==0 && (isbounds=false)

    # GPU kernel informations
    threads = (32,32)
    blocks = ceil.(Int64, (ngrid,ngrid) ./ threads)

    # Source solution
    if issource
        sw = gensourcewalks(f,∂Ω,sample_s,nwalks,ϵ)
        sntotwalks = length(sw.x)
        swx = CuArray(sw.x) ; swy = CuArray(sw.y)
        swh = CuArray(sw.h) ; swr = CuArray(sw.r)
        @cuda threads=threads blocks=blocks lookup_kernel!(us,xs,ys,swx,swy,swh,swr,sntotwalks)
    end

    if isbounds
        bw = genboundswalks(g,h,∂Ω,is∂Ωn,sample_b,nwalks,ϵ)
        bntotwalks = length(bw.x)
        bwx = CuArray(bw.x) ; bwy = CuArray(bw.y)
        bwh = CuArray(bw.h) ; bwr = CuArray(bw.r)
        @cuda threads=threads blocks=blocks lookup_kernel!(us,xs,ys,bwx,bwy,bwh,bwr,bntotwalks)
    end

    [Array(xs),Array(ys)],Array(us)
end

function lookup_kernel!(us,xs,ys,walksx,walksy,walksh,walksr,ntotwalks)  
    # Thread id
    ix = (blockIdx().x - 0x1) * blockDim().x + threadIdx().x
    iy = (blockIdx().y - 0x1) * blockDim().y + threadIdx().y

    if ix <= size(us)[1] && iy <= size(us)[2]
        uᵢⱼ = 0.
        for i ∈ 1:ntotwalks
            d = sqrt((xs[ix] - walksx[i])^2 + (ys[iy] - walksy[i])^2)
            if (d < walksr[i])
                uᵢⱼ += walksh[i] * log(walksr[i]/d) / 2π
            end
        end
        @inbounds us[ix,iy] += uᵢⱼ
    end

    return
end

function create_datastructures_gpu(Ω,ngrid)
    xs = CuArray(collect(Float32,range(Ω[1]...;length=ngrid)))
    ys = CuArray(collect(Float32,range(Ω[2]...;length=ngrid)))
    us = CuArray(zeros(Float32,ngrid,ngrid))
    xs,ys,us
end