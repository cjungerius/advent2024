# Day 6 solution: 128.135 ms (56493 allocations: 48.12 MiB)

input = readlines("input/06_input.txt")

function day_six(input)

    max_y = length(input)
    max_x = length(input[1])
    obstacles = falses(max_y, max_x)
    directions = Dict(1 => (-1,0), 2 => (0,1), 3 => (1,0), 4 => (0,-1)) # up, right, down, left
    starting_direction = 0
    starting_y, starting_x = (0, 0)

    for y in eachindex(input)
        x_coords = findall('#', input[y])
        if !isempty(x_coords)
            for x in x_coords
                obstacles[y,x] = true
            end
        end
        guard_loc = findfirst(r"\^|\|>|\v|\<", input[y])
        if !isnothing(guard_loc)
            starting_y, starting_x = (y, guard_loc[1])
            guard = input[starting_y][starting_x]
            if guard == '^'
                starting_direction = 1
            elseif guard == '>'
                starting_direction = 2
            elseif guard == 'v'
                starting_direction = 3
            elseif guard == '<'
                starting_direction = 4
            end
        end
    end



    function guard_routine(y,x,dir)
        env = falses(max_y, max_x)
        env[y,x] = true
        collisions = Set{Tuple{Int,Int,Int}}()
        dy, dx = directions[dir]

    
        while 0 < y + dy <= max_y && 0 < x + dx <= max_x

            #collision check: is there a wall in front of us?
            if obstacles[y + dy, x + dx]
                #if we've already been here, we're looping
                if (y, x, dir) in collisions
                    return nothing
                else
                #otherwise, we've hit a wall, so we turn right. remember the collision, and keep going
                push!(collisions, (y, x, dir))
                dir = mod1(dir + 1, 4)
                dy, dx = directions[dir]
                end
            #if there's no wall, we move forward 
            else
            env[y + dy,x + dx] = true                
            y += dy
            x += dx
            end
        end    
        env
    end

    part_one = guard_routine(starting_y, starting_x, starting_direction)
    part_two = 0
    for i in 1:max_y, j in 1:max_x
        if i == starting_y && j == starting_x
            continue
        end
        if part_one[i, j] && !obstacles[i, j]
            obstacles[i, j] = true
            part_two += isnothing(guard_routine(starting_y, starting_x, starting_direction))
            obstacles[i, j] = false
        end
    end

    sum(part_one), part_two
end

part_one, part_two = day_six(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)