# FFNetInfoLoss
Code for the simulations in 'Loss of information in feedforward social networks'

The code to run is multinet.m. It generates matrices and calls multiNetNest.m to check whether the network for each matrix is ideal. The multiNetNest.m function calls symmDesing.m to remove redundancy in matrices and singCheck.m is included for debugging.

This code is specifically for 4-layer networks but can be modified for networks with more layers by creating a loop in multiNetTest.m. 3-layer networks are simply tested by whether or not the vector of ones is in the row space of the randomly generated matrix, so running this can be done by cutting the related fragment.

More detail:
MULTINET.M 
%   Generates a random matrices and runs the test MULTINETTEST.m to see if 
%   the associated network is ideal.

%MULTINETTEST   Tests whether a network is ideal. 
% Receives the connection matrices C1 from layer 1 to layer 2,
% and C2 from layer 2 to layer 3.
% It first checks if C1 is ideal. If it is then it runs the calculation and
% then runs the calculation for 2. Returns whether or not the network is
% ideal.

%SYMMDESING  takes a SYMMETRIC matrix B, tests invertibility, then if it's 
%   not invertible removes as few row(i)+column(i) combinations as 
%   possible to get an  invertible matrix 
%   The resulting matrix is x, and y keeps track of what we removed.

debugging
%SINGCHECK Returns a multi-method check for singularity.
%   Take a matrix B. First do a quick check to see if any of its 
%   eigenvalues are zero. Then if it passes that, do a more rigorous check
%   on the condition number. Return 1 if not singular, and 0 else.
