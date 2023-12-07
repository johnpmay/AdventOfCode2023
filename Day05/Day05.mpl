with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-05-input.txt" ):
pinput := map(Split, StringSplit(Trim(input), "\n\n"),"\n");
seeds := parse~(Split(pinput[1][1][8..-1]));
maps := subsindets(map2([op], 2..-1, pinput[2..-1]), string, s->parse~(Split(s)));

# part 1
domap := proc(m, num) # apply map #m to number num
local r, newnum := num;
    for r in maps[m] do
        if num >= r[2] and num < r[2]+r[3] then
            newnum := r[1] + num - r[2];
            break;
        end if;
    end do;
    return newnum;
end proc:

doallmap := proc(num) # apply all maps in turn to num
local i, n;
    n := num;
    for i to nops(maps) do
        n := domap(i, n);
    end do;
    return n;
end proc:

ans1 := min( map(doallmap, seeds) );

# past 2
newseeds := [seq(seeds[i]..seeds[i]+seeds[i+1], i=1..nops(seeds), 2)]:

# all the discontinuous points in each map
mapcorners := [seq([seq([r[2],r[2]+r[3]-1][], r in m)], m in maps)]:

dormap := proc(n, nrange) # apply map #n to range nrange
# returning zero or more ranges
local a, b, c, A, B;
    a := lhs(nrange);
    b := rhs(nrange);
    if a > b then
        return NULL;
    end if;
    for c in mapcorners[n] do
        if c >= a and c <= b then # split the range at discontinuities
            return thisproc(n, a..c-1),
                   domap(n,c)..domap(n,c),
                   thisproc(n, c+1..b);
        end if;
    end do;
    A := domap(n,a);
    B := domap(n,b);
    return min(A,B)..max(A,B);
end proc:

numrs := newseeds:
count := add(rhs(r)-lhs(r)+1, r in numrs):
for i to nops(maps) do
    numrs := map2(dormap, i, numrs);
    newcount := add(rhs(r)-lhs(r)+1, r in numrs);
    #debuging: assert count should remain constant
    if newcount <> count then error end if;
end do:
ans2 := min(map(op,numrs));