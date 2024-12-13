# Day 13 solution: 753.900 μs (4484 allocations: 465.28 KiB)

input = readlines("input/13_input.txt")

near_integer(x; tol=1e-3) = abs(x - round(x)) <= tol

function day_thirteen(input)
    part_one = 0
    part_two = 0
    A = [0 0; 0 0]
    b = [0, 0]
    solution = [0.0, 0.0]
    loc = 1
    p2_adjust = [10000000000000, 10000000000000]

    for line in input

        if length(line) == 0
            continue
        end

        l = split(line," ")
        if l[1] == "Button"
            l[2] == "A:" ? loc = 1 : loc = 2
            A[1,loc] = parse(Int,l[3][3:end-1])
            A[2,loc] = parse(Int,l[4][3:end])
        elseif l[1] == "Prize:"
            b[1] = parse(Int,l[2][3:end-1])
            b[2] = parse(Int,l[3][3:end])
            solution = (A\b)
            if all(x -> 0 < x ≤ 100, solution) && all(near_integer,solution)
                part_one +=  sum(round.(solution) .* [3, 1])
            end
            b .+= p2_adjust
            solution = (A\b)
            if all(>(0), solution) && all(near_integer,solution)
                part_two +=  sum(round.(solution) .* [3, 1])
            end
        end
    end
    Integer(part_one), Integer(part_two)
end

part_one, part_two = day_thirteen(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)