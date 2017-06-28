%MULTINET.M 
%   Generates a random matrices and runs the test MULTINETTEST.m to see if 
%   the associated network is ideal.

%% Parameters
p = .9;  %prob that a connection exists
L = [100, 100];  %array containing the number of agents in the first layers
ags = 200;  %max num of third layer agents
s = 2000;  %number of simulations
ideal = 0;  %how many of the sims produce ideal networks
idealAmount = zeros(1, ags);  %array for varying the third layer agent num

%% Simulations
for j = 1:ags  %go through the number of first layer agents
%         j
        for i = 1:s  % run this many samples
            %first randomly produce the connection matrix
            C1 = double( rand(L(2),L(1)) < p);  %layer 1 to 2
            C2 = double( rand(j,L(2)) < p);  %layer 2 to 3
            
            %Delete obselete agents from layer 3 by looking at C2 and
            %deleting the rows of zero, because these are just agents that
            %don't receive any info from layer 2 and so are disregarded.
            zerocheckC2 = sum(C2,2);
            if j > 1
                for k = j:-1:1  %from right to left to count removals
                    if zerocheckC2(k) == 0  %if this agent receives no info
                        C2(k,:) = []; %delete this row
                    end
                end
            end

            %Run test for ideal network on the cleaned connection matrices.
            ideal = ideal + MultiNetTest( C1, C2);
        end
        
        idealAmount(j) = ideal/s;  %store this probability
        ideal = 0;
end

save('ideal100p9.mat','idealAmount');

