# Day 22 solution: 1.278 s (4501131 allocations: 249.92 MiB)

input = readlines("input/22_input.txt")

function hash(n)
    prices = zeros(Int8,2001)
    prices[1] = n % 10
    for i in 1:2000
        n = (n ⊻ (n << 6)) & 0xFFFFFF
        n = (n ⊻ (n >> 5)) & 0xFFFFFF 
        n = (n ⊻ (n << 11)) & 0xFFFFFF 
        prices[i+1] = n % 10
    end
    n, prices
end

function day_twentytwo(input)
    nums = parse.(Int,input)
    results = hash.(nums)
    part_one = sum([x for (x,y) in results])
    prices = [y for (x,y) in results]

    price_dict = Dict()
    seen = Set()
    for p in prices
        d = diff(p)
        for i in 5:2001
            k = d[i-4:i-1]
            k in seen && continue
            get!(price_dict,k,0)
            price_dict[k] += p[i]
            push!(seen,k)
        end
        empty!(seen)
    end

    part_two = maximum(values(price_dict))

    part_one, part_two
end

part_one, part_two = day_twentytwo(input)
println("Part One: ", part_one)
println("Part Two: ", part_two)
