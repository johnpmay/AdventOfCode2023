with(StringTools):
s2i := s->sscanf(s,"%d")[]: # safe integer parser
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-03-input.txt" ):

scm :=  map(Explode,Split(Trim(input),"\n")):
r := nops(scm);
c := nops(scm[1]);
# pad edges with "." to remove those edge cases
scM := Matrix(1..r+2, 1..c+2, ()->"."):
scM[2..r+1, 2..c+1] := subs("."=".",Matrix(scm)):

# find all symbols
symlist := convert(Explode(Remove(IsDigit, Subs(["."="","\n"=""],input))),set);

adjsymbol := proc(r,c, syms) # find a symbol adjacent to a position
local i,j; 
    for i from -1 to 1 do
       for j from -1 to 1 do
           if scM[r+i,c+j] in syms then
                return [r+i, c+j];
           end if;
        end do;
     end do;
     return false;
end proc:

findparts := proc(syms:=symlist)
local partnums, i, j, k, tmp, coord;
    partnums := NULL;
    for i from 2 to r+1 do
        for j from 2 to c+1 do
            if IsDigit(scM[i,j]) then
                k := j;
                if IsDigit(scM[i,j+1]) then # at least two digit part#
                    if IsDigit(scM[i,j+2]) then # three digit part#
                        tmp := cat(convert(scM[i,j..j+2],list)[]);
                        j := j+2;
                    else # only two digit part#
                        tmp := cat(convert(scM[i,j..j+1],list)[]);
                        j := j+1;
                    end if;
                else # only one digit part#
                    tmp := scM[i,j];
                    j := j+1;
                end if;
                # walk the number, looking for adjacent symbols
                while scM[i,k] <> "." do
                    coord := adjsymbol(i,k,syms);
                    if coord<>false then
                        partnums := partnums, s2i(tmp)=coord;
                        break;
                    end if;
                    k:=k+1;   
                end do;
            end if;
        end do:
    end do:
    return [partnums];
end proc:

ans1:=`+`(lhs~(findparts())[]);

# part 2 - use findparts to get just the "*" adjacent parts
# then match up parts on the same gears, then select gears with just 2 parts
ans2 := add( map(l->mul(map(lhs,l)),
                 select(l->nops(l)=2, 
                    [ListTools:-Categorize((x,y)->rhs(x)=rhs(y), 
                        findparts({"*"}))]
                        )
                ) 
            );