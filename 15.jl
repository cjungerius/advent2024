# Day 15 solution: 16.379 ms (146321 allocations: 5.05 MiB)

input = readlines("input/15_input.txt")

function day_fifteen(input)

    dirs = Dict(['>' => (1,0), 'v' => (0,1), '<' => (-1,0), '^' => (0,-1)])

    function test_move(x,y,dir)
        next_x, next_y = (x, y) .+ dirs[dir]
        if env[next_y, next_x] == 0
            return true
        elseif env[next_y, next_x] == 1
            return test_move(next_x, next_y, dir)
        else
            return false
        end
    end

    function execute_move(x,y,dir)
        cur = env[y,x]
        next_x, next_y = (x, y) .+ dirs[dir]
        if env[next_y, next_x] == 0
            env[next_y, next_x] = cur
            env[y,x] = 0
        elseif env[next_y, next_x] == 1
            execute_move(next_x, next_y, dir)
            env[next_y, next_x] = cur
            env[y,x] = 0
        end
        return next_x, next_y
    end
    
    function test_move_2(x,y,dir)      
        next_x, next_y = (x, y) .+ dirs[dir]
        next = bigger_env[next_y, next_x]
        if dir == '<' || dir == '>'
            if next == 0
                return true
            elseif 0 < next < 3
                return test_move_2(next_x, next_y, dir)
            else
                return false
            end
        elseif dir == '^' || dir == 'v'
            if next == 0
                return true
            elseif next == 1
                return test_move_2(next_x, next_y, dir) && test_move_2(next_x+1, next_y, dir)
            elseif next == 2
                return test_move_2(next_x, next_y, dir) && test_move_2(next_x-1, next_y, dir)
            else
                return false
            end
        end      
    end

    function execute_move_2(x,y,dir)
        next_x, next_y = (x, y) .+ dirs[dir]
        cur = bigger_env[y, x]
        next = bigger_env[next_y,next_x]

        if dir == '<' || dir == '>'
            if next == 0
                bigger_env[next_y, next_x] = cur
                bigger_env[y, x] = 0
            elseif 0 < next < 3
                execute_move_2(next_x, next_y, dir)
                bigger_env[next_y,next_x] = cur
                bigger_env[y,x] = 0
            end

        elseif dir == '^' || dir == 'v'
            if next == 0
                bigger_env[next_y, next_x] = cur
                bigger_env[y, x] = 0
            elseif next == 1
                execute_move_2(next_x, next_y, dir)
                execute_move_2(next_x+1,next_y,dir)
                bigger_env[next_y,next_x] = cur
                bigger_env[y, x] = 0
            elseif next == 2
                execute_move_2(next_x, next_y, dir)
                execute_move_2(next_x-1,next_y,dir)
                bigger_env[next_y,next_x] = cur
                bigger_env[y, x] = 0
            end
        end      
        return next_x, next_y
    end

    translation = Dict('.' => 0, 'O' => 1, '#' => 2, '@' => 3)
    p2_translation = Dict('.'=>Int8[0,0], 'O' => Int8[1,2], '#'=> Int8[4,4], '@' => Int8[3,0])
    env = [translation[x] for x in input[1]]
    bigger_env = reduce(vcat,[p2_translation[x] for x in input[1]])
    env = reshape(env,1,:)
    bigger_env = reshape(bigger_env,1,:)

    commands = []
    env_end = false
    robot_x, robot_y = (0, 0)
    robot_x_bigger, robot_y_bigger = (0, 0)

    for (y, line) in enumerate(input[2:end])
        if length(line) == 0
            env_end = true
            continue
        end

        if !env_end
            if !isnothing(findfirst('@',line))
                robot_y = y + 1
                robot_y_bigger = robot_y
                robot_x = findfirst('@', line)
                robot_x_bigger = 2*robot_x - 1
                
            end
            env = vcat(env,reshape([translation[x] for x in line],1,:))
            bigger_env = vcat(bigger_env, reshape(reduce(vcat,[p2_translation[x] for x in line]),1,:))
        else
            push!(commands, line)
        end
    end

    n = 0
    for command in commands
        for c in command
            n+= 1
            if test_move(robot_x,robot_y,c)
                robot_x, robot_y = execute_move(robot_x,robot_y,c)
            end
            if test_move_2(robot_x_bigger, robot_y_bigger, c)                
                robot_x_bigger, robot_y_bigger = execute_move_2(robot_x_bigger, robot_y_bigger, c)
            end
        end
    end

    boxes = findall(==(1), env)
    bigboxes = findall(==(1), bigger_env)
    
    part_one = sum([100*(x[1]-1) + x[2]-1 for x in boxes])
    part_two = sum([100*(x[1]-1) + x[2]-1 for x in bigboxes])
    part_one, part_two
end

part_one, part_two = day_fifteen(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)