with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-09-input.txt" ):

reports := map(l->map(s2i,l), map(Split,Split(Trim(input),"\n"))):
predict := proc(r)
local d, i;
   d := seq(r[i+1]-r[i], i=1..nops(r)-1);
   if nops({d}) = 1 then
       return r[-1] + d[1];
   else
       return r[-1] + thisproc([d]);
   end if;
end proc:
ans1 := add( predict( r ), r in reports);
ans2 := add( predict( ListTools:-Reverse(r) ), r in reports);

