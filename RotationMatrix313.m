function DCM = RotationMatrix313(attitude313)
% Goal : Use the Euler angles for the 3-1-3 rotation sequence to calculate 
%   the associated DCM
% Inputs : attitude313: 3 x 1 vector with the 3-1-3 Euler angles in the 
%   form attitude313 = [𝛼, 𝛽, 𝛾]T
% outputs: DCM: the rotation matrix calculated from the Euler angles.

alpha = attitude313(1); % assigns angle alpha to 1st row 1st column,[radians]
beta = attitude313(2); % assigns angle alpha to 1st row 1st column ,[radians]
gamma = attitude313(3);% assigns angle alpha to 1st row 1st column ,[radians]

R3 = @(angle)[ cos(angle), sin(angle), 0;
            -1*sin(angle), cos(angle), 0;
                        0, 0 , 1]; % anonymous function to calculate R_3 matrix of an angle
R1 = @(angle)[ 1, 0, 0;
               0, cos(angle), sin(angle);
               0, -1*sin(angle), cos(angle)];% anonymous function to calculate R_1 matrix of an angle

R3_alpha = R3(alpha);% R_3 matrix of euler angle alpha
R1_beta = R1(beta);% R_1 matrix of euler angle beta
R3_gamma = R3(gamma); % R_3 matrix of euler angle gamma

DCM = R3_alpha*R1_beta*R3_gamma;% 3x3 DCM matrix 
end
