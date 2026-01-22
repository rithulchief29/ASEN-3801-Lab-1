% Contributors: Rhys Hanson
% Course number: ASEN 3801
% File name: ODE Solver for Lab 1 Problem 1
% Created: 1/13/26

clc
clear all
close all

Initial_Condition = [1,1,1,1]; % Set up nonzero initial condition vector
Duration = 20; % Set up time duration of nondimensional time units
Tolerances = 1 * 10^-8; % Specifies the tolerance to be used for ODE45
Time_Span = [0 Duration]; % Set up the timespan vector
Options = odeset(RelTol=Tolerances,AbsTol=Tolerances); % Set the tolerances specified above


[Tout,Yout] = ode45(@ODEFUN,Time_Span,Initial_Condition, Options); % Run ODE45 w initial condition, W,X,Y, and Z functions, timespan, and tolerances

% Extract W, X, Y, and Z
w = Yout(:,1); 
x = Yout(:,2);
y = Yout(:,3);
z = Yout(:,4);


LabelTitles = ['w', 'x', 'y', 'z']; % Create y axis label vector
figure;

for i = 1:4 % Plot each variable on a new subplot
    subplot(4,1,i)
    hold on;
    if i == 1
        title('w, x, y, and z Values w.r.t. Nondimensional Time') % Plot title only on first subplot
    end
    grid on;
    plot(Tout,Yout(:,i)) % Plot W, X, Y, and Z
    if i == 4
        xlabel('Time (n.d.)'); % Specificy time units on last subplot.
    end
    ylabel([LabelTitles(i), ' (n.d.)']) % Write in w, x, y, and z labels
    xlim(Time_Span) % Set x time limit.
end

%% Modification of Tol Values

tols = [(1*10^-2), (1*10^-4), (1*10^-6), (1*10^-8), (1*10^-10), (1*10^-12)]; % Set up vector of tolerances

for i = 1:length(tols) % Iterate through tolerances
    Options = odeset(RelTol=tols(i),AbsTol=tols(i)); % Set tolerances for each iteration
    [Tout,Yout] = ode45(@ODEFUN,Time_Span,Initial_Condition, Options); % Run ODE45 with each tolerance

    % Store tolerances in a cell array for each iteration
    w_TolModification{i}(:) = Yout(:,1);
    x_TolModification{i}(:) = Yout(:,2);
    y_TolModification{i}(:) = Yout(:,3);
    z_TolModification{i}(:) = Yout(:,4);
end

for i = 1:(length(tols) - 1) % For each of the tolerences except 10^-12 calculate the table values for w,x,y, and z.
    TolDifferences(1,i) = w_TolModification{i}(end) - w_TolModification{end}(end);
    TolDifferences(2,i) = x_TolModification{i}(end) - x_TolModification{end}(end);
    TolDifferences(3,i) = y_TolModification{i}(end) - y_TolModification{end}(end);
    TolDifferences(4,i) = z_TolModification{i}(end) - z_TolModification{end}(end);
end


%% Functions 

function dYdt = ODEFUN(Tout,Yout) % ODE45 derivative function call

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

    w = Yout(1); % Set W to the input W value from ODE45
    x = Yout(2); % Set X to the input X value from ODE45
    y = Yout(3); % Set Y to the input Y value from ODE45
    z = Yout(4); % Set Z to the input Z value from ODE45
    
    W_dot = -9*w + y; % Calculate change in W
    X_dot = 4*w*x*y - x^2; % Calculate change in X
    Y_dot = 2*w - x - 2*z; % Calculate change in Y
    Z_dot = x*y - y^2 - 3 * z^3; % Calculate change in Z

    dYdt = [W_dot; X_dot; Y_dot; Z_dot]; % Return the change values for use by ODE45
end