# Day 5 solution: 699.700 μs (5189 allocations: 740.03 KiB)
input = readlines("input/05_input.txt")


function day_five(input)

    rules = Dict{Int,Set{Int}}()
    reports = []
    part_one = 0
    part_two = 0

    for line in input
        if '|' in line
            key, val = parse.(Int,split(line,"|"))
            if haskey(rules, key)
                push!(rules[key],val)
            else
                rules[key] = Set(val)
            end
        elseif ',' in line
            push!(reports, parse.(Int,split(line,",")))
        end
    end

    function custom_lt(x,y)
        haskey(rules,x) && y in rules[x]
    end

    for report in reports
        if issorted(report,lt=custom_lt)
            part_one += report[cld(lastindex(report),2)]
        else
            part_two += sort(report,lt=custom_lt)[cld(lastindex(report),2)]
        end
    end

    part_one, part_two
end

part_one, part_two = day_five(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)