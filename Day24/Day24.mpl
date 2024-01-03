with(StringTools): s2i := s->sscanf(s,"%d")[1]:
input := FileTools:-Text:-ReadFile("../../AdventOfCode_inputs/AoC-2023-24-input.txt" ):

stones := subsindets(map(Split, Split(Subs(" "="",Trim(input)),"\n"), "@"), string, parse): nops(stones);
bbox := [200000000000000, 400000000000000];

count := 0:
for i from 1 to nops(stones) do
    for j from i+1 to nops(stones) do

        s1 := stones[i];
        s2 := stones[j];

# check no intersection or parallel
    if s1[5]*s2[4] = s2[5]*s1[4] then
    #  printf("checking if parallel lines the same %d, %d : ", i, j);
        t1 := (s2[1] - s1[1])/s1[4];
        if t1 <> (s2[2] - s1[2])/s1[5] then
            next;
        end if;

        t2 := (s1[1] - s2[1])/s2[4];
        if t2 <> (s1[2] - s2[2])/s2[5] then
            next;
        end if;

    else
# only valid when s1[4]*s2[5] <> s1[5]*s2[4]

    coord:=ComputationalGeometry:-FindLineIntersection([s1[1],s1[2]], [s1[1]+s1[4],s1[2]+s1[5]],  [s2[1],s2[2]], [s2[1]+s2[4],s2[2]+s2[5]] );

# forward in time - from symbolic solve
        t1 := ((s1[2] - s2[2])*s2[4] - s2[5]*(s1[1] - s2[1]))/(s1[4]*s2[5] - s1[5]*s2[4]);
        t2 := ((s1[2] - s2[2])*s1[4] - s1[5]*(s1[1] - s2[1]))/(s1[4]*s2[5] - s1[5]*s2[4]);

    end if;

#print(i,j,evalf[5](coord),1.*t1,1.*t2);

    if t1 < 0 or t2 < 0 then
    # print(i,j, "crossed in one or both stone's past");
        next;
    end if;


    if coord[1] >= bbox[1] and coord[1] <= bbox[2] and
        coord[2] >= bbox[1] and coord[2] <= bbox[2]
    then
        count++;
    else
    # print(i,j,"outside bounding box");
    end if;

    end do;
end do;

ans1 := count;

# part 2
uknown := [dX*t+X, dY*t+Y, dZ*t+Z];
eqs := [seq(zip(`-`, stones[i][1..3] + t[i]*~stones[i][4..6], eval(uknown,t=t[i]))[],i=1..3)]; nops(eqs),nops(indets(eqs)); # already uniquely determined with 3
sol := solve(eqs);
ans2 := eval(X+Y+Z, sol);


