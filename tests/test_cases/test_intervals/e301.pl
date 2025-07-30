MinA in A & 
subset(A,int(MinA,MaxA)) & 
MinB in B & 
subset(B,int(MinB,MaxB)) & 
inters(A,B,C) & 
MinC in C & 
subset(C,int(MinC,MaxC)) & 
(MinC < MinA or MinC < MinB)
