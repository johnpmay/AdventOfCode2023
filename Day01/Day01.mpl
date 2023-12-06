with(StringTools):
s2i := s->sscanf(s,"%d")[]: # safe integer parser
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-01-input.txt" ):

# part 1 - remove non-digits then grab first and last 
lines := Split(Trim(input)):
digs := map(l->Select(IsDigit, l), lines):
ans1 := add(map(t->s2i(cat(t[1],t[-1])), digs));

# part 2 - search for first and last digit directly
findfl := proc(s)
local m;
    m := [StringTools:-SearchAll(
        ["1", "2", "3", "4", "5", "6", "7", "8", "9",
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"],
        s)];
    return 10* ifelse(m[1][2]<10, m[1][2], m[1][2]-9)
             + ifelse(m[-1][2]<10, m[-1][2], m[-1][2]-9);
end proc:

digs := map(findfl, lines):
ans2 := add(digs);
