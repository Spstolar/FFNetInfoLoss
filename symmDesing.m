function[x, y] = symmDesing(B)
%SYMMDESING  takes a SYMMETRIC matrix B, tests invertibility, then if it's 
%   not invertible removes as few row(i)+column(i) combinations as 
%   possible to get an  invertible matrix 
%   The resulting matrix is x, and y keeps track of what we removed.
y = [];  
WF = B;
[R, ~] = size(WF);
rkB = rank(B);


if rkB < R
    repaired = 0;
else
    repaired = 1;
    y = 0; %TODO: have y return [] instead to fix change MultiNetTest
end

if repaired == 0
    for c = R:-1:1
        WF(c,:) = [];
        WF(:,c) = [];
        if rank(WF) == rkB
            B = WF;
            y = [c y];
        else
            WF = B;
        end
    end
end

x = B;




