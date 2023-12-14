#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-14-input.txt" ):

ogrid := map(Explode,Split(Trim(input),"\n")):
m := nops(ogrid);
n := nops(ogrid[1]);
grid := Matrix(ogrid):

tilt := proc(dir:="N")
local r,c,i;
global grid,n,m;
    if dir = "N" then
    # tilt North
        for r from 2 to m do
            for c to n do
                if grid[r,c] = "O" then
                    i := 0;
                    while r-i-1 > 0 and grid[r-i-1,c]="." do
                        grid[r-i-1,c] := "O";
                        grid[r-i,c] := ".";
                        i++;
                    end do;
                end if;
            end do;
        end do;
    elif dir = "S" then
    # tilt south
        for r from m-1 to 1 by -1 do
            for c to n do
                if grid[r,c] = "O" then
                    i := 0;
                    while r+i+1 <= m and grid[r+i+1,c]="." do
                        grid[r+i+1,c] := "O";
                        grid[r+i,c] := ".";
                        i++;
                    end do;
                end if;
            end do;
        end do;
    elif dir = "W" then
    # tilt west
        for c from 1 to n do
            for r to m do
                if grid[r,c] = "O" then
                    i := 0;
                    while c-i-1 > 0 and grid[r,c-i-1]="." do
                        grid[r, c-i-1] := "O";
                        grid[r,c-i] := ".";
                        i++;
                    end do;
                end if;
            end do;
        end do;
    elif dir = "E" then
        for c from n-1 to 1 by -1 do
            for r to m do
                if grid[r,c] = "O" then
                    i := 0;
                    while c+i+1 <= n and grid[r,c+i+1]="." do
                        grid[r, c+i+1] := "O";
                        grid[r,c+i] := ".";
                        i++;
                    end do;
                end if;
            end do;
        end do;
    end if;
    return;
end proc:

grid := Matrix(ogrid): # reset!
tilt("N");
ans1 := add(map(add, subs("#"=0,"."=0,"O"=1, convert(grid,listlist)) *~ [seq(m-i+1, i=1..m)]));

grid := Matrix(ogrid):
radix := max(map(length, subs(""=NULL, Split( cat(map(l->(l[],"#"), convert( grid, listlist))[]), "#"))));
fingerprint := proc()
local i, d;
    d := map(s->length(Subs("."="",s)), 
        subs(""=NULL, Split( cat(map(l->(l[],"#"), convert( grid, listlist))[]), "#")));
    return add(d[i]*radix^(nops(d)-i),i=1..nops(d));
end proc:

dotilt := proc() tilt("N"):tilt("W"):tilt("S"):tilt("E"): end proc:

findloop := proc(iter:=1000)
    local i, fp;
    local fptable := table(sparse=0);
    for i to iter do 
        dotilt();
        fp := fingerprint();
        if fptable[fp] <> 0 then
            return fptable[fp], i;
        else
            fptable[fp] := i;
        end if;
    end do;
    return FAIL, FAIL;
end proc:

# find a loop in the grids
grid := Matrix(ogrid):
s,e := findloop();
ll := e-s;
numloops := iquo(1000000000-s,ll);
r := irem(1000000000-s,ll);

# calculate where we'd be after 1000000000 spins = s+r spins
grid := Matrix(ogrid):
to s+r do dotilt(); end do:
ans2 := add(map(add, subs("#"=0,"."=0,"O"=1, convert(grid,listlist)) *~ [seq(m-i+1, i=1..m)]));


