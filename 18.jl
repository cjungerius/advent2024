# Day eighteen solution: 12.145 ms (359049 allocations: 13.18 MiB)
using DataStructures

input =readlines("input/18_input.txt")


function day_eighteen(input)
    
    a = 0
    b = 0
    part_one = 0
    field = falses(71,71)
    dist = 0
    path = Set{CartesianIndex}()

    for (i,line) in enumerate(input)
        a,b = parse.(Int,split(line,","))
        field[a+1,b+1] = true
        if CartesianIndex(a+1,b+1) in path || i == 1024
            dist, path = test_path(field)
            if i == 1024
                part_one = dist
            end
        end
        !isfinite(dist) && break
    end

    part_one, (a, b)
end

function test_path(field)
    dirs = CartesianIndex.([(0,1), (1,0), (0,-1),(-1,0)])
    distances = fill(Inf,size(field))
    prev = fill(CartesianIndex(0,0),size(field))

    start = CartesianIndex(1,1)
    finish = CartesianIndex(71,71)
    
    q = Queue{CartesianIndex}()
    distances[start] = 0
    enqueue!(q,start)

    while !isempty(q)
        u = dequeue!(q)
        for d in dirs
            v = u + d
            if 0 < v[1] ≤ 71 && 0 < v[2] ≤ 71 && !field[v] && !isfinite(distances[v])
                distances[v] = distances[u] + 1
                enqueue!(q,v)
                prev[v] = u
            end
        end
        isfinite(distances[finish]) && break
    end

    path = Set{CartesianIndex}([finish])
    p = prev[finish]
    while p != CartesianIndex(0,0)
        push!(path,p)
        p = prev[p]
    end

    distances[finish], path
end

part_one, part_two = day_eighteen(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)