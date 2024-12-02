# Day 2 solution: 1.148 ms (24426 allocations: 1.96 MiB)
input = readlines("input/02_input.txt")

function day_two(input)
reports = [parse.(Int,report) for report in split.(input," ")]

counts = [0,0]

for r in reports
    counts .+= report_checker(r)
end

counts
end

function report_checker(report, subset=false)
    partone, parttwo = (false, false)
    diffs = diff(report)
    partone = (allequal(sign.(diffs)) && all(abs.(diffs) .< 4))
    
    if !partone && !subset
       for i in eachindex(report)
           parttwo, _ = report_checker(report[1:end .!=i], true)
           parttwo && break
       end
    else
        parttwo = true
    end

    return partone, parttwo
end

part_one, part_two = day_two(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)