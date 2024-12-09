# Day 9 solution: 371.039 ms (20027 allocations: 4.98 MiB)

input = readline("input/09_input.txt")

function day_nine(input)
    new_disk = Int[]
    old_disk = parse.(Int,split(input,""))
    id = 0

    for i in eachindex(old_disk)
        if !iseven(i)
            for j in 1:old_disk[i]
                push!(new_disk,id)
            end
            id += 1
        else
            for j in 1:old_disk[i]
                push!(new_disk, -1)
            end
        end
    end

    empty_space = Int8.(new_disk .== -1)
    new_disk_nonfrag = deepcopy(new_disk)

    next_empty = 1
    next_file = length(new_disk)

    while true
        next_empty = findnext(==(-1), new_disk,next_empty)
        next_file = findprev(!=(-1), new_disk,next_file)
        next_file < next_empty && break
        new_disk[next_empty] = new_disk[next_file]
        new_disk[next_file] = -1
    end

    for id in new_disk_nonfrag[end]:-1:1
        filesize = old_disk[id*2+1]
        fileloc = findfirst(==(id),new_disk_nonfrag)
        new_place = findfirst(repeat(Int8[1],filesize),empty_space)
        isnothing(new_place) && continue
        new_place[1] > fileloc && continue
        new_disk_nonfrag[new_place] .= id
        empty_space[new_place] .= 0
        new_disk_nonfrag[fileloc:fileloc+filesize-1] .= -1
    end

    part_one = 0
    part_two = 0

    for i in eachindex(new_disk)
        new_disk[i] == -1 && break
        new_disk[i] != -1 && (part_one += (i-1) * new_disk[i])
        new_disk_nonfrag[i] != -1 && (part_two += (i-1) * new_disk_nonfrag[i])
    end

    part_one, part_two
end

part_one, part_two = day_nine(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)