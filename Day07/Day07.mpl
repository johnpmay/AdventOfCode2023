with(StringTools): s2i:=s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-07-input.txt" ):

pinput := map(Split,Split(Trim(input),"\n")):
hands := map(l->[Explode(l[1]),s2i(l[2])],pinput):
hands := subsindets(subs("A"="14","K"="13","Q"="12","J"="11","T"="10", hands), string, s2i):

# part 1
classhand := proc(g)
local cc, c, h;
   h  := g[1];
   c := ListTools:-Collect(h);
   cc := sort( map2(op,2,c) );
   if nops(cc) = 5 then return 1; end if; # high card
   if nops(cc) = 4 then return 2; end if; # 1 pair
   if cc = [1,2,2] then return 3; end if; # 2 pair
   if cc = [1,1,3] then return 4; end if; # 3 kind
   if cc = [2,3] then return 5; end if; # full house
   if cc = [1,4] then return 6; end if; # 4 kind
   if cc = [5] then return 7; end if; # 5 kind
   error "unhandled hand type", h, cc;  
end proc:
hand2int := proc(g) 
local i, h := g[1];
   16^5*classhand(g) + add(16^(5-i)*h[i],i=1..5);
end proc:
map(hand2int, hands):
n := nops(hands);
ranked := sort(hands, key=hand2int):
ans1 := add(i*ranked[i][2], i=1..n);

#part 2
classhandJ := proc(g)
local j,cc,h := g[1];
local c := ListTools:-Collect(h);
   (j,c) := selectremove(l->l[1]=11, c);
   cc := sort( map2(op,2,c) );
   if j = [] then j := 0; else j := j[1][2]; end if;
   if nops(c) = 5 then return 1; end if; # high card - no j
   if nops(c) = 4 then return 2; end if; # 1 pair with j or no
   if cc = [1,2,2] then return 3; end if; # 2 pair no j
   if cc = [1,1,1] then return 4; end if; # nothing + 2*j = 3 kind
   if cc = [1,1,2] then return 4; end if; # pair + j = 3 kind
   if cc = [1,1,3] then return 4; end if; # 3 kind
   if cc = [2,2] then return 5; end if; # 2 pair + j = FH
   if cc = [2,3] then return 5; end if; # full house
   if cc = [1,2] then return 6; end if; # 2 pair + 2*j = 4 kind
   if cc = [1,3] then return 6; end if; # 3 kind + j = 4 kind
   if cc = [1,1] then return 6; end if; # 3*j = 4 kind
   if cc = [1,4] then return 6; end if; # 4 kind
   if nops(cc) <= 1 then return 7; end if; # 5 kind
   error "unhandled hand type", h, cc;  
end proc:
hand2intJ := proc(g) local i, h;
   h := subs(11=1,g[1]);
   16^5*classhandJ(g) + add(16^(5-i)*h[i],i=1..5);
end proc:
map(hand2intJ, hands):
rankedJ := sort(hands, key=hand2intJ):
ans2 := add(i*rankedJ[i][2], i=1..n);


