# Day 10 solution: 2.737 ms (9793 allocations: 3.04 MiB)
using DataStructures

input = readlines("input/10_input.txt")

function day_ten(input)

    part_one = 0
    part_two = 0
    input_mat = parse.(Int,vcat(reshape.(split.(input,""),1,length(input[1]))...))
    max_x, max_y = size(input_mat)
    directions = CartesianIndex.([(1,0),(-1,0),(0,1),(0,-1)])

    trailheads = findall(==(0),input_mat)
    for trailhead in trailheads
        visited = falses(max_x, max_y)
        to_visit = Queue{CartesianIndex}()
        enqueue!(to_visit,trailhead)

        while !isempty(to_visit)
            cur = dequeue!(to_visit)
            visited[cur] = true
            level = input_mat[cur]
            if level == 9
                part_two += 1
            end
            for dir in directions
                neighbor = cur + dir
                if 0 < neighbor[1] ≤ max_x && 0 < neighbor[2] ≤ max_y && input_mat[neighbor] == level + 1
                    enqueue!(to_visit,neighbor)
                end
            end
        end
        part_one += count(==(9),input_mat[visited])
    end
    part_one, part_two
end

part_one, part_two = day_ten(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)
