# Day 4 solution: 4.845 ms (44312 allocations: 5.34 MiB)
input = readlines("input/04_input.txt")

function day_four_one(input)
    part_one = 0

    # find horizontal matches
    for line in input
        part_one += count(r"XMAS|SAMX",line,overlap=true)
    end

    # find vertical matches
    for i in 1:length(input[1])
        part_one += count(r"XMAS|SAMX",join([input[j][i] for j in eachindex(input)]), overlap=true)
    end

    input_mat = vcat(reshape.(split.(input,""),1,length(input[1]))...)
    input_mat_rot = rotr90(input_mat)

    # find diagonal matches
    for i in -length(input[1])+1:length(input[1])-1
        part_one += count(r"XMAS|SAMX",join(diag(input_mat,i)), overlap=true)
        part_one += count(r"XMAS|SAMX",join(diag(input_mat_rot,i)), overlap=true)
    end

    part_one    
end

function day_four_two(input)
    part_two = 0
    input_mat = vcat(reshape.(split.(input,""),1,length(input[1]))...)
    
    for i in 2:lastindex(input_mat,1)-1, j in 2:lastindex(input_mat,2)-1
        if input_mat[i,j] == "A"
            if (input_mat[i-1,j-1] == "M" && input_mat[i+1,j+1] == "S" || input_mat[i-1,j-1] == "S" && input_mat[i+1,j+1] == "M") && (input_mat[i-1,j+1] == "M" && input_mat[i+1,j-1] == "S" || input_mat[i-1,j+1] == "S" && input_mat[i+1,j-1] == "M")
                part_two += 1
            end
        end
    end

    part_two
end

part_one, part_two = (day_four_one(input), day_four_two(input))
println("Part One: ", part_one)
println("Part Two: ", part_two)