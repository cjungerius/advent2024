# Day 19 solution: 2.635 s (8432918 allocations: 198.37 MiB)
using Memoization

input = readlines("input/19_input.txt")

function day_nineteen(input)
    towels = split(input[1],", ")
    part_one = 0
    part_two = 0

    @memoize function check_design(i, design, n=0)
        i > length(design) && return 0
        i == length(design) && return 1
        for t in towels
            next_i = i + length(t)
            if next_i <= length(design) && t == design[i+1:next_i] 
                n += check_design(next_i, design)
            end
        end
        return n
    end

    for design in input[3:end]
       n = check_design(0,design)
       n > 0 && (part_one += 1)
       part_two += n
    end
    part_one, part_two
end


