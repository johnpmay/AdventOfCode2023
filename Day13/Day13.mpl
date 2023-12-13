with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-13-input.txt" ):

grids:=map(g->map(Explode,Split(g)),StringSplit(Trim(Subs(["#"="1","."="0"],input)),"\n\n")):

findReflect := proc(l)
local i, n;
    n := nops(l);
    for i to n-1 do
        if l[i]=l[i+1] then
            #print(n, i, [1..i]=[i+1..2*i], [i+1..n]=[2*i-n..i]);
            if i < nops(l)/2 then
                #print( l[1..i] = ListTools:-Reverse(l[i+1..2*i]) );
                if l[1..i] = ListTools:-Reverse(l[i+1..2*i]) then
                    return i;
                end if;
            else
                #print( l[i+1..n] = ListTools:-Reverse(l[2*i-n+1..i]) );
                if l[i+1..n] = ListTools:-Reverse(l[2*i-n+1..i]) then
                    return i;
                end if;
            end if;
         end if;
     end do;
     return -1;
end proc:
r2d := l->local i; add(s2i(l[i])*2^(nops(l)-i),i=1..nops(l)):

hreflect := proc(g)
local r, c, i;
r := nops(g); c:=nops(g[1]);
findReflect( map(l->add(s2i(l[i])*2^(c-i),i=1..c), g) );
end proc:

vreflect := proc(h)
local r, c, i, g;

g := ListTools:-Transpose(h);
r := nops(g); c:=nops(g[1]);
findReflect( map(r2d, g) );
end proc:

ans1 := 100 * add( select(i->i>0, map(hreflect, grids)) ) + add( select(i->i>0, map(vreflect, grids)) );

findsr := proc(l)
local i, n, delta;
    n := nops(l);
    for i to n-1 do
        #print( log2(abs(l[i]-l[i+1])) );
        if l[i]=l[i+1] or type(log2(abs(l[i]-l[i+1])), integer) then
            #print(n, i, [1..i]=[i+1..2*i], [i+1..n]=[2*i-n..i]);
            if i < nops(l)/2 then
                delta := l[1..i] - ListTools:-Reverse(l[i+1..2*i]);
            else
                delta := l[i+1..n] - ListTools:-Reverse(l[2*i-n+1..i]);
            end if;
            #print(delta, subs(0=NULL, delta), log2(abs(add(delta))));
            if nops(subs(0=NULL, delta)) = 1 and type( log2(abs(add(delta))), integer) then
                return i;
            end if;
         end if;
     end do;
     return -1;
end proc:

hsreflect := proc(g)
local r, c, i;
r := nops(g); c:=nops(g[1]);
findsr( map(l->add(s2i(l[i])*2^(c-i),i=1..c), g) );
end proc:

vsreflect := proc(h)
local r, c, i, g;
g := ListTools:-Transpose(h);
r := nops(g); c:=nops(g[1]);
findsr( map(r2d, g) );
end proc:

ans2 := 100 * add( select(i->i>0, map(hsreflect, grids)) ) + add( select(i->i>0, map(vsreflect, grids)) );



