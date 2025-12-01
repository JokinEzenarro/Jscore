function SW=smoothing_window(X)
%Calculate size of smoothing window based on the resolution of the dataset
    %Find min and max points of average spectrum by derivating
    Xdiff=diff(mean(X,1),1);
    z=zeros(1,size(Xdiff,2));
    for i=1:size(z,2)-1
        if Xdiff(1,i)<0 && Xdiff(1,i+1)>0 || Xdiff(1,i)>0 && Xdiff(1,i+1)<0
            z(1,i)=1;
        end
    end
    %Calculate average number of points between zeros (max and mins)
    memory=0;
    counts=1;
    for i=1:size(z,2)
        if z(1,i)==1
            intervals(1,counts)=i-memory;
            memory=i;
            counts=counts+1;
        end
    end
    %Nearest odd integer
    SW=mean(intervals);
    idx = mod(SW,2)<1;
    SW = floor(SW);
    SW(idx) = SW(idx)+1;
end