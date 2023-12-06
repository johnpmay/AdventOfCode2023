with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-02-input.txt" ):
games := Split(Trim(input), "\n"):

games2 := map(g->map( h->table(sparse, 
    map(rhs=lhs,[parse(Subs([", "=","," "="="], Trim(h)))])),
        Split(Split(g, ":")[2],";") ), games):

# part 1
rlimit := 12:
glimit := 13:
blimit := 14:

ans1 := 0:
for i to nops(games2) do
    flag := true;
    for j to nops(games2[i]) do
        if games2[i][j][red] > rlimit or games2[i][j][green] > glimit or games2[i][j][blue] > blimit then
            flag := false; break;
        end if;
    end do;
    if flag then
        ans1 := ans1 + i;
    end if;
end do:
ans1;

# part 2
ans2 := 0;
for i to nops(games2) do
    flag := true; 
    mins := table(sparse);
    for j to nops(games2[i]) do
        mins[red] := max(mins[red], games2[i][j][red]);
        mins[green] := max(mins[green], games2[i][j][green]);
        mins[blue] := max(mins[blue], games2[i][j][blue]);
    end do;
    ans2 := ans2+mins[red]*mins[green]*mins[blue];
end do:
ans2;