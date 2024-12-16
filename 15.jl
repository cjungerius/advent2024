# Day 15 solution

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
        cur = bigger_env[y,x]        
        next_x, next_y = (x, y) .+ dirs[dir]
        next = bigger_env[next_y,next_x]
        self_free = false
        neighbor_free = false
        if cur == 3
            if next == 0
                return true
            elseif 0 < next < 3
                return test_move_2(next_x, next_y, dir)
            else
                return false
            end

        elseif cur == 1
            if dir == '>'
                return test_move_2(next_x, next_y, dir)
            elseif dir == '<'
                if next == 0
                    return true
                elseif next == 2
                    return test_move_2(next_x, next_y, dir)
                else
                    return false
                end
            else
                if next == 0
                    self_free = true
                elseif 0 < next < 3
                    println(bigger_env[next_y,next_x])
                    self_free = test_move_2(next_x, next_y, dir)
                else
                    self_free = false
                end

                if bigger_env[next_y,next_x+1] == 0
                    neighbor_free == true
                elseif 0 < bigger_env[next_y,x+1] < 3
                    neighbor_free = test_move_2(next_x+1,next_y, dir)
                else
                    neighbor_free = false
                end
                println(cur, self_free, " ", neighbor_free)
                return self_free &&  neighbor_free
            end

        elseif cur == 2
            if dir == '<'
                return test_move_2(next_x, next_y, dir)
            elseif dir == '>'
                if next == 0
                    return true
                elseif next == 1
                    return test_move_2(next_x, next_y, dir)
                else
                    return false
                end
            else
                if next == 0
                    self_free = true
                elseif next == 1 || next == 2
                    self_free = test_move_2(next_x, next_y, dir)
                else
                    self_free = false
                end

                if bigger_env[next_y,next_x-1] == 0
                    neighbor_free == true
                elseif 0 < bigger_env[next_y,x-1] < 3
                    neighbor_free = test_move_2(x-1,next_y, dir)
                else
                    neighbor_free = false
                end

                return self_free && neighbor_free
            end
        end
        return false
    end

    function execute_move_2(x,y,dir)
        cur = bigger_env[y,x]
        next_x, next_y = (x, y) .+ dirs[dir]
        next = bigger_env[next_y,next_x]
        if cur == 3
            if next == 0
                bigger_env[next_y, next_x] = cur
                bigger_env[y,x] = 0
            elseif 0 < next < 3
                execute_move_2(next_x, next_y, dir)
                bigger_env[next_y, next_x] = cur
                bigger_env[y,x] = 0
            end

        elseif cur == 1
            if dir == '>'
                execute_move_2(next_x, next_y, dir)
                bigger_env[next_y, next_x] = cur
                bigger_env[y,x] = 0
            elseif dir == '<'
                if next == 0
                    bigger_env[next_y, next_x] = cur
                    bigger_env[y,x] = 0
                elseif next == 2
                    execute_move_2(next_x, next_y, dir)
                    bigger_env[next_y, next_x] = cur
                    bigger_env[y,x] = 0
                end
            else
                if next == 0
                    bigger_env[next_y,next_x] = cur
                    bigger_env[y,x] = 0
                elseif 0 < next < 3
                    execute_move_2(next_x, next_y, dir)
                    bigger_env[next_y, next_x] = cur
                    bigger_env[y,x] = 0
                end

                if bigger_env[next_y,next_x+1] == 0
                    bigger_env[next_y, next_x+1] = bigger_env[y,x+1]
                    bigger_env[y, x+1] = 0
                elseif 0 < bigger_env[next_y,next_x+1] < 3
                    execute_move_2(next_y,next_x+1, dir)
                    bigger_env[next_y,next_x+1] = bigger_env[y,x+1]
                    bigger_env[y,x+1] = 0
                end
            end

        elseif cur == 2
            if dir == '<'
                execute_move_2(next_x, next_y, dir)
                bigger_env[next_y, next_x] = cur
                bigger_env[y,x] = 0
            elseif dir == '>'
                if next == 0
                    bigger_env[next_y, next_x] = cur
                    bigger_env[y,x] = 0
                elseif next == 2
                    execute_move_2(next_x, next_y, dir)
                    bigger_env[next_y, next_x] = cur
                    bigger_env[y,x] = 0
                end
            else
                if bigger_env[next_y,next_x-1] == 0
                    bigger_env[next_y, next_x-1] = bigger_env[y,x-1]
                    bigger_env[y, x-1] = 0
                elseif 0 < bigger_env[next_y,next_x-1] < 3
                    execute_move_2(next_y,next_x-1, dir)
                    bigger_env[next_y,next_x+1] = bigger_env[y,x-1]
                    bigger_env[y,x-1] = 0
                end
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
    for command in [commands[1]]
        for c in command[1:22]
            println(n)
            println(c)
            n+= 1
            if test_move(robot_x,robot_y,c)
                robot_x, robot_y = execute_move(robot_x,robot_y,c)
            end
            if @show test_move_2(robot_x_bigger, robot_y_bigger, c)                
                robot_x_bigger, robot_y_bigger = execute_move_2(robot_x_bigger, robot_y_bigger, c)
            end
            display(colorview(Gray,bigger_env./4))
        end
    end

    boxes = findall(==(1), env)
    
    sum([100*(x[1]-1) + x[2]-1 for x in boxes])
end