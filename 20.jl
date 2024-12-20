# Day 20 solution: 225.612 ms (259341 allocations: 13.69 MiB)

using DataStructures

input = readlines("input/20_input.txt")

function day_twenty(input)
    max_x, max_y = (length(input[1]),length(input))
    start = (0,0)
    finish = (0,0)
    walls = Set{Tuple{Int,Int}}()

    for (y, line) in enumerate(input)
        push!(walls,[(y,x) for x in findall('#',line)]...)

        if !isnothing(findfirst('S',line))
            start = (y, findfirst('S', line))
        end
        if !isnothing(findfirst('E', line))
            finish = (y, findfirst('E', line))
        end
    end   

        dirs = [(0,1), (1,0), (0,-1),(-1,0)]
        distances = Dict{Tuple{Int,Int},Int}()
        prev = Dict{Tuple{Int,Int},Tuple{Int,Int}}()
        prev[start] = (0,0)
        
        q = Queue{Tuple{Int,Int}}()
        distances[start] = 0
        enqueue!(q,start)

        while !isempty(q)
            u = dequeue!(q)
            for d in dirs
                v = u .+ d
                if 0 < v[1] ≤ max_y && 0 < v[2] ≤ max_x && v ∉ walls && v ∉ keys(distances)
                    distances[v] = distances[u] + 1
                    enqueue!(q,v)
                    prev[v] = u
                end
            end
        end

        path = Set{Tuple{Int,Int}}([finish])
        p = prev[finish]
        while p != (0,0)
            push!(path,p)
            p = prev[p]
        end

        cheat_starts = Tuple{Int,Int}[]
        for d in 0:20 
            for dx in -d:d  
                dy1 = d - abs(dx) 
                dy2 = -(d - abs(dx))
                dx == 0 && dy1 == 0 && continue
              
                push!(cheat_starts, (dx, dy1))
                if dy1 != dy2  
                    push!(cheat_starts, (dx, dy2))
                end
            end
        end

    part_one = 0
    part_two = 0

    for cheat_end in path
        target = distances[cheat_end]
        target ≤ 100 && continue
        for cheat_start in cheat_starts
            shortcut = cheat_end .+ cheat_start
            if shortcut in path
                new_d = distances[shortcut] + abs(cheat_start[1]) + abs(cheat_start[2])
                if new_d < target
                    short = target - new_d
                    if short ≥ 100
                        part_two += 1
                        abs(cheat_start[1]) + abs(cheat_start[2]) ≤ 2 && (part_one += 1)
                    end
                    
                end
            end
        end
    end
    part_one, part_two
end

part_one, part_two = day_twenty(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)
