%Contributor: Colby Muchlinski
%Class: ASEN 3801
%FileName: RotationMatrix321.m
%Created on: 1/20/2026


function DCM = RotationMatrix321(attitude321)
%Inputs:
%attitude321 = 3 x 1 vector with the 3-2-1 Euler angles in the form
% [alpha, beta, gamma]'

%Outputs:
%DCM: the rotation Matrix calculated from the Euler Angles

%Methodology: Multiple Euler Angle Matrices together to get the DCM


alpha = attitude321(1);
beta = attitude321(2);
gamma = attitude321(3);

R1alpha = [1 0 0; 0 cos(alpha) sin(alpha); 0 -sin(alpha) cos(alpha)];

R2beta = [cos(beta) 0 -sin(beta); 0 1 0; sin(beta) 0 cos(beta)];

R3gamma = [cos(gamma) sin(gamma) 0; -sin(gamma) cos(gamma) 0; 0 0 1];

DCM = R1alpha*R2beta*R3gamma;