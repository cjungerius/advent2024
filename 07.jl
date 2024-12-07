using Memoization
input = readlines("input/07_input.txt")

@memoize function is_valid(target, vals)
    if length(vals) == 2
        return target == vals[1] * vals[2] || target == vals[1] + vals[2]
    else
        return is_valid(target,[vals[1]*vals[2],vals[3:end]...]) || is_valid(target,[vals[1]+vals[2],vals[3:end]...])
    end
end

@memoize function is_valid_p2(target, vals)
    if length(vals) == 2
        return target == vals[1] * vals[2] || target == vals[1] + vals[2] || target == vals[1]*10^ceil(log(10,vals[2]+1)) + vals[2]
    else
        return is_valid_p2(target,[vals[1]*vals[2],vals[3:end]...]) || is_valid_p2(target,[vals[1]+vals[2],vals[3:end]...]) || is_valid_p2(target,[vals[1]*10^ceil(log(10,vals[2]+1)) + vals[2],vals[3:end]...])
    end
end

function day_seven(input)
    part_one = 0
    part_two = 0
    for line in input
        target, vals = split(line,": ")
        target = parse(Int, target)
        vals = parse.(Int,split(vals," "))
        if is_valid(target,vals)
            part_one += target
            part_two += target
        elseif is_valid_p2(target,vals)
            part_two += target
        end
    end 
    part_one, part_two
end
