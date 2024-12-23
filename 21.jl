# Day 21 solution

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

    new_codes = []

    function build_seq(keys, depth, index=1, prevkey='A', currpath="")
        if index == lastindex(keys)+1
            push!(new_codes,currpath)
            return currpath
        end
        for path in get_paths(prevkey, keys[index], depth)
            build_seq(keys, depth, index+1, keys[index], currpath * path * 'A')
        end
    end

    part_one = 0
    
    for line in input
        codes = [line]
        mult = parse(Int,codes[1][1:end-1])
        for i in 0:2
            new_codes = []
            for code in codes
            build_seq(code,i)
            codes = new_codes
            end
        end
        part_one += minimum(length,codes) * mult
    end

    part_one
end

a = day_twentyone(input)