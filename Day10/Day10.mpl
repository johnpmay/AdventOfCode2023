with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-10-input.txt" ):

grid := map(Explode,Split(Trim(input),"\n")):
w := nops(grid);
h := nops(grid[1]);
tmp := Matrix(grid):
grid := Matrix(w+2, h+2, ()->"."):
grid[2..w+1,2..h+1] := tmp:

#part 1
start := Search("S", input);
start := [iquo(start, h+1)+2, irem(start, h+1)+1];
grid[start[]] = "S";

connections := table([
    "S" = [ [-1,0], [1,0], [0, -1], [0,1]],
    "|" = [ [-1,0], [1,0] ],
    "-" = [ [0,-1], [0,1] ],
    "L" = [ [-1, 0], [0,1] ],
    "J" = [ [-1, 0], [0,-1] ],
    "7" = [ [1,0], [0,-1] ],
    "F" = [ [1,0], [0,1] ],
    "." = []
   ]):

neighbors := table(sparse={});
distance := table(sparse=infinity);
distance[start] := 0;

priqueue:-initialize(Q);
priqueue:-insert([0,start], Q);

while Q[0] <> 0 to numelems(grid) do
curr := priqueue:-extract(Q)[2];
for nb in connections[grid[curr[]]] do
   if curr in map(c->c+(curr+nb), connections[grid[(curr+nb)[]]]) then
      neighbors[curr] := neighbors[curr] union {(curr+nb)};
      if distance[curr+nb] > distance[curr]+1 then
          distance[curr+nb] := distance[curr]+1;
          priqueue:-insert([-distance[curr+nb],curr+nb],Q);
      end if;
   end if;
end do;

end do:
ans1 := max(entries(distance));


a:=sort([indices(neighbors,nolist)])[1];
path := Array(1..numelems(neighbors));
path[1]:=a;
b:=neighbors[a][-1];
ttt:=time():
i:=2;
while b <> path[1] do
    path[i] := b; i++;
    (a,b) :=(b, ifelse(neighbors[b][1]=a, neighbors[b][2],neighbors[b][1]));
end do:
ttt:=time()-ttt;

iogrid := Matrix(w+2, h+2, (i,j)->ifelse(distance[[i,j]]=infinity,ifelse(i=1 or j=1 or i=w+2 or j=h+2, "O", "."),grid[i,j]) ):

# routine to fill in insides or outsides by traversing neighbors
fill := proc(seed, orient)
global iogrid;
local visited, p, curr, nb, N, P, count;
    count := 0;
    visited := table(sparse=false):
    priqueue:-initialize(P);
    priqueue:-insert([0, seed], P);
    while P[0] <> 0 to numelems(iogrid) do
        (p, curr) := priqueue:-extract(P)[];
        if not visited[curr] and iogrid[curr[]] = orient then
        for nb in [[-1,0], [1,0], [0,-1], [0,1]] do
            N := curr+nb; 
            if N[1] = 0 or N[2] = 0 or N[1] = w+3 or N[2] = h+3 then next; end if; # edges
            if iogrid[N[]] = "." then
                iogrid[N[]] := orient;
                count++;
                if not visited[N] then
                    priqueue:-insert([p+1, N], P);
                end if;
            end if;
        end do;
        visited[curr] := true;
        end if;
    end do: 
    if count > 0 then
        printf("\nFilled %d tiles %s\n",count, orient);
    end if;
end proc:

# fill from boundary  
seq([fill([i,1], "O"),fill([i,h+2], "O")],i=1..w+2):
seq([fill([1,i], "O"),fill([w+2,i], "O")],i=1..h+2):

numboccur(iogrid, "."); # remaining to fill

R:=convert(path,list):
outside := ComputationalGeometry:-PointInPolygon([1,1], R): #
ttt := time():
cp := 0:
for i from 2 to w+1 do
    for j from 2 to h+1 do
        if iogrid[i,j] = "." then
            cp++;
            if cp mod 10 = 1 then printf("#%d [%d, %d], ", cp, i,j); end if; # logging
            if ComputationalGeometry:-PointInPolygon([i,j], R) = outside then
                iogrid[i,j] := "O";
                fill([i,j], "O");
            else
                iogrid[i,j] := "I";
                fill([i,j], "I");
            end if;
        end if;
    end do;
end do: printf("\n");
cp;
ttt:=time()-ttt;

ans2 := numboccur(iogrid, "I");
