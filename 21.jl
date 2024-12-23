# Day 21 solution: 4.739 ms (67484 allocations: 2.64 MiB)

input = readlines("input/21_input.txt")
using Memoization

function day_twentyone(input)
    numpad = Dict([
        '7' => (0,0), '8' => (0,1), '9' => (0,2),
        '4' => (1,0), '5' => (1,1), '6' => (1,2),
        '1' => (2,0), '2' => (2,1), '3' => (2,2),
                      '0' => (3,1), 'A' => (3,2)
    ])

    dirpad = Dict([
                      '^' => (0,1), 'A' => (0,2),
        '<' => (1,0), 'v' => (1,1), '>' => (1,2)

    ])

    function get_paths(a,b,depth=0)
        paths = []
        dy, dx = depth == 0 ? numpad[a] .- numpad[b] : dirpad[a] .- dirpad[b]
        vert = dy < 0 ? 'v'^abs(dy) : '^'^dy
        hori = dx < 0 ? '>'^abs(dx) : '<'^dx
        dy == 0 && return [hori]
        dx == 0 && return [vert]
        if depth == 0
            a == '0' && dx > 0 && return [vert * hori]
            b == '0' && dx < 0 && return [hori * vert]
            a == 'A' && dx > 1 && return [vert * hori] 
            b == 'A' && dx < -1 && return [hori * vert]
        else
            a == '<' && return [hori * vert]
            b == '<' && return [vert * hori]
        end

        return [hori*vert, vert*hori]
    end

    function build_seq(keys, depth, index=1, prevkey='A', currpath="", results = [])

        if index == lastindex(keys)+1
            push!(results, currpath)
            return currpath
        end
        for path in get_paths(prevkey, keys[index], depth)
            build_seq(keys, depth, index+1, keys[index], currpath * path * 'A', results)
        end
        return results
    end

    @memoize function shortest_seq(keys, depth, target_depth)
                if depth == target_depth
                    return length(keys)
                end

                total = 0
                subkeys = split(keys,'A')[1:end-1] .* 'A'
                for subkey in subkeys
                    sequences = build_seq(subkey, depth)
                    costs = [shortest_seq(seq,depth+1, target_depth) for seq in sequences]
                    total += minimum(costs)
                end

                return total
            end

    part_one = 0
    part_two = 0
    
    for line in input
        mult = parse(Int,line[1:end-1])      
        part_one += shortest_seq(line,0,3) * mult
        part_two += shortest_seq(line,0,26) * mult
    end

    part_one, part_two
end

a = day_twentyone(input)