with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-21-input.txt" ):

grid := Array(map(Explode,Split(Trim(input),"\n"))):
member("S", grid, 'start'): start:=[start];
grid := subs("S"=0,"#"=1,"."=0, grid);
(r,c) := map(rhs, [rtable_dims(grid)])[];

goal := 64;

neibs := proc(pos)
return select(p->min(p)>0 and p[1]<=r and p[1]<=c and grid[p[]]=0, map( `+`, [[0,1],[1,0],[0,-1],[-1, 0]], pos) )[];
end proc:
frontier := {start};
to goal do
     frontier := { seq(neibs(p), p in frontier) };
end do:
ans1 := nops(frontier);

infgrid:= proc(pos)
     local x := 1+((pos[1]-1) mod r), y:=1+((pos[2]-1) mod c);
     return grid[x,y];
end proc:

infneibs := proc(pos)
    return select(p->infgrid(p)=0, map( `+`, [[0,1],[1,0],[0,-1],[-1, 0]], pos) )[];
end proc:

goal2 := 26501365;
therem := irem(goal2, 131); # extra iterations past periodic
themod := iquo(goal2, 131); # number of periods

frontier := {}:
core := {start};
coredim := [1,r]:
for i to 0*131+therem do
     frontier := { seq(infneibs(p), p in frontier), seq(infneibs(p), p in core) };
     (core,frontier) := selectremove(p->p[1]>=coredim[1] and p[1]<=coredim[2] and p[2]>=coredim[1] and p[2]<=coredim[2], frontier);
     count := nops(frontier) + nops(core);

end do:
fcount[0] := count;

frontier := {}:
core := {start};
coredim := [1,r]:
for i to 1*131+therem do
     frontier := { seq(infneibs(p), p in frontier), seq(infneibs(p), p in core) };
     (core,frontier) := selectremove(p->p[1]>=coredim[1] and p[1]<=coredim[2] and p[2]>=coredim[1] and p[2]<=coredim[2], frontier);
     count := nops(frontier) + nops(core);

end do:
fcount[1] := count;


# This is also way too slow. We need more MATH
runCA := proc(iters)
global start, r;
local i, p;

    local count := 0;
    local frontier := {}:
    local core := {start};
    local pcoredim := [1,0]:
    local coredim := [1,r]:
    local corecount := 1:
    local ooocount := 0:
    local oocount := 0:
    local ocount := 0:
    local opcorecount := 0:
    local epcorecount := 0:
    local plimit := r;

    for i to iters do
        frontier := { seq(infneibs(p), p in frontier), seq(infneibs(p), p in core) };
        (core,frontier) := selectremove(p->p[1]>=coredim[1] and p[1]<=coredim[2] and p[2]>=coredim[1] and p[2]<=coredim[2], frontier);

        # remove periodic parts from the new core
        core := remove(p->p[1]>=pcoredim[1] and p[1]<=pcoredim[2] and p[2]>=pcoredim[1] and p[2]<=pcoredim[2], core);

        ooocount := oocount;
        oocount := ocount;
        ocount := corecount;
        if (i mod 2) = 0 then
            corecount := nops(core)+epcorecount;
        else
            corecount := nops(core)+opcorecount;
        end if;

        if  i > plimit
            and corecount = oocount
            and ocount = ooocount
        then # core now periodic!
        # increase coredims
            plimit := i+r;
            pcoredim := coredim;
            coredim := coredim + [-r,r];
            if (i mod 2) = 0 then
                epcorecount := corecount;
                opcorecount := ocount;
            else
                opcorecount := corecount;
                epcorecount := ocount;
            end if;
        end if;

        count := nops(frontier) + corecount;
    end do:

    return count;

end proc:

fcount[2] := runCA(2*131+therem);
fcount[3] := runCA(3*131+therem);


p := CurveFitting:-PolynomialInterpolation([[0,fcount[0]], [1,fcount[1]], [2,fcount[2]], [3,fcount[3]]], x);

ans2 := eval(p,x=themod);

