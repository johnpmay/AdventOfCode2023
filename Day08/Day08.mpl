with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-08-input.txt" ):

(inst, nodes) := StringSplit(Trim(input), "\n\n")[]:
nodes :=table( map(m->m[1]=map(Trim,Split(m[2][2..-2],","))[],
                map(n->StringSplit(n," = "), Split(nodes,"\n")))):
inst := subs("L"=1,"R"=2, Explode(inst)):

curr := "AAA";
steps := 0:
while curr <> "ZZZ" to 10000 do
    for d in inst do
        curr := nodes[curr][d];
        steps++;
        if curr = "ZZZ" then break; end if;
     end do;
end do:
ans1 := steps;

#part 2
clist := Array( select(s->s[3]="A", [indices(nodes,nolist)]) );
n := numelems(clist);
steps := Array(1..n):
for i to n do
  curr := clist[i];
  steps[i] := 0;
  while curr[3] <> "Z" to 10000 do
      for d in inst do
          curr := nodes[curr][d];
          steps[i]++;
          #print(i, curr, steps[i]);
          if curr[3] = "Z" then break; end if;
      end do;
  end do:
end do:

ans2 := lcm( entries(steps, 'nolist') );


