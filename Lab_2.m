clc;
clear all;
close all;

filename ='3801_Sec002_Test3.csv';

[t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename);


%% Questions 3

%Data set 3
figure();
plot3(av_pos_inert(1,:), av_pos_inert(2,:), av_pos_inert(3,:),'color', 'blue',LineWidth = 1);
hold on
plot3(tar_pos_inert(1,:), tar_pos_inert(2,:), tar_pos_inert(3,:), '--r',LineWidth = 1);
hold off

xlabel('X-axis (m)');
ylabel('Y-axis (m)');
zlabel('Z-axis (m)');
title('AV Position vs Target Position from Test 3');
legend("A/V Path", "Target Path")
grid on;

%% Question 4

%Figure 1

%Data set 3 position vector as a function of time
figure();

subplot(3,1,1);
plot(t_vec, av_pos_inert(1,:), 'b', LineWidth=1);
hold on
plot(t_vec, tar_pos_inert(1,:), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('X Position (m)');
title('Position X vs Time for Data Set 3');
legend("A/V Position", "Target Position", Location="northeastoutside");

subplot(3,1,2);
plot(t_vec, av_pos_inert(2,:), 'b', LineWidth=1);
hold on
plot(t_vec, tar_pos_inert(2,:), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Y Position (m)');
title('Position Y vs Time for Test 3');
legend("A/V Position", "Target Position", Location="northeastoutside");

subplot(3,1,3);
plot(t_vec, av_pos_inert(3,:), 'b', LineWidth=1);
hold on
plot(t_vec, tar_pos_inert(3,:), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Z Position (m)');
title('Position Z vs Time for Test 3');
legend("A/V Position", "Target Position", Location="northeastoutside");

%figure 2
%Data set 3 Euler angles as a function of time
figure();

subplot(3,1,1);
plot(t_vec, (av_att(1,:).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec, (tar_att(1,:).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Phi (degree)');
title('Phi vs Time for Test 3');
legend("A/V Angle", "Target Angle", Location="northeastoutside");

subplot(3,1,2);
plot(t_vec, (av_att(2,:).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec, (tar_att(2,:).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Theta (degree)');
title('Theta vs Time for Test 3');
legend("A/V Angle", "Target Angle", Location="northeastoutside");

subplot(3,1,3);
plot(t_vec, (av_att(3,:).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec, (tar_att(3,:).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Psi (degree)');
title('Psi vs Time for Test 3');
legend("A/V Angle", "Target Angle", Location="northeastoutside");

%% Question 6


pos_vec_tar = tar_pos_inert - av_pos_inert;
pos_vec_tar = pos_vec_tar';

figure();
plot(t_vec, pos_vec_tar(:,1), LineWidth=1);
hold on
plot(t_vec, pos_vec_tar(:,2), LineWidth=1);
plot(t_vec, pos_vec_tar(:,3), LineWidth=1);
hold off

xlabel('time (s)');
ylabel('Target Position');
title('Position of the target relative to the aerospace vehicle,');
legend("X position", "Y position", "Z position")
grid on;

