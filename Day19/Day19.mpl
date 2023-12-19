with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-19-input.txt" ):

(rules, parts) := StringSplit(Trim(input),"\n\n")[]:
rules := map(proc(s) local p := FirstFromLeft("{",s); s[1..p-1]=PW(Split(s[p+1..-2],",:")[]); end proc, Split(rules)):
rorder := map2(op,1, rules):
rules := subsindets(rules, string, s->ifelse(Has(s,">") or Has(s,"<"), parse(s),s)):
lrules := table(eval(rules, PW=(()->[_passed]))):
rules := table(subs(PW=piecewise, rules)):
parts := map(q->map(s->s2i(Select(IsDigit,s)), Split(q,",")), Split(parts)):

check_part := proc(p)
    local res := eval( rules["in"], {x=p[1],m=p[2],a=p[3],s=p[4]});
    while res<>"A" and res<>"R" do
        res := eval( rules[res], {x=p[1],m=p[2],a=p[3],s=p[4]});
    end do;
    return ifelse(res="A", true, false);
end proc:

ans1 := add( map( add, select(check_part, parts)) );

dict := table([x=1,m=2,a=3,s=4]);

count_parts := proc(r, vals)
local count:=0, rule, pivot, var, splitvals, restvals, i, range, fh, lh, v;
    # base case - never hit?
    if member([], vals) then return 0; end if;

    rule := lrules[r];
    restvals := vals;
    for i to nops(rule)-1 by 2 do
        # find the split
        pivot := indets(rule[i], integer)[]:
        var := indets(rule[i], name)[]:
        range := restvals[dict[var]];
        if type(op(1,rule[i]),name) then # <
            fh := ifelse(range[1]>pivot-1, [], [range[1], pivot-1]);
            lh := ifelse(pivot>range[2], [], [pivot, range[2]]);
            splitvals := subsop(dict[var]=fh,restvals);
            restvals := subsop(dict[var]=lh,restvals);
        else # >
            fh := ifelse(range[1]>pivot, [], [range[1], pivot]);
            lh := ifelse(pivot+1>range[2], [], [pivot+1, range[2]]);
            splitvals := subsop(dict[var]=lh,restvals);
            restvals := subsop(dict[var]=fh,restvals);
        end if;
        if rule[i+1] = "R" then
            next; # discard splitvals
        elif rule[i+1] = "A" then
            # count all splitvals
            count := count + mul(`-`(v[],1), v in splitvals);
        else
            count := count + thisproc(rule[i+1], splitvals);
        end if;

    end do;

    if rule[-1] = "R" then
        # discard rest
    elif rule[-1] = "A" then
        count := count + mul(`-`(v[],1), v in restvals);
    else
        count := count + thisproc(rule[-1], restvals);
    end if;

    return count;

end proc:

ans2 := count_parts("in", [[1,4000], [1,4000], [1, 4000], [1, 4000]]);