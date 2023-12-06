with(StringTools):
s2i := s->sscanf(s,"%d")[]: # safe integer parser
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-01-input.txt" ):

# part 1 - remove non-digits then grab first and last 
lines := Split(Trim(input)):
digs := map(l->Select(IsDigit, l), lines):
ans1 := add(map(t->s2i(cat(t[1],t[-1])), digs));

# part 2 - search for first and last digit directly
ffdig := proc(s) # find first digit - not optimized
local locs, dlocs, w, d1, d2, d1l, d2l;
    w := s;
    locs := [];
    dlocs := subs(0=infinity, map(StringTools:-Search, ["1", "2", "3", "4", "5", "6", "7", "8", "9"], w));
    d1 := min[index](dlocs);
    d1l := min(dlocs);
    locs := subs(0=infinity, map(StringTools:-Search,
        ["one", "two", "three", "four", "five", "six", "seven",
         "eight", "nine"], w));
    if {locs[]} = {infinity} and {dlocs[]} = {infinity} then
        error "no first digit in s";
    end if;
    d2 :=  min[index](locs);
    d2l := min(locs);
    if d1l < d2l then
        return d1;
    else
        return d2;
    end if;
end proc:

fldig :=proc(s) # find last digit - not optimized at all
local locs, dlocs, w, d1, d2, d1l, d2l;
    w := s;
    locs := [];
    dlocs := map(proc(l) local foo := [StringTools:-SearchAll(l,w)]; if nops(foo)=0 then 0 else foo[-1] end if; end proc, ["1", "2", "3", "4", "5", "6", "7", "8", "9"]);

    d1 := max[index](dlocs);
    d1l := max(dlocs);

    locs := map(proc(l) local foo := [StringTools:-SearchAll(l,w)]; if nops(foo)=0 then 0 else foo[-1] end if; end proc, ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]);

    if {locs[]} = {0} and {dlocs[]} = {0} then
        error "no last digit in s";
    end if;
    d2 := max[index](locs);
    d2l := max(locs);
    if d1l > d2l then
        return d1;
    else
        return d2;
    end if;
end proc:

digs := map(l->10*l[1]+l[2], map([ffdig,fldig], lines)):
ans2 := add(digs);