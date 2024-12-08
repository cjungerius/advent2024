# Day 7 solution: 84.221 ms (9943 allocations: 1.13 MiB)

input = readlines("input/07_input.txt")

function is_valid(target, total, vals)
    
    if total > target
        return false
    end

    if length(vals) == 1
        return target == total * vals[1] || target == total + vals[1]
    else
        return is_valid(target, total+vals[1], @view vals[2:end]) || is_valid(target, total * vals[1], @view vals[2:end])
    end
end

function is_valid_p2(target, total, vals)
    
    if total > target
        return false
    end

    if length(vals) == 1
        return target == total * vals[1] || target == total + vals[1] || target == total*10^ceil(log(10,vals[1]+1)) + vals[1]
    else
        return is_valid_p2(target, total * vals[1], @view vals[2:end]) || is_valid_p2(target, total + vals[1], @view vals[2:end]) || is_valid_p2(target, total*10^ceil(log(10,vals[1]+1)) + vals[1], @view vals[2:end])
    end
end

function day_seven(input)
    part_one = 0
    part_two = 0
    for line in input
        target, vals = split(line,": ")
        target = parse(Int, target)
        vals = parse.(Int,split(vals," "))
        if is_valid(target, vals[1], @view vals[2:end])
            part_one += target
            part_two += target
        elseif is_valid_p2(target, vals[1], @view vals[2:end])
            part_two += target
        end
    end 
    part_one, part_two
end

part_one, part_two = day_seven(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)