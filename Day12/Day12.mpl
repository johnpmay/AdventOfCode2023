#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-12-input.txt" ):

recs := map(l->[l[1], map(s2i,Split(l[2],","))], map(Split,Split(Trim(input),"\n")," ")):
parity := s->add(subs(["."=0,"?"=0,"#"=1], Explode(s))); parity("#??#");
CheckData2 := proc(str::string, num::list(posint)) #option trace;
     if Search("?", str) > 0 then error; end if; 
     evalb(map(length, Split(Trim(Squeeze(Subs("."=" ", str)))))=num);
end proc:

CheckData := proc(str::string, num::list(posint), pre::integer:=length(str)) #option trace;
local i, bn, damcount;
option cache;

    if parity(str) > add(num) then return fail('p'); end if;

    bn := 1; 
    damcount := 0;

    for i from 1 to pre do
        if str[i]="." then
            if damcount = 0 then
                next; # dam seq has not started
            elif damcount <> num[bn] then
                return fail(bn-1); # dam seq ended - wrong length
            elif damcount = num[bn] then
                bn := bn+1; # dam seq ended - right length
                damcount := 0;
            else
                error "snh";
            end if
        elif str[i]="#" then # in a dam seq
            damcount := damcount+1;
            if bn>nops(num) or damcount > num[bn] then
               # starting a new dam seq too many
               # or current dam seq not too long                  
                 return fail(bn-1);
            end if;
        else
            error "no unknowns supported", str[i];
        end if;
    end do;

    if (bn = nops(num)+1 and damcount=0) then
         return fin(bn-1);
    elif (bn=nops(num) and damcount = num[bn]) then
         return fin(bn);
    else
        if damcount = 0 then
            return fin(bn-1);
        else
            return partial(bn);
        end if;
    end if;
end proc:

findMatches := proc(orr, nn)# option trace;
local rr, i, dstr, ostr, chk, p, tot:=0;
option cache;

     p := parity(orr);
     if p > add(nn) then return 0; end if;

     i := FirstFromLeft("?", orr);
     if i = 0 then
         if p < add(nn) then return 0; end if;
         chk := CheckData(orr, nn);
         if op(0,chk) = 'fin' then 
            #print(a);         
            return 1;
         else 
           # error "snh 2";
            return 0;
         end if;
      end if;

      rr := Subs(["...."=".","..."=".",".."="."], orr);
      if rr[1] = "." then rr := rr[2..-1]; end if;
      i := FirstFromLeft("?", rr);

      if p < add(nn) then
         dstr := cat(rr[1..i-1],"#",rr[i+1..-1]);
         chk := CheckData(dstr, nn, i);
         if op(0,chk) <> 'fail' then              
            tot := tot+thisproc(dstr, nn);
         end if;
      else
         return thisproc( Subs("?"=".",rr), nn );
      end if;
      ostr := cat(rr[1..i-1],".",rr[i+1..-1]);
      chk := CheckData(ostr, nn, i);
      if op(0,chk) <> 'fail' then
          if op(0,chk) = 'fin' and op(chk) > 0 then
            tot := tot+thisproc(rr[i+1..-1],nn[(op(chk)+1)..-1]);
          else
            tot := tot+thisproc(ostr, nn);
          end if;
      end if;

      return tot;

end proc:

normalize := proc(s)
     local o := Subs(["...."=".", "..."=".", ".."="."], s);
     if o[1] = "." then o := o[2..-1]; end if;
     if o[-1] = "." then o := o[1..-2]; end if;
     return o;
end proc:

recsn := map(r->[normalize(normalize(r[1]) ), r[2]], recs):
ans1 := CodeTools:-Usage( add(findMatches(r[]), r in recsn) );

unfold_recs := map(r->[normalize(normalize(r[1]) ), r[2]], map(r->local i; [cat(r[1],"?",r[1],"?",r[1],"?",r[1],"?",r[1]), [seq(r[2][],i=1..5)]], recs)):
ans2 := CodeTools:-Usage( add(findMatches(r[]), r in unfold_recs) );
# correct: 18716325559999

