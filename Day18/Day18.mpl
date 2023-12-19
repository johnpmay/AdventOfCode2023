with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-18-input.txt" ):

dirs := map(Split,Split(Trim(input),"\n")):
start := [1,1];
pos := start;
ptcount := 0;
poly := DEQueue();
push_back(poly, pos);

for j to nops(dirs) do
    d:=dirs[j];
    opos := pos;
    pos := pos + np[d[1]]*s2i(d[2]);
    ptcount += abs(add(opos - pos)); # count start, not end
    push_back(poly, pos);
end do:

R:=convert(poly,list)[1..-2]:
n:=nops(R);
A := 1/2 * abs(R[1][2]*(R[n][1]-R[2][1])+add(R[i][2]*(R[i-1][1]-R[i+1][1]), i=2..n-1)+(R[n][2]*(R[n-1][1]-R[1][1])));
# picks's theorem A = I + bd/2-1
bdpoints := ptcount;
intpoints := A - ptcount/2 + 1;
ans1 := intpoints+bdpoints;

# part 2
dtab:= table(["0"="R","1"="D","2"="L","3"="U"]);
bdir := [seq]( Subs(["(#"="", ")"=""], d[3]), d in dirs):
bdir := map(d->[dtab[d[-1]],convert(d[1..-2],decimal,hex)], bdir):
pos := start;
ptcount := 0;
poly := DEQueue();
push_back(poly, pos);

for j to nops(bdir) do
    d:=bdir[j];
    opos := pos;
    pos := pos + np[d[1]]*(d[2]);
    ptcount += abs(add(opos - pos)); # count start, not end
    push_back(poly, pos);
end do:

R:=convert(poly,list)[1..-2]:
n:=nops(R);
A := 1/2 * abs(R[1][2]*(R[n][1]-R[2][1])+add(R[i][2]*(R[i-1][1]-R[i+1][1]), i=2..n-1)+(R[n][2]*(R[n-1][1]-R[1][1])));
bdpoints := ptcount;
intpoints := A - ptcount/2 + 1;
ans2 := intpoints+bdpoints;