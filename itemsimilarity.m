cosinearray = zeros(7849,7849)
for i=1:7849
for j=1:7849
p=find(EchoNest(:,i))
q=find(EchoNest(:,j))
commonusers=length(intersect(p,q))
lengthp = sqrt(length(p))
lengthq = sqrt(length(q))
cosine=commonusers/(lengthp*lengthq)
cosinearray(i,j) = cosine
end
end