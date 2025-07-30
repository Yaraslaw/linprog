size(E,1) &
inters(E,Content,M1) &
size(M1,0) &
size(Content,Size) &
Content_ = {E/Content} & E nin Content &
Size_ is Size+1 &
(Size_ =< 0 or size(Content_,M2) & M2 neq Size_)

