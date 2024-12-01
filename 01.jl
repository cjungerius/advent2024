# Day 1 solution: 258.100 μs (2019 allocations: 356.80 KiB)
input = readlines("input/01_input.txt")

function day_one(input)
    input = split.(input, "   ")
    list_a = [parse(Int, x[1]) for x in input]
    list_b = [parse(Int, x[2]) for x in input]

    # Part 1
    part_one = sum(abs.(sort(list_a) - sort(list_b)))

    # Part 2

    part_two = 0
 
    set_a = Set(list_a)
    for n in list_b
        if n in set_a
            part_two += n
        end
    end

    part_one, part_two
end

part_one, part_two = day_one(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)