# Day 14 solution: 2.317 ms (15787 allocations: 1.21 MiB)
using Images, ImageInTerminal

input = readlines("input/14_input.txt")



function day_fourteen(input)
    robots = Set()
    quadrants = [0, 0, 0, 0]
    quadrant = 1
    for line in input
        quadrant = 1
        p,v = split(line," ")
        px, py = parse.(Int, split(p[3:end],","))
        vx, vy = parse.(Int, split(v[3:end],","))
        new_x = mod(px + vx * 100, 101)
        new_y = mod(py + vy * 100, 103)

        push!(robots,(new_x,new_y))
        
        if new_x == 50 || new_y == 51
            continue
        end
        if new_x > 50
            quadrant += 1
        end
        if new_y > 51
            quadrant += 2
        end

        quadrants[quadrant] += 1
    end

    prod(quadrants)
end

function day_fourteen_two(input)
    robots = Set()
    quadrant = 1
    for line in input
        quadrant = 1
        p,v = split(line," ")
        px, py = parse.(Int, split(p[3:end],","))
        vx, vy = parse.(Int, split(v[3:end],","))
        push!(robots, (px,py,vx,vy))
    end

    field = falses(103,101)

    prompt = ""

    #manually detected cycle starts where many points are close together:
    #x_cycle_offset = 33
    #y_cycle_offset = 84

    #find first point where cycles sync:
    n=0
    while true
        n+=1
        (n-33) % 103 == 0 && (n-84) % 101 == 0 && break
    end

    for robot in robots
        new_x = mod(robot[1] + robot[3] * n, 101)
        new_y = mod(robot[2] + robot[4] * n, 103)
        field[new_y+1,new_x+1] = true
    end

    display(colorview(Gray, field))
        
    n
    end

part_one, part_two = day_fourteen(input), day_fourteen_two(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)