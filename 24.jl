# Day 24 solution

using Graphs

input = readlines("input/24_input.txt")
example = readlines("input/24_example.txt")

function day_twentyfour(input)

    wiring = MetaGraph()

    wire_start = findfirst(x->x=="",input)
    wires = Dict{String,Int}()
    ops = Dict{String,Function}(
        "XOR" => ⊻,
        "AND" => &,
        "OR" => |
    )

    for i in 1:wire_start-1
        wire, val = split(input[i],": ")
        wires[wire] = parse(Int,val)
    end

    diagram = split.(input," ")

    while length(keys(wires)) < length(input)-1
        for i in wire_start+1:lastindex(input)
            input_1, op, input_2, _, output = diagram[i]
            if haskey(wires,input_1) && haskey(wires,input_2)
                wires[output] = ops[op](wires[input_1],wires[input_2])
            end
        end
    end

    result = String[]

    for k in keys(wires)
        startswith(k,"z") && push!(result,k)
    end

    part_one = 0

    for (i,z) in enumerate(sort!(result))
        part_one += wires[z]*2^(i-1)
    end

    # did pen and paper analysis for part two:
    # part_two = "cgq,fnr,kqk,nbc,svm,z15,z23,z39"

    part_one
end

part_one = day_twentyfour(input)