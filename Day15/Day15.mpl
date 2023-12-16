with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-15-input.txt" ):

steps := Split(Subs("\n"="",input),","): nops(steps);
ascii := s->convert(s, ByteArray)[1]:

HASH := proc(s)
local j, currentvalue;
    currentvalue := 0;
    for j to length(s) do
        currentvalue += ascii(s[j]);
        currentvalue *= 17;
        currentvalue := currentvalue mod 256;
    end do:
    return currentvalue;
end proc:

output := 0:
for s in steps do
    output += HASH(s);
end do:
ans1 := output;

hashmap := table(sparse=NULL):

for s in steps do
    if s[-1] = "-" then
        l := s[1..-2];
        h := HASH(l);
        if has([hashmap[h]], l) then
            hashmap[h] := remove(t->t[1]=l, [hashmap[h]])[];
        end if;
    else
        l,f := Split(s,"=")[];
        h := HASH(l);
        f := s2i(f);
        if has([hashmap[h]], l) then
            o := select(t->t[1]=l, [hashmap[h]])[];
            hashmap[h] := subs(o=[l,f], [hashmap[h]])[];
        else
            hashmap[h] := hashmap[h], [l,f];
        end if;
    end if;
end do:

ans2 := add(add((i+1)*j*[hashmap[i]][j][2], j=1..nops([hashmap[i]])),i=0..255);


