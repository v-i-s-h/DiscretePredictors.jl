
import Base: <, <=, ==, length, isempty, 
             show, dump, empty!, getindex, setindex!, get, get!,
             in, haskey, keys, merge, copy, cat,
             push!, pop!, insert!,
             union!, delete!, similar, sizehint!,
             isequal, hash,
             map, reverse,
             first, last, eltype, getkey, values, sum,
             merge, merge!, lt, Ordering, ForwardOrdering, Forward,
             ReverseOrdering, Reverse, Lt,
             isless,
             union, intersect, symdiff, setdiff, issubset,
             searchsortedfirst, searchsortedlast, in


mutable struct Trie{T1,T2}
    value::T2
    children::Dict{T1,Trie{T1,T2}}
    is_key::Bool

    function Trie{T1,T2}() where {T1,T2}
        self            = new{T1,T2}()
        self.value      = 0;
        self.children   = Dict{T1,Trie{T1,T2}}()
        self.is_key     = false
        self
    end

    function Trie{T1,T2}(ks, vs) where {T1,T2}
        t = Trie{T1,T2}()
        for (k, v) in zip(ks, vs)
            t[k] = v
        end
        return t
    end

    function Trie{T1,T2}(kv) where {T1,T2}
        t = Trie{T1,T2}()
        for (k,v) in kv
            t[k] = v
        end
        return t
    end
end

Trie() = Trie{Any,Any}()
# Trie{K<:AbstractString,V}(ks::AbstractVector{K}, vs::AbstractVector{V}) = Trie{V}(ks, vs)
# Trie{K<:AbstractString,V}(kv::AbstractVector{Tuple{K,V}}) = Trie{V}(kv)
# Trie{K<:AbstractString,V}(kv::Associative{K,V}) = Trie{V}(kv)
# Trie{K<:AbstractString}(ks::AbstractVector{K}) = Trie{Void}(ks, similar(ks, Void))

function setindex!(t::Trie{T1,T2}, val::T2, key::Vector{T1}) where {T1,T2}
    node = t
    for element in key
        if !haskey(node.children, element)
            node.children[element] = Trie{T1,T2}()
        end
        node = node.children[element]
    end
    node.is_key = true
    node.value = val
end

function getindex(t::Trie{T1,T2}, key::Vector{T1}) where {T1,T2}
    if isempty(key)
        return t.value
    end
    node = subtrie(t, key)
    if node != nothing && node.is_key
        return node.value
    end
    throw(KeyError("key not found: $key"))
end

function subtrie(t::Trie{T1,T2}, prefix::Vector{T1}) where {T1,T2}
    node = t
    for element in prefix
        if !haskey(node.children, element)
            return nothing
        else
            node = node.children[element]
        end
    end
    node
end

function haskey(t::Trie{T1,T2}, key::Vector{T1}) where {T1,T2}
    node = subtrie(t, key)
    node != nothing && node.is_key
end

function get(t::Trie{T1,T2}, key::Vector{T1}, notfound) where {T1,T2}
    if isempty(key)
        return t.value
    end
    node = subtrie(t, key)
    if node != nothing && node.is_key
        return node.value
    end
    notfound
end

function keys(t::Trie{T1,T2}, prefix::Vector{T1}=Array{T1,1}(), found=Array{Array{T1,1},1}()) where {T1,T2}
    # println( "Processing: ", t );
    if t.is_key
        push!(found, prefix)
    end
    for (element,child) in t.children
        keys(child, [prefix;element], found)
    end
    found
end

function keys_with_prefix(t::Trie{T1,T2}, prefix::Vector{T1}) where {T1,T2}
    st = subtrie(t, prefix)
    st != nothing ? keys(st,prefix) : []
end

function children(t::Trie{T1,T2}, prefix::Vector{T1} ) where {T1,T2}
    st  = subtrie( t, prefix )
    st != nothing ? st.children : Dict{T1,Trie{T1,T2}}();
end

# Display functions
function show( io::IO, t::Trie{T1,T2} ) where {T1,T2}
    model_str = "[*]" * node_string( t, 1 );
    print( io, model_str );
end

function node_string( t::Trie{T1,T2}, level::Int = 0 ) where {T1,T2}
    str     = " " * "(" * string(t.value) * ")" * "\n";
    for child in keys(t.children)
        for i = 1:level-1
            str = str * "     ";
        end
        str = str * "+---[" * string( child ) * "]";
        str = str * @sprintf( "%s", node_string(t.children[child],level+1) );
    end
    return str
end

# # The state of a TrieIterator is a pair (t::Trie, i::Int),
# # where t is the Trie which was the output of the previous iteration
# # and i is the index of the current character of the string.
# # The indexing is potentially confusing;
# # see the comments and implementation below for details.
# immutable TrieIterator{T1,T2}
#     t::Trie{T1,T2}
#     str::AbstractString
# end
#
# # At the start, there is no previous iteration,
# # so the first element of the state is undefined.
# # We use a "dummy value" of it.t to keep the type of the state stable.
# # The second element is 0
# # since the root of the trie corresponds to a length 0 prefix of str.
# start(it::TrieIterator) = (it.t, 0)
#
# function next(it::TrieIterator, state)
#     t, i = state
#     i == 0 && return it.t, (it.t, 1)
#
#     t = t.children[it.str[i]]
#     return (t, (t, i + 1))
# end
#
# function done(it::TrieIterator, state)
#     t, i = state
#     i == 0 && return false
#     i == length(it.str) + 1 && return true
#     return !(it.str[i] in keys(t.children))
# end
#
# path(t::Trie, str::AbstractString) = TrieIterator(t, str)
# if VERSION >= v"0.5.0-dev+3294"
#     Base.iteratorsize(::Type{TrieIterator}) = Base.SizeUnknown()
# end
