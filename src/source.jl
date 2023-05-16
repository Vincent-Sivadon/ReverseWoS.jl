
function gensourcewalks(f,∂Ω,sample_s,nwalks,ϵ)
    sourcewalks = [WalksData(Float32[],Float32[],Float32[],Float32[])  for _ ∈ 1:Threads.nthreads()]

    Threads.@threads for _ ∈ 1:nwalks
        tid = Threads.threadid()

        y,py = sample_s()
        fy = f(y...)
        ry = ∂Ω(y...)
        
        while ry > ϵ
            push!(sourcewalks[tid].x,y[1])
            push!(sourcewalks[tid].y,y[2])
            push!(sourcewalks[tid].h,fy/(py*nwalks))
            push!(sourcewalks[tid].r,ry)

            y = rand_on_ball(y...,ry)
            ry = ∂Ω(y...)
        end
    end

    concatenatewalks(sourcewalks)
end