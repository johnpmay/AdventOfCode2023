with(StringTools):
s2i := s->sscanf(s, "%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-06-input.txt" ):

# part 1
races := map(s->Split(Trim(Squeeze(Split(s,":")[2]))),Split(Trim(input), "\n")):
race := zip((x,y)->[s2i(x),s2i(y)], races[1], races[2]):
sols := [solve( d=(t-p)*p, p)]: # formulas for break even points
ways := 1:
for r in race do
    ps := eval(sols, {t=r[1], d=r[2]});
    if is(ps[1] <= ps[2]) then
        ps := [floor(ps[1]+1), ceil(ps[2]-1)];
    else
        ps := [floor(ps[2]+1), ceil(ps[1]-1)];
    end if;
    ways := ways * (ps[2] - ps[1] +1) ;
end do:
ans1 := ways;

# part 2 - do the above once for the big numbers
r := [parse( cat(races[1][])), parse(cat(races[2][]))]:
ps := eval(sols, {t=r[1], d=r[2]}):
if is(ps[1] > ps[2]) then
    ps := [ps[2], ps[1]];
end if:
ps := [floor(ps[1]+1), ceil(ps[2]-1)]:
ans2 := (ps[2] - ps[1] +1) ;