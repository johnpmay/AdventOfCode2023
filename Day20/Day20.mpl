#restart;
with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-20-input.txt" ):

themodl := map(s->[s[1], StringSplit(s[2],", ")], map(StringSplit, Split(Trim(input),"\n"), " -> ")):
themods := table(map(l->ifelse(l[1][1]="b",l[1],l[1][2..-1])=[l[1][1],l[2]], themodl)):
allmods := sort([indices(themods,nolist)],length):
revcon := table([seq(m=select(n->member(m,themods[n][2]), allmods), m in allmods)]):

# track conjunction states
states := table([ seq(m=ifelse(themods[m][1]="&", table([seq(n="low",n in revcon[m])]), ifelse(themods[m][1]="%","off", "none")), m in indices(themods,nolist))]): # initial states

Q := DEQueue():
count := table(["low"=0,"high"=0]):
slist := [seq(ifelse(states[m]::string, states[m], cat(seq(ifelse(states[m][n]::string, states[m][n], ""),n in allmods))), m in allmods)]:
bcount[0] := [0,0]:

for j to 1000 do
# press button : low signal to broadcast
#printf("Button Press #%d\n\n", j);
push_back(Q, ["broadcaster","low","button"]):
    while not empty(Q) do
        evnt := pop_front(Q);
        omod := evnt[3];
        tmod := evnt[1];
        sigtype := evnt[2];
        count[sigtype] := count[sigtype]+1;
        if not member(tmod, allmods) then # dead end
            next;
        end if;
        modtype := themods[tmod][1];
        if modtype = "%" then
            if sigtype="high" then
                # nothing
                next;
            else # low
                if states[tmod] = "on" then
                    states[tmod] := "off";
                    sigtype := "low";
                else # off
                    states[tmod] := "on";
                    sigtype := "high";
                end if;
            end if;
        elif modtype = "&" then
            states[tmod][omod] := sigtype;
            if {entries(states[tmod],'nolist')}={"high"} then
                sigtype := "low";
            else
                sigtype := "high";
            end if;
        end if;

        for e in themods[tmod][2] do
            push_back(Q, [e, sigtype, tmod]);
        end do;
    end do:

    # loop detection
    nstate := [seq(ifelse(states[m]::string, states[m], cat(seq(ifelse(states[m][n]::string, states[m][n], ""),n in allmods))), m in allmods)];
    bcount[j] := [count["low"], count["high"]];
    if member(nstate, {slist}, 'loc') then
        break; # repeated state;
    else
        slist := slist, nstate;
    end if;

end do:

if j < 1000 then
    lead := 1-loc;
    loop := j-loc + 1;
    leadcount := bcount[lead];
    loopcount := bcount[j] - bcount[lead];
    ans1 := mul( (1000-lead)/loop * loopcount );
else # haha, no loop
    ans1 := mul( mul(bcount[1000]) );
end if;

# part 2 - strip down loop to just look for periods in conjunction going to rx
# this is the first thing that works - no CRT needed

states := table([ seq(m=ifelse(themods[m][1]="&", table([seq(n="low",n in revcon[m])]), ifelse(themods[m][1]="%","off", "none")), m in indices(themods,nolist))]): # initial states

Q := DEQueue():

prx := select(has, themodl, "rx")[][1][2..3];
prxinp := [indices(states[prx],nolist)];
periods := table():

for j to 10000 do

    push_back(Q, ["broadcaster","low","button"]):

    while not empty(Q) do
        evnt := pop_front(Q);
    
        omod := evnt[3];
        tmod := evnt[1];
        sigtype := evnt[2];
        
        if not member(tmod, allmods) then # dead end
            if tmod = "rx" then # compute periods
            for i in prxinp do
                if states[prx][i] = "high" then
                    periods[i] := j;
                end if;
            end do;
                if numelems(periods) = nops(prxinp) then
                    break;
                end if;
            end if;
            next;
        end if;

        modtype := themods[tmod][1];
        
        if modtype = "%" then
            if sigtype="high" then
                # nothing
                next;
            else # low
                if states[tmod] = "on" then
                    states[tmod] := "off";
                    sigtype := "low";
                else # off
                    states[tmod] := "on";
                    sigtype := "high";
                end if;
            end if;
        elif modtype = "&" then
            states[tmod][omod] := sigtype;
            if {entries(states[tmod],'nolist')}={"high"} then
                sigtype := "low";
            else
                sigtype := "high";
            end if;
        end if;

        for e in themods[tmod][2] do
            push_back(Q, [e, sigtype, tmod]);
        end do;

    end do:
    if numelems(periods) = nops(prxinp) then
        break;
    end if;
end do:

ans2 := lcm( entries(periods,nolist) );