with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-05-input.txt" ):
pinput := map(Split, StringSplit(Trim(input), "\n\n"),"\n"):
seeds := parse~(Split(pinput[1][1][8..-1])):
maps := subsindets(map2([op], 2..-1, pinput[2..-1]), string, s->parse~(Split(s))):

# part 1
# turn maps into peicewise linear operators
F:= map(unapply, [seq(piecewise(seq([And( x>=r[2], x<r[2]+r[3]),r[1]+x-r[2]][], r in m), x), m in maps)], x):

# apply the composition of the operators to each seed
ans1 := min( map(`@`(seq(F[i],i=7..1,-1)), seeds) );

# part 2
newseeds := [seq(seeds[i]..seeds[i]+seeds[i+1], i=1..nops(seeds), 2)]:
g := convert( F[2](F[1](x)), piecewise, x):
for i from 3 to 7 do
    g := convert( F[i](g), piecewise, x);
end do:
ans2 := min(seq(minimize(g, x=r), r in newseeds));