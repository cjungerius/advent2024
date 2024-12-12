# Day 12 solution: 6.747 ms (26487 allocations: 1.18 MiB)
using DataStructures

input = readlines("input/12_input.txt")

function day_twelve(input)
    field = vcat([reshape([x for x in line],(1,:)) for line in input]...)
    visited = falses(size(field))
    max_x, max_y = size(field)
    directions = CartesianIndex.([(1,0),(0,1),(-1, 0),(0,-1)])
    diags = CartesianIndex.([(1,1),(-1,1),(-1,-1),(1,-1)])
    corner_checker = [false, false, false, false]

    to_visit = Queue{CartesianIndex}()
    area = 1
    circumference = 0
    corners = 0

    part_one = 0
    part_two = 0
    
    for i in CartesianIndices(visited)
        if !visited[i]
            area = 1
            circumference = 0
            corners = 0
            field_type = field[i]
            enqueue!(to_visit,i)
            visited[i] = true

            while !isempty(to_visit)
                cur = dequeue!(to_visit)
                corner_checker .= false
                for i in eachindex(directions)
                    neighbor = cur + directions[i]
                    if 0 < neighbor[1] ≤ max_x && 0 < neighbor[2] ≤ max_y
                        if field[neighbor] != field_type
                            circumference += 1
                            corner_checker[i] = true
                        elseif field[neighbor] == field_type && !visited[neighbor]
                            area += 1
                            visited[neighbor] = true
                            enqueue!(to_visit,neighbor)
                        end
                    else
                        circumference += 1
                        corner_checker[i] = true
                    end
                end
                #convex corner detection
                corner_score = sum(corner_checker)
                if corner_score == 4
                    corners += 4
                elseif corner_score == 3
                    corners += 2
                elseif corner_score == 2 && corner_checker != [true, false, true, false] && corner_checker != [false, true, false, true]
                    corners += 1
                end
                # #concave corner detection
                for i in eachindex(diags)
                     diagonal = cur + diags[i]
                        if !(0 < diagonal[1] ≤ max_x && 0 < diagonal[2] ≤ max_y) || field[diagonal] != field_type
                            if !corner_checker[i] && !corner_checker[mod1(i+1,4)]
                                corners += 1
                            end
                        end
                end
            end
        part_one += area*circumference
        part_two += area*corners
        end
    end
    (part_one, part_two)
end

part_one, part_two = day_twelve(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)