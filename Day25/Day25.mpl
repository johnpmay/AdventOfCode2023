with(StringTools): with(GraphTheory): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-25-input.txt" ):
cons := map(c->[c[1], Split(Trim(c[2]))], map(Split, Split(Trim(input),"\n"),":")):
cons := {map(c->local i; seq({c[1],c[2][i]},i=1..nops(c[2])), cons)[]}: nops(cons);
parts := [map(op, cons)[]]: nops(parts);
P := Graph(parts, {seq([c,1], c in cons)});

mxfl := 4;
while mxfl > 3 do
    src := RandomTools:-Generate('choose'(parts));
    tar := RandomTools:-Generate('choose'(parts));
    printf("%s -> %s \n", src, tar);
    if src = tar then next; end if;
    (mxfl, M) := MaxFlow(P, src, tar);
end do:

(r,c) := ArrayTools:-SearchArray(M);
R := MakeDirected(P);
Q := DeleteArc(R, {seq([parts[c[i]],parts[r[i]]],i=1..numelems(c))},inplace=false);

reachable := {Reachable(Q, tar)[]}: nops(reachable);
nonreachable := {Vertices(P)[]} minus reachable: nops(nonreachable);

ans1 := nops(reachable)*nops(nonreachable);
