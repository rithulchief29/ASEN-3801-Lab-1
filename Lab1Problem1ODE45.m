% Contributors: Rhys Hanson
% Course number: ASEN 3801
% File name: ODE Solver for Lab 1 Problem 1
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
    if i == 4
        xlabel('Time (n.d.)');
    end
    ylabel([LabelTitles(i), ' (n.d.)'])
    xlim(Time_Span)
end

%% Modification of Tol Values

tols = [(1*10^-2), (1*10^-4), (1*10^-6), (1*10^-8), (1*10^-10), (1*10^-12)];

for i = 1:length(tols)
    Options = odeset(RelTol=tols(i),AbsTol=tols(i));
    [Tout,Yout] = ode45(@ODEFUN,Time_Span,Initial_Condition, Options);

    w_TolModification{i}(:) = Yout(:,1);
    x_TolModification{i}(:) = Yout(:,2);
    y_TolModification{i}(:) = Yout(:,3);
    z_TolModification{i}(:) = Yout(:,4);
end

for i = 1:(length(tols) - 1)
    TolDifferences(1,i) = w_TolModification{i}(end) - w_TolModification{end}(end);
    TolDifferences(2,i) = x_TolModification{i}(end) - x_TolModification{end}(end);
    TolDifferences(3,i) = y_TolModification{i}(end) - y_TolModification{end}(end);
    TolDifferences(4,i) = z_TolModification{i}(end) - z_TolModification{end}(end);
end


%% Functions 

function dYdt = ODEFUN(Tout,Yout)

%
% Inputs: Input time value and input values of w,x,y, and z at that time.
%
% Outputs: 
% dYdt = Vector of change in w, x, y, and z at any given time.
% 
%
% Methodology: Plug in the known values of w,x,y, and z in order to
% calculate the change in those functions with respect to time which can
% then be used with the ODE45 function.

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