IDX = [304:1010]';
train = SparseN(304:end,:);
test = SparseN(1:303,:);


for i = 1:size(test,1)
    clear s;
    clear len;
    s = find(test(i,:));
    len = length(s);
    %testcheck(i,:) = test(i,s(ceil(len/2)+1:end));
    test(i,s(ceil(len/2)+1:end)) = 0;
end

KNNval = 20;
mdl = ClassificationKNN.fit(train, IDX, 'distance', 'cosine','NumNeighbors',KNNval);
[prediction score cost] = predict(mdl, test);
% prediction (:,2) = IDX;
% sum(prediction (:,2) ~= prediction (:,1))/length(prediction (:,2) )


%positionIdx = zeros(6,10);

for i=1:length(prediction)
    matchedU = find(score(i,:));
    for j = 1:KNNval
        len(j) = length( EchoNest(size(test,1)+matchedU(j),...
            find(EchoNest(size(test,1)+matchedU(j),:))) );
    end
    
    similarUser = size(test,1) + matchedU(find(len == max(len)));
    recommendation = find(EchoNest(similarUser(1),:));
    playcounts = EchoNest(similarUser,recommendation);
    [sortedCounts countIdx] = sort(playcounts,'descend');
    topK = length(countIdx); %min(10,length(countIdx));
    topRecommendation = recommendation(countIdx(1:topK));
    
    l1 = find(EchoNest(i,:));
    len = length(l1);
    commonSongs = intersect(topRecommendation, l1(ceil(len/2):end));
    
    for ii=1:length(commonSongs)
        
        idx = find(topRecommendation == commonSongs(ii));
        positionIdx(i,ii) = idx;
    end
    resultsMatch(i) = length(commonSongs);
end
%size(positionIdx)
%mAp
mapsum(1:size(positionIdx,1),1)=0;
for i=1:size(positionIdx,1)
    for j=1:size(positionIdx,2)
        if (positionIdx(i,j)==0)
            continue;
        else
            k=positionIdx(i,j);
        end
            mapsum(i)=(mapsum(i)+j/k);
    end
    if(length(find(positionIdx(i,:)))~=0)
        mapsum(i) = mapsum(i) / length(find(positionIdx(i,:)))
    end
end

mAP = sum(mapsum)/length(mapsum)
clear mapsum