#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
with(GraphTheory):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-23-input.txt" ):

grid := ( map(Explode,Split(Trim(input),"\n")) ):
dirtable := table([">"=[0,1], "<"=[0,-1], "^"=[-1,0], "v"=[1,0]]);
dim := nops(grid);
grid := Array(grid,datatype=string);

neibs := proc(pos)
local dirs := [ [1,0], [0,1], [-1,0], [0,-1] ];
    if grid[pos[]]="#" then
        error "snh, how did you get in a tree?";
    elif grid[pos[]] in {">","<","^","v"} then
        dirs := [dirtable[grid[pos[]]]];
    end if;
    dirs := remove(d->min(pos+d)<1 or max(pos+d)>dim, dirs); # remove off grid
    dirs := remove(d->grid[(pos+d)[]]="#", dirs); # remove forest
    dirs := remove(d->d=-dirtable[grid[(pos+d)[]]], dirs); # can't go uphill
    return map(d->d+pos, dirs);
end proc:

Dijkstra := proc(start, theend, nogo:={})
local pq, costsofar, curr, nb, newcost, pt, tmp, i;
global grid;
uses priqueue;

    costsofar := table(sparse=infinity):

    initialize(pq):
    insert([0,start], pq):
    costsofar[start] := 0:

    while pq[0] <> 0  do
        tmp := extract(pq);
        curr := tmp[2];
        if curr = theend then
            return costsofar[theend];
        elif curr in nogo then
            next;
        end if;
        # valid destinations
        nb := neibs(curr);
        for pt in nb do
            newcost := costsofar[curr] + 1;
            if newcost < costsofar[pt] then
                costsofar[pt] := newcost;
                insert([-newcost,pt], pq);
            end if;
        end do;
    end do;
    return FAIL;
end proc:

not_ans1 := Dijkstra([1,2], [dim,dim-1]); # shortest path actually

# compress the grid into a directed graph of intersections

# find all intersections
nodes := NULL:
for i to dim do for j to dim do
    if grid[i,j]<>"#" then
      nb := map(p->grid[p[]], neibs([i,j]));
      if nops(nb)>2 or numboccur(".",nb)=0 then nodes := nodes, [i,j]; end if;
    end if;
end do; end do:
V := [[1,2], nodes, [dim,dim-1]]: nops(V);
Vn := ["start",seq(sprintf("%a,%a",V[i][]),i=2..nops(V)-1), "finish"]:

# find the distance between each intersection in the original grid
# you should really do this in a single pass, but it was late at night
Eo := remove(i->i[2]=FAIL or i[1][1]=i[1][2],
  { seq(seq([[Vn[i],Vn[j]],Dijkstra(V[i], V[j], subs(V[i]=NULL, V[j]=NULL, V))],i=1..nops(V)),j=1..nops(V))}):
G := Graph(Vn,Eo);

# make a graph with negative edges then do BellmanFord to get the shortest path
# which will be the longest path in positive edges

# BellmanFord works because there are no negative cycles, but a simple DFS that disallows cycles would also work

E := map(e->[e[1],-e[2]], Eo):
H := Graph(Vn,E);
(path,cost) := BellmanFordAlgorithm(H, "start", "finish")[];

ans1 := add(GetEdgeWeight(G, [path[i],path[i+1]]),i=1..nops(path)-1);

# Part 2 is the same question on undirected version of the Graph
# BellmanFord no longer works due to negative weight undirected edges
Eo := map(e->[{e[1][]},e[2]], Eo):
G := Graph(Vn,Eo);

best := 0:
# vertices to try removing
Vt := [FAIL, subs("start"=NULL, "finish"=NULL, Neighborhood(G,"start")=NULL, Neighborhood(G,"finish")=NULL, Vn)[]]:

# Use TSP to find the longest path through all intersections, then find the
# longest path through all intersections except one
for vr in Vt do
    to 10 do # concord may return suboptimal paths, try a few times
        Vp := subs(vr=NULL,Vn);
        E := map(e->ifelse(has(e,vr), NULL, [e[1],1000-e[2]]), Eo):
        H := Graph(Vp,E);
        AddEdge(H, [{"start","finish"},1000],inplace);

        tsp := TravelingSalesman(H, solver=concorde, seed=randomize());
        if tsp[1] = infinity then
            next;
        end if;

        if tsp[2][2] = "finish" then
            path := ListTools:-Reverse(tsp[2][2..-1]);
        else
            path := tsp[2][1..-2];
        end if;

        pl := add(GetEdgeWeight(G,{path[i],path[i+1]}),i=1..nops(path)-1);

        if pl > best then
            best := pl;
            bestpath := path;
        end if;
    end do:
end do:

ans2 := best;
