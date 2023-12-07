with(StringTools):
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-04-input.txt" ):
clist := map(Trim~@Split, Split(Trim(input),"\n"),":|"):
clist := map(c->[Split(Squeeze(c[2])), Split(Squeeze(c[3]))], clist):

total := 0:
for c in clist do
    cc := 0; # "card count"
    for n in c[2] do
        if member(n,c[1]) then
            cc := cc+1;
        end if;
    end do;
    if cc > 0 then
        total := total + 2^(cc-1);
    end if;
end do:
ans1 := total;

cardtot := Array(1..nops(clist), ()->1):
for i to nops(clist) do
    cc := 0;
    for n in clist[i][2] do
        if member(n,clist[i][1]) then
            cc := cc+1;
        end if;
    end do;
    for j to cc do # increment # of next cc cards with # of this card
        cardtot[i+j] += cardtot[i];
    end do;
end do:
ans2 := add( cardtot );