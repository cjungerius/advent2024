# Day 6 solution: 2.027 s (15178530 allocations: 2.64 GiB)

input = readlines("input/06_input.txt")

function day_six(input)

    obstacles = Set{Tuple{Int,Int}}()
    directions = Dict(1 => (-1,0), 2 => (0,1), 3 => (1,0), 4 => (0,-1)) # up, right, down, left
    current_direction = 0
    starting_y, starting_x = (0, 0)

    for y in eachindex(input)
        x_coords = findall('#', input[y])
        push!(obstacles,[(y,x) for x in x_coords]...)
        guard_loc = findfirst(r"\^|\|>|\v|\<", input[y])
        if !isnothing(guard_loc)
            starting_y, starting_x = (y, guard_loc[1])
            guard = input[starting_y][starting_x]
            if guard == '^'
                current_direction = 1
            elseif guard == '>'
                current_direction = 2
            elseif guard == 'v'
                current_direction = 3
            elseif guard == '<'
                current_direction = 4
            end
        end
    end

    max_y = length(input)
    max_x = length(input[1])

    function guard_routine(y,x,dir)
        visited = Dict{Tuple{Int,Int},Vector{Bool}}((y,x) => [false, false, false, false])
        visited[(y,x)][dir] = true
    
        while 0 < y < max_y && 0 < x < max_x   
            
            dy, dx = directions[dir]

            if (y + dy, x + dx) in obstacles
                dir = mod1(dir + 1, 4)
            else
                y += dy
                x += dx
                if !haskey(visited, (y,x))
                    visited[(y,x)] = [false, false, false, false]
                    visited[(y,x)][dir] = true
                elseif visited[(y,x)][dir]
                    #println("Loop detected at $y, $x")
                    return nothing
                else
                    visited[(y,x)][dir] = true
                end
            end
        end    
        visited
    end

    original_route = guard_routine(starting_y,starting_x,current_direction)
    part_one = length(keys(original_route))
    part_two = 0

    for key in keys(original_route)
        if !(key[1] == starting_y && key[2] == starting_x)
            # add obstacle in path and check if it's a loop
            push!(obstacles, key)
            part_two += isnothing(guard_routine(starting_y,starting_x,current_direction))
            pop!(obstacles, key)
        end
    end

    (part_one, part_two)
end

part_one, part_two = day_six(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)