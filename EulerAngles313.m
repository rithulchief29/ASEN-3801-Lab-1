function attitude313 = EulerAngles313(DCM)
%{ 
Goal: use the DCM to extract the 3-1-3 Euler angles
Inputs: DCM: a 3x3 rotation matrix
Outputs: attitude313: 3 x 1 vector with the 3-1-3 Euler angles
            in the form attitude313 = [𝛼𝛼, 𝛽𝛽, 𝛾𝛾]T
%}
R13 = DCM(1,3); % i,jth element of the DCM
R23 = DCM(2,3);
R31 = DCM(3,1);
R32 = DCM(3,2);
R33 = DCM(3,3);
alpha = atan2(R13,R23); % numerator = Y , denominator = X , P = atan2(Y,X)
beta = acos(R33);
gamma = atan2(R31,-1*R32);% numerator = Y , denominator = X , P = atan2(Y,X)

attitude313 = [alpha,beta,gamma]'; % 3x1 vector of euler angles

end