with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-13-input.txt" ):

grids:=map(g->map(Explode,Split(g)),StringSplit(Trim(Subs(["#"="1","."="0"],input)),"\n\n")):

r2d := l->local i; add(s2i(l[i])*2^(nops(l)-i),i=1..nops(l)):

# finds regular or smudged reflections
findReflect := proc(l, {smudge::truefalse:=false})
local i, n, delta;
    n := nops(l);
    for i to n-1 do
        if l[i]=l[i+1] or (smudge and type(log2(abs(l[i]-l[i+1])), integer) ) then
            
            if i < nops(l)/2 then
                delta := l[1..i] - ListTools:-Reverse(l[i+1..2*i]);
            else
                delta := l[i+1..n] - ListTools:-Reverse(l[2*i-n+1..i]);
            end if;
            delta := subs(0=NULL, delta);
            if (not smudge and nops(delta) = 0)
                 or (smudge and nops(delta)=1 and type(log2(abs(delta[1])),integer)) 
            then
                return i;
            end if; 
         end if;
     end do;
     return -1;
end proc:

ans1 := 100 * add( select(i->i>0, map(g->findReflect(r2d~(g)), grids)) )
            + add( select(i->i>0, map(g->findReflect(r2d~(ListTools:-Transpose(g))), grids)) );

ans2 := 100 * add( select(i->i>0, map(g->findReflect(r2d~(g),smudge), grids)) )
            + add( select(i->i>0, map(g->findReflect(r2d~(ListTools:-Transpose(g)),smudge), grids)) );



