size(E,1) &
un(Content,E,Content_) & 
(nsubset(Content,Content_) 
 or 
 diff(Content_,Content,M1) & size(M1,M2) & M2 > 1 
 or size(Content_,M3) & M3 < 1
)
