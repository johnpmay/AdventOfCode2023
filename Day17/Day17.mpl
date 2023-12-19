with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-17-input.txt" ):

grid := subsindets(map(Explode,Split(Trim(input),"\n")),string,s2i):
dimx := nops(grid);
dimy := nops(grid[1]);

start := [1,1];
finish := [dimx,dimy];
scmin := 1;
scmax := 3;

neibs := proc(pos, dir:=[0,0], sc:=0)
local o, out := [ [1,0], [0,1], [-1,0], [0,-1] ];
    out := subs(-dir=NULL, out);
    if sc>=scmax then
        out := subs(dir=NULL, out);
    elif sc>0 and sc < scmin then
        out := [dir];
    end if;
    out := [ seq(pos+o, o in out) ];
    out := remove(p->min(p)<1 or p[1]>dimx or p[2]>dimy, out); # remove off grid
    return out;
end proc:

Dijkstra := proc(theend) #option trace;
local pq, costsofar, curr, nb, newcost, pt, tmp, dir, sc, ndir, nsc, i, edc:=0, path; 
global grid;
uses priqueue;

    costsofar := table(sparse=infinity):
    path := table();

    initialize(pq):
    insert([0,start,[0,0],0], pq):
    costsofar[start,[0,0],0] := 0:

    while pq[0] <> 0 do
    tmp := extract(pq);
    curr := tmp[2];
    dir := tmp[3];
    sc := tmp[4];

    if curr = theend then
            edc++;
            if edc >= 2*scmax then
                break;
            end if; # all possible ends
    end if;

    # valid destinations
    nb := neibs(curr, dir, sc);

        for pt in nb do
            newcost := costsofar[curr,dir,sc] + grid[pt[]];
            ndir := pt-curr;
            nsc := ifelse(dir=ndir,sc+1,1);
            if newcost < costsofar[pt,ndir,nsc] then        
                costsofar[pt,ndir,nsc] := newcost;
                path[pt,ndir,nsc] := tmp[2..4];
                insert([-newcost,pt,ndir,nsc], pq);
            end if;
        end do;
    end do;

    local ends := [seq([[theend,[1,0],i],[theend,[0,1],i]][], i=scmin..scmax)];
    return min(seq(costsofar[i[]],i in ends)), ends[min[index]([seq(costsofar[i[]],i in ends)])], path;

end proc:

cost, tend, path := Dijkstra(finish):
ans1 := cost;

(* # path
curr := tend[];
out := curr[1];
while curr[1] <> [1,1] do
    curr := path[curr[]];
    out := out, curr[1];
end do:
ListTools:-Reverse([out]);
*)

scmin := 4;
scmax := 10;
cost, tend, path := Dijkstra(finish):

ans2 := cost;

(* # path
curr := tend[];
out := curr[1];
while curr[1] <> [1,1] do
    curr := path[curr[]];
    out := out, curr[1];
end do:
ListTools:-Reverse([out]);
*)
