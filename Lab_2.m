clear; close all; clc;

data_1 = readmatrix("3801_Sec002_Test1.csv");
data_2 = readmatrix("3801_Sec002_Test2.csv");
data_3 = readmatrix("3801_Sec002_Test3.csv");

%% Questions 3

%Data set 3
figure();
plot3(data_3(:,11), data_3(:,12), data_3(:,13),'color', 'blue',LineWidth = 1);
hold on
plot3(data_3(:,5), data_3(:,6), data_3(:,7), '--r',LineWidth = 1);
hold off

xlabel('X-axis (mm)');
ylabel('Y-axis (mm)');
zlabel('Z-axis (mm)');
title('AV Position vs Target Position from Data 3');
legend("A/V Path", "Target Path")
grid on;

%% Question 4

time_3 = data_3(:,1)./100;

%Figure 1

%Data set 3 position vector as a function of time
figure();

subplot(3,1,1);
plot(time_3, data_3(:,5), 'b', LineWidth=1);
hold on
plot(time_3, data_3(:,11), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('X Position (mm)');
title('Position X vs Time for Data Set 3');
legend("A/V Position", "Target Position");

subplot(3,1,2);
plot(time_3, data_3(:,6), 'b', LineWidth=1);
hold on
plot(time_3, data_3(:,11), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Y Position (mm)');
title('Position Y vs Time for Data Set 3');
legend("A/V Position", "Target Position");

subplot(3,1,3);
plot(time_3, data_3(:,7), 'b', LineWidth=1);
hold on
plot(time_3, data_3(:,13), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Z Position (mm)');
title('Position Z vs Time for Data Set 3');
legend("A/V Position", "Target Position");

%figure 2
%Data set 3 Euler angles as a function of time
figure();

subplot(3,1,1);
plot(time_3, (data_3(:,2).*(180/pi)), 'b', LineWidth=1);
hold on
plot(time_3, (data_3(:,7).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Phi (degree)');
title('Phi vs Time for Data Set 3');
legend("A/V Angle", "Target Angle");

subplot(3,1,2);
plot(time_3, (data_3(:,3).*(180/pi)), 'b', LineWidth=1);
hold on
plot(time_3, (data_3(:,8).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Theta (degree)');
title('Theta vs Time for Data Set 3');
legend("A/V Angle", "Target Angle");

subplot(3,1,3);
plot(time_3, (data_3(:,4).*(180/pi)), 'b', LineWidth=1);
hold on
plot(time_3, (data_3(:,9).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Psi (degree)');
title('Psi vs Time for Data Set 3');
legend("A/V Angle", "Target Angle");

%% Question 5
