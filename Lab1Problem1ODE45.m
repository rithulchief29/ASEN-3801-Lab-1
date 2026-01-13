% Contributors: Rhys Hanson
% Course number: ASEN 3801
% File name: AirRelativeVelocityVectorToWindAngles
% Created: 1/13/26

clc
clear all
close all

Initial_Condition = [1,1,1,1];
Duration = 20;
Tolerances = 1 * 10^-8;
Time_Span = [0 Duration];
Options = odeset(RelTol=Tolerances,AbsTol=Tolerances);


[Tout,Yout] = ode45(@ODEFUN,Time_Span,Initial_Condition, Options);

w = Yout(:,1);
x = Yout(:,2);
y = Yout(:,3);
z = Yout(:,4);


LabelTitles = ['w', 'x', 'y', 'z'];
figure;

for i = 1:4
    subplot(4,1,i)
    hold on;
    if i == 1
        title('w, x, y, and z Values w.r.t. Nondimensional Time')
    end
    grid on;
    plot(Tout,Yout(:,i))
    xlabel('Time (n.d.)');
    ylabel([LabelTitles(i), ' (n.d.)'])
    xlim(Time_Span)
end

%% Modification of Tol Values

tols = [(1*10^-2), (1*10^-4), (1*10^-6), (1*10^-8), (1*10^-10), (1*10^-12)];

for i = 1:length(tols)
    Options = odeset(RelTol=tols(i),AbsTol=tols(i));
    [Tout,Yout] = ode45(@ODEFUN,Time_Span,Initial_Condition, Options);

    w_TolModification(i,:) = Yout(:,1);
    x_TolModification(i,:) = Yout(:,2);
    y_TolModification(i,:) = Yout(:,3);
    z_TolModification(i,:) = Yout(:,4);
end

for i = 1:(length(tols) - 1)
    w_TolDifference(i) = w_TolModification(i, end) - w_TolModification(end, end);
    x_TolDifference(i) = x_TolModification(i, end) - x_TolModification(end, end);
    y_TolDifference(i) = y_TolModification(i, end) - y_TolModification(end, end);
    z_TolDifference(i) = z_TolModification(i, end) - z_TolModification(end, end);
end

%% Functions 

function dYdt = ODEFUN(Tout,Yout)

%
% Inputs: velocity_body = column vector of aircraft air-relative velocity in
% body coordinates
% = [u,v,w]’
%
% Outputs: wind_angles = [speed beta alpha]’
% speed = aircraft airspeed
% beta = side slip angle
% alpha = angle of attack
%
% Methodology: Use definitions to calculate wind angles and speed from velocity
% vector

    w = Yout(1);
    x = Yout(2);
    y = Yout(3);
    z = Yout(4);
    
    W_dot = -9*w + y;
    X_dot = 4*w*x*y - x^2;
    Y_dot = 2*w - x - 2*z;
    Z_dot = x*y - y^2 - 3 * z^3;

    dYdt = [W_dot; X_dot; Y_dot; Z_dot];
end