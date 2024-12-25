# Day 25 solution: 14.169 ms (68013 allocations: 4.17 MiB)

input = readlines("input/25_input.txt")

function day_twentyfive(input)
    i = zeros(Int8,5)
    n = 0
    locks = []
    keys = []

    for line in input
        if isempty(line)
            i .= 0
            n = 0
        else
            n += 1
            if n == 1 
                continue
            elseif n == 7
                line[1] == '#' && push!(keys,copy(i))
                line[1] == '.' && push!(locks,copy(i))
                continue
            else
                i += [x=='#' for x in line]
            end
        end
    end

    part_one = 0
    combo = zeros(Int8,5)
    for lock in locks
        for key in keys
            combo = lock + key
            all(<=(5),combo) && (part_one += 1)
        end
    end

    part_one
end

part_one = day_twentyfive(input)
println("Part one: ",part_one)