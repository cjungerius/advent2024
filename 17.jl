# Day 17 solution: 1.202 ms (13242 allocations: 801.05 KiB)
input = readlines("input/17_input.txt")

function run_program(A, B, C, program)
    
    pointer::Int = 0
    output = Int[]

    function combo(x)
        x < 4 && return x
        x == 4 && return A
        x == 5 && return B
        x == 6 && return C
        x == 7 && throw("Error: reserved combo operand 7")
    end

    function adv(x)
        A = A ÷ (2^combo(x))
        return pointer + 2
    end

    function bxl(x)
        B = B ⊻ x
        return pointer + 2
    end

    function bst(x)
        B = mod(combo(x),8)
        return pointer + 2
    end

    function jnz(x)
        A != 0 && return x
        return pointer + 2
    end

    function bxc(x)
        B = B ⊻ C
        return pointer + 2
    end

    function out(x)
        push!(output, mod(combo(x),8))
        return pointer + 2
    end

    function bdv(x)
        B = A ÷ (2^combo(x))
        return pointer + 2
    end

    function cdv(x)
        C = A ÷ (2^combo(x))
        return pointer + 2
    end

    func_dict = Dict([0 => adv, 1 => bxl, 2 => bst, 3 => jnz, 4 => bxc, 5 => out, 6 => bdv, 7 => cdv])

    while 0 ≤ pointer < length(program)
        opcode, operand = program[pointer+1:pointer+2]
        pointer = func_dict[opcode](operand)
    end

    return output
end

function day_seventeen(input)
    A::Int = parse(Int,split(input[1]," ")[end])
    B::Int = parse(Int,split(input[2]," ")[end])
    C::Int = parse(Int,split(input[3]," ")[end])
    program = parse.(Int,split(split(input[end]," ")[end],","))
    part_one = run_program(A,B,C,program)

    #inspection reveals that the program has some mapping for each base 8 digit in the input: 
    # working from biggest to smallest we can find the input that reconstructs the program 'key'

    input = repeat(["0"],16)
    for i in eachindex(input)
        target = reverse(program)[i]
        for x in (i == 1 ? (1:7) : (0:7)) # the 8^16 digit has to be > 0 for the program to have an output of the correct length
            input[i] = string(x)
            A = parse(Int,prod(input),base=8)
            output = run_program(A,B,C,program)
            reverse(output)[i] == target && break
        end
    end
    part_two = parse(Int,prod(input),base=8)
    part_one, part_two
end

part_one, part_two = day_seventeen(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)
