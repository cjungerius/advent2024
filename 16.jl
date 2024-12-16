# Day 16 solution: 75.661 ms (1664792 allocations: 52.75 MiB)
using DataStructures

input = readlines("input/16_input.txt")

function day_sixteen(input)
    dirs = CartesianIndex.([(0,1,0), (1,0,0), (0,-1,0),(-1,0,0)])
    current_dir = 1
    walls = falses(length(input),length(input[1]))
    distances = fill(Inf,length(input), length(input[1]), 4)
    prev = fill([],length(input), length(input[1]), 4)
    start = CartesianIndex(1,1,1)
    finish = (0,0)
    pq = PriorityQueue{CartesianIndex, Int}()
    for (y,line) in enumerate(input)
        walls[y,findall('#', line)] .= true
        if !isnothing(findfirst('S',line))
            start = CartesianIndex(y, findfirst('S', line),1)
        elseif !isnothing(findfirst('E', line))
            finish = (y, findfirst('E', line))
        end
    end
    
    distances[start] = 0
    dist = 0
    enqueue!(pq, start => 0)

    while !isempty(pq)
        u = dequeue!(pq)
        d = dirs[u[3]]
        dist = distances[u]
        if !walls[(u + d)[1], (u+d)[2]] && distances[u] + 1 < distances[u+d]
            distances[u+d] = distances[u] + 1
            pq[u+d] = distances[u+d]
            prev[u+d] = [u]
            ((u+d)[1], (u+d)[2]) == finish && break
        elseif !walls[(u+d)[1], (u+d)[2]] && distances[u] + 1 == distances[u+d]
            push!(prev[u+d],u)
        end

        turns = CartesianIndex.([(u[1],u[2],mod1(u[3] - 1,4)), (u[1],u[2],mod1(u[3] + 1,4))])
        for turn in turns
            if distances[u] + 1000 < distances[turn]
                distances[turn] = distances[u] + 1000
                pq[turn] = distances[turn]
                prev[turn] = [u]
            elseif distances[u] + 1000 == distances[turn]
                push!(prev[turn],u)
            end
        end
    end

    S = Set{Tuple{Int,Int}}([finish])
    us = [CartesianIndex(finish[1], finish[2], argmin(distances[finish[1],finish[2],:]))]

    while !isempty(us)
        u = pop!(us)
        for p in prev[u]
            push!(S,(p[1],p[2]))
            push!(us,p)
        end
    end


    part_one = Int(minimum(distances[finish[1],finish[2],:]))
    part_two = length(S)

    part_one, part_two
end


part_one, part_two = day_sixteen(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)