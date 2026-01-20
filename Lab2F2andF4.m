clear;
clc;
close all;




function DCM = RotationMatrix321(attitude321)

alpha = attitude321(1);
beta = attitude321(2);
gamma = attitude321(3);

R1alpha = [1 0 0; 0 cos(alpha) sin(alpha); 0 -sin(alpha) cos(alpha)];

R2beta = [cos(beta) 0 -sin(beta); 0 1 0; sin(beta) 0 cos(beta)];

R3gamma = [cos(gamma) sin(gamma) 0; -sin(gamma) cos(gamma) 0; 0 0 1];

DCM = R1alpha*R2beta*R3gamma;


end

function attitude321 = EulerAngles321(DCM)


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