# Day 19 solution: 481.241 ms (8815674 allocations: 411.64 MiB)
input = readlines("input/19_input.txt")

function day_nineteen(input)
    towels = split(input[1], ", ")
    part_one = 0
    part_two = 0
    memo = Dict{String,Int}()
    used_towels = String[]

    function check_design(attempt, design)

        return get!(memo, attempt) do

            n = 0
            attempt == design && return 1

            for t in used_towels
                next_attempt = attempt * t
                if length(next_attempt) <= length(design) && next_attempt == design[1:length(next_attempt)]
                    n += check_design(next_attempt, design)
                end
            end

            return n
        end
    end

    for design in input[3:end]
        used_towels = filter(x -> occursin(x, design), towels)
        empty!(memo)
        n = check_design("", design)
        n > 0 && (part_one += 1)
        part_two += n
    end
    part_one, part_two
end

part_one, part_two = day_nineteen(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)
