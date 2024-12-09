# Day 8 solution: 1.124 ms (26588 allocations: 988.06 KiB)

input = readlines("input/08_input.txt")

function day_eight(input)
    antennas = Dict{Char,Vector}()

    for y in eachindex(input)
        xs = findall(x->x!=('.'),input[y])
        for x in xs
            if haskey(antennas, input[y][x])
                push!(antennas[input[y][x]], (x,y))
            else
                antennas[input[y][x]] = [(x,y)]
            end
        end
    end

    max_x = length(input[1])
    max_y = length(input)
    part_one = Set{Tuple{Int,Int}}()
    part_two = Set{Tuple{Int,Int}}()

    for a in keys(antennas)
        for pair in combinations(antennas[a],2)
            # get reflections of each pair on its partner
            dx, dy = pair[2] .- pair[1]
            n = 0
            one_out_of_bounds = false
            two_out_of_bounds = false
            while true
                x1, y1 = pair[1] .- (dx, dy).*n
                x2, y2 = pair[2] .+ (dx, dy).*n
                
                if 1 <= x1 <= max_x && 1 <= y1 <= max_y
                    if n==1
                        push!(part_one, (x1,y1))
                    end
                        push!(part_two, (x1,y1))
                else
                    one_out_of_bounds = true
                end
                if 1 <= x2 <= max_x && 1 <= y2 <= max_y
                    if n==1
                        push!(part_one, (x2,y2))
                    end
                        push!(part_two, (x2,y2))
                else
                    two_out_of_bounds = true
                end

                if one_out_of_bounds && two_out_of_bounds
                    break
                end
                n += 1
            end
        end
    end

    length(part_one), length(part_two)
end

part_one, part_two = day_eight(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)