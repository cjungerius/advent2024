# Day 11 solution

using Memoization

input = readline("input/11_input.txt")

@memoize function stone_splitter(stone, blinks)

    if blinks == 0
        return 1
    end

    if stone == 0
        return stone_splitter(1, blinks - 1)
    end

    d = ndigits(stone)

    if mod(d,2) == 0
        a = fld(stone, 10^(d÷2))
        b = stone % 10^(d ÷ 2)
        return stone_splitter(a, blinks - 1) + stone_splitter(b, blinks - 1)
    end

    return stone_splitter(stone*2024, blinks - 1)
end

function day_eleven(input)
    part_one = 0
    part_two = 0

    stones = parse.(Int, split(input," "))

    for stone in stones
        part_one += stone_splitter(stone,25)
        part_two += stone_splitter(stone,75)
    end 
    part_one, part_two
end