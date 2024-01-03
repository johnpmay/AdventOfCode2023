with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-22-input.txt" ):

bricks := sort( subsindets( map(s->map(Split,s,","), map(Split,Split( Trim(input), "\n"),"~")), string, s2i), key=(b->min(b[1][3],b[2][3]))): nops(bricks);

fixbricks := map(b->[[b[1][1]-0.9, b[1][2]-0.9, b[1][3]-0.9], b[2]], bricks):

init := proc()
global volume, bricks;
local i;

    volume := Array( seq(ifelse(i=3,0,min(map2(op,[1,i],bricks)))..max(map2(op,[2,i],bricks)), i=1..3), 0, datatype=integer):
    volume[..,..,0] := 1: # z=0 is floor
    volume[..,..,0];
    return;
end proc:


markbrick := proc(b, n)
global volume;
local x,y,z;
    for z from b[1][3] to b[2][3] do
        for x from b[1][1] to b[2][1] do
            for y from b[1][2] to b[2][2] do
                volume[x,y,z] := n;
            end do;
        end do;
     end do;
     return;
end proc:

drop := proc(b)
global volume;
local l, x, y, loss, sup;
    loss := 0; sup := {0};
    for l from b[1][3]-1 to 1 by -1 do # check each level 
        sup := {seq(seq(volume[x,y,l], y=b[1][2]..b[2][2]), x=b[1][1]..b[2][1]) };
        if sup <> {0} then # done falling
            sup := sup minus {0};
            break;
        end if;
        loss++;
    end do;
    return [b[1] - [0,0,loss], b[2]-[0,0,loss]], sup;
end proc:

init();
# bricks sorted by z lowerbd
fallen := Array(1..nops(bricks)):
support := Array(1..nops(bricks)):
for i to nops(bricks) do
    (fallen(i), tmp) := drop(bricks[i]);
    support[i] := tmp;
    markbrick(fallen(i),i);
end do:
fallen := convert(fallen,list):
support := convert(support, list):

(crit,free) := selectremove(i->member({i},support), [seq(1..nops(bricks))]):

ans1 := nops(free);

# part 2

directs := [seq(select(j->member(i,support[j]),{seq(1..nops(bricks))}),i=1..nops(bricks))]: # directly above

chain := proc(n)
local i, j, new:={n}, out := {n};
    do
       # thing directly above out which are only supported  by things in out
       new := `union`( seq( select(i->support[i] subset out, directs[j]), j in new) );
       out := `union`(out,new);
    until new = {};
    return out minus {n};
end proc:

ans2 := add( seq( nops( chain(i) ), i in crit));

# Alternately, Do it with Graph Theory directly
E :=`union`( seq(map(i->[i,j], support[j]),j=1..nops(bricks))):
G :=GraphTheory:-Graph([seq(0..nops(bricks))], E  );

chain2 := proc(n)
    local H := GraphTheory:-DeleteVertex(G, n, inplace=false);
    return { GraphTheory:-Vertices(H)[] }  minus { GraphTheory:-Reachable(H,0)[] };
end proc:

ans2 := add( seq( nops( chain2(i) ), i in crit));

