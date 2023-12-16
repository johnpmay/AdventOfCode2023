#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-16-input.txt" ):

grid := map(Explode@Trim,Split(Trim(input),"\n")):
m := nops(grid);
n := nops(grid[3]);

shootbeam := module()
local energized; # covered path Array
local track; # recursion protection table

local ModuleApply:=proc(p,d)
    energized := Array(1..m,1..n,()->0):
    track := table();
    shootbeamr(p,d);
    return add(energized);
end proc:

local shootbeamr := proc(pos, dir)
global grid;

    if pos[1] < 1 or pos[1] > m or pos[2] < 1 or pos[2] > n
    then
        return;
    end if; # base case

    if track[pos,dir] = 1 then
       return;
    else
       track[pos,dir] := 1;
    end if;

    energized[ pos[] ] := 1; 
    if grid[pos[]] = "." then # continue in dir
       return thisproc( pos+dir, dir );
    elif grid[pos[]] = "\\" then
       return thisproc( pos + [dir[2],dir[1]],
                              [dir[2],dir[1]]);
    elif grid[pos[]] = "/" then
       return thisproc( pos + [-dir[2],-dir[1]],
                              [-dir[2],-dir[1]]);
    elif grid[pos[]] = "-" then
       if dir[1] = 0 then
           return thisproc( pos+dir, dir );
       else           
           thisproc(pos+[0,1], [0,1]);
           thisproc(pos+[0,-1], [0,-1]);
           return;
       end if;

    elif grid[pos[]] = "|" then
       if dir[2] = 0 then
           return thisproc( pos+dir, dir );
       else         
           thisproc(pos+[1,0], [1,0]);
           thisproc(pos+[-1,0], [-1,0]);
           return;
       end if;
    else
       error "snh";
    end if;
end proc:
end module:

ans1 := shootbeam([1,1],[0,1]);

ans2 := max(
    seq((shootbeam([1,i],[1,0])),i=1..m),
    seq((shootbeam([n,i],[-1,0])),i=1..m),
    seq((shootbeam([i,1],[0,1])),i=1..n),
    seq((shootbeam([i,m],[0,-1])),i=1..n)
);