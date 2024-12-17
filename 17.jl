# Day 17 solution: 1.261 ms (12248 allocations: 770.23 KiB)
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

    candidate = digits(8^15,base=8)
    current_digit = lastindex(candidate)

    while true
        A = sum(candidate[k]*8^(k-1) for k in eachindex(candidate))
        attempt = run_program(A, B, C, program)
        attempt == program && break

        if attempt[current_digit:end] == program[current_digit:end]
            current_digit -= 1   
        else
            if candidate[current_digit] < 7
                candidate[current_digit] += 1
            else
                candidate[current_digit] = 0
                current_digit += 1
                candidate[current_digit] += 1
            end            
        end
    end

    part_two = sum(candidate[k]*8^(k-1) for k in eachindex(candidate))
    part_one, part_two
end

part_one, part_two = day_seventeen(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)
