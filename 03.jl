# Day 3 solution: 257.300 μs (4222 allocations: 244.08 KiB)
input = readlines("input/03_input.txt")


function day_three(input)

    pattern = r"mul\((\d{1,3}),(\d{1,3})\)|do(?:n't)?\(\)"

    part_one = 0
    part_two = 0        
    enabled = true

    for line in input
        commands = eachmatch(pattern, line)

        for c in commands
            if c.match[1] == 'm'
                val = prod(parse.(Int,c.captures))
                part_one += val
                if enabled part_two += val end
            elseif c.match == "do()"
                enabled = true
            elseif c.match == "don't()"
                enabled = false

            end
        end
    end
    (part_one, part_two)
end

part_one, part_two = day_three(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)