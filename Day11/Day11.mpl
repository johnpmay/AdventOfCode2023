with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-11-input.txt" ):
grid := Matrix( subs("."=0,"#"=1,map(Explode, Split( Trim(input), "\n"))) );
m,n := (rhs~([rtable_dims(grid)]))[];

(r,c) := ArrayTools:-SearchArray(grid):
galaxies := [seq([r[i],c[i]], i=1..numelems(r))]: ng := nops(galaxies);
exrows := {seq}(ifelse(add(grid[i])=0, i, NULL), i = 1..m);
excols := {seq}(ifelse(add(grid[..,i])=0, i, NULL), i = 1..m);

exdistance := proc(a, b, xfactor)
global exrows, excols;
local ar, ac;
     ar := nops( select(r->r>min(a[1],b[1]) and r<max(a[1],b[1]), exrows) );
     ac := nops( select(c->c>min(a[2],b[2]) and c<max(a[2],b[2]), excols) );
     abs(a[1]-b[1])+abs(a[2]-b[2])+xfactor*(ar+ac);
end proc:

ans1 := add( add( exdistance( galaxies[i], galaxies[j], 1 ), j=i+1..ng), i=1..ng);
ans2 := add( add( exdistance( galaxies[i], galaxies[j], 10^6-1 ), j=i+1..ng), i=1..ng);


