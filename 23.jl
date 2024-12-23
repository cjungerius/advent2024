# Day 23 solution: 34.897 ms (754237 allocations: 39.33 MiB)
input = readlines("input/23_input.txt")
example = readlines("input/23_example.txt")
using Combinatorics, Random

function day_twentythree(input)
    
    con_dict = Dict()
    com_set = Set{String}()
    connections = split.(input,"-")
    all_max_cliques = Set()

    function bron_kerbosch(R, P, X)
        isempty(P) && isempty(X) && push!(all_max_cliques,R)
        pivot_n = length(P) > 1 ? con_dict[rand(P)] : Set() # even random pivots make this much faster!
        for v in setdiff(P, pivot_n)
            bron_kerbosch(R ∪ [v], P ∩ con_dict[v], X ∩ con_dict[v])
            P = setdiff(P,Set([v])) 
            X = X ∪ [v]
        end
    end

    for c in connections
        haskey(con_dict,c[1]) ? push!(con_dict[c[1]],c[2]) : con_dict[c[1]] = OrderedSet([c[2]])
        haskey(con_dict,c[2]) ? push!(con_dict[c[2]],c[1]) : con_dict[c[2]] = OrderedSet([c[1]])
        push!(com_set,c[1])
        push!(com_set,c[2])
    end

    triplets = Set()
    for c in com_set
        !startswith(c,"t") && continue
        for net in combinations(con_dict[c],2)
            net[1] in con_dict[net[2]] && push!(triplets, Set([c,net...]))
        end
    end

    part_one = length(triplets)

    bron_kerbosch(Set(),com_set,Set())
    biggest_clique = argmax(length,all_max_cliques)
    p2 = sort!(collect(biggest_clique))
    part_two = reduce((x,y) -> x * "," * y,p2)


    part_one, part_two
end

a, b  = day_twentythree(input)