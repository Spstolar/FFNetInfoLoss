function [ideal] = MultiNetTest( C1, C2)
%MULTINETTEST   Tests whether a network is ideal. 
% Receives the connection matrices C1 from layer 1 to layer 2,
% and C2 from layer 2 to layer 3.
% It first checks if C1 is ideal. If it is then it runs the calculation and
% then runs the calculation for 2. Returns whether or not the network is
% ideal.

%% Note
%C connection matrices:
%column i tells you who agent i sends info to
%C_ji = 1 if i -> j and 0 otherwise
%This code can be extended to larger networks without much difficulty.


%% Constants
L = [size(C1,2), size(C1, 1), size(C2,1)];  
%L is the vector that tell you how many agents are in each layer. L(i) is
%the number of agents in layer i, so L = [L(1) L(2) L(3)]

N = sum(L);  %total number of agents
K = length(L);  %number of layers


% First check if C1 is ideal.
if ( rank( C1 ) < rank( [ C1; ones(1,L(1)) ] ) )
    ideal = 0;
    return 
end

% If C1 is ideal we proceed, calculate the weight vectors, check those, and
% then do the same for C2.


%Delete the rows of zero, because the these are just agents that
%don't receive any info and so are disregarded.
zerocheck = sum(C1,2);
removals = 0;

for i = L(2):-1:1  %from right to left to count removals easier
    if zerocheck(i) == 0    %if this agent receives no info
        C1(i,:) = []; %delete its row
        C2(:,i) = []; %delete its column
        removals = removals + 1;  %change L2
    end
end

L(2) = L(2) - removals;

I = zeros(L(1),L(2));         %initial info matrix

%this gives the matrix whose column i tell you who agent i receives info from
TC = transpose(C1);

%We read the info matrix as the matrix of weights each agent gives to other
%agents. So the first L(1) entries of column i tell you how agent i weights
%the first layer agents and this tells us when we have an optimal network
%because the final row will have the first L(1) entries all equal to 1/L(1)

%define the info matrix for the second layer
for k = 1:L(2)
    for j = 1:L(1)
        inputs = sum(TC(:,k));
        I(j,k) = TC(j ,k)/inputs;
        %inputs is the number of top layer agents who send
        %estimate to this layer 2 agent. Won't be zero because we removed
        %the possibility of rows of zeros.
    end
end
    
Q = zeros( L(2) );  %This will be the cov matrix

for i = 1 :L(2)
    for j = 1:L(2)
        Q(i,j) = transpose(I(:,i))*I(:,j);
    end
end

Cov = Q;

W3 = zeros(L(1),L(3));

%% This section is where we set the weights in W^3 for each agent in L3

for thAg = 1 : L(3);
    %I is now the weight matrix W^2
    numIn = sum( C2(thAg, :) );
    inputs = [];
    
    for k = 1 : L(2)   %need to grab the indices for the inputs
        if C2(thAg, k) == 1
            inputs = [inputs k];
        end
    end
    
    Q = Cov( inputs, inputs);
    %Q is the RxR covariance matrix, which may be singular
    %Check if it's singular, and if it is de-singularize it, where we
    %keep track of what we removed from WF
    
    
    % rank(Q); isitsing = singcheck(Q); cond(Q); %<-- for debugging
    
    if rank(Q) < size(Q,1)    % checks if the matrix is singular
        [Q, removed] = symmDesing(Q);  % if it is singular, run the desingularization
        trim = 1;
    else
        trim = 0;
    end
    
    
    %Correction since WF might have been resized;
    inL2 = L(2);  %original number of inputs
    [L(2), ~] = size(Q);  %number of independent inputs
    
    %the sum of the entries of the inverse of the reduced covariance matrix
    b = (ones(1,L(2))/Q)*ones(L(2),1);  
    
    weights = (ones(1,L(2))/Q)/b;  % this comes out of min. var. est.
    % theory for how to get the optimal
    % estimate given covaried inputs
    
    fillw = zeros(1,numIn);  % now turn the weights for the independent
    % inputs into weights for all inputs
    
    %we have to add in some zeros if we reduced the covariance matrix
    if trim == 1 & size(Q) > 0
        p = 1;
        q = 1;
        weights = [weights, 0];
        removed = [removed, 0];
        for fillspot = 1:numIn
            if fillspot == removed(p)
                fillw(fillspot) = 0;
                if p == length(removed)
                    removed(p) = 0;
                else
                    p = p + 1;
                end
            else
                fillw(fillspot) = weights(q);
                q = q + 1;
            end
        end
        weights = fillw;
    end
   
    %we also have to add in some zeros for trimmed agents that did not
    %input
    if numIn < inL2 & size(Q) > 0
        fillw = zeros( 1, inL2 );
        q = 1;
        inputs = [inputs, 0];
        for p = 1:inL2
            if p == inputs(q)
                fillw(p) = weights(q);
                q = q+1;
            else
                fillw(p) = 0;
            end
        end
    end
    
    if size(Q) > 0
        weights = fillw;
        
        est = zeros(L(1),1);
        
        L(2) = inL2;
        
        for l = 1:L(2)
            est = est + weights(l)*I(:,l);
        end
        
        W3(:,thAg) = est;
    else
        W3(:,thAg) = zeros(L(1),1);
    end
    
end



%% Now use W3' and see simply if the vector of ones is in its rowspace
if ( rank( W3' ) < rank( [ W3'; ones(1,L(1)) ] ) )
    ideal = 0;
else
    ideal = 1;
end




end


