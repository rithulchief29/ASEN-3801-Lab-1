%Contributor: Colby Muchlinski
%Class: ASEN 3801
%FileName: EulerAngles321.m
%Created on: 1/20/2026


function attitude321 = EulerAngles321(DCM)


%Inputs:
%DCM: the rotation Matrix calculated from the Euler Angles

%Outputs:
%attitude321 = 3 x 1 vector with the 3-2-1 Euler angles in the form
% [alpha, beta, gamma]'

%Methodology: Use DCM elements to find Euler Angles



R11=DCM(1,1);
R12=DCM(1,2);
R13=DCM(1,3);
R21=DCM(2,1);
R22=DCM(2,2);
R23=DCM(2,3);
R31=DCM(3,1);
R32=DCM(3,2);
R33=DCM(3,3);

alpha = atan2(R23,R33);
beta = -asin(R13);
gamma = atan2(R12,R11);

attitude321 = [alpha,beta,gamma];




end