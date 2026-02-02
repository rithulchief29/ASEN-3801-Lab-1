% Contributors: Rhys Hanson, Alonso Jimenes Hernandez, Colby Muchlinski,
% Rithul Rengarajan
% Course number: ASEN 3801
% File name: Lab_2
% Created: 1/20/26

clc
clear all
close all

filename ='3801_Sec002_Test3_Cleaned.csv'; % Reads data in from cleaned file (removed headers and column 2)

FullFileDataset = readmatrix(filename); % Reads the datasheet from the prvided CSV file.

t_vec = FullFileDataset(:,1)./100; % Pulls time from the matrix of data and divides by 100 to convert from Hz to seconds.
pos_av_aspen = FullFileDataset(:, [11,12,13])'; % Pulls the 3 dimensional position data for the drone from the dataset.
att_av_aspen = FullFileDataset(:, [8,9,10])'; % Pulls the 3 dimensional helical angles for the drone's attitude.
pos_tar_aspen = FullFileDataset(:, [5,6,7])'; % Pulls the 3 dimensional position data for the target from the dataset.
att_tar_aspen = FullFileDataset(:, [2,3,4])'; % Pulls the 3 dimensional helical angles for the target's attitude.

pos_av_aspen = pos_av_aspen./1000; % Converts position values from (mm) to (m) for the drone.
pos_tar_aspen = pos_tar_aspen./1000; % Converts position values from (mm) to (m) for the target.

AV_Position = any(pos_av_aspen ~= 0, 1); % Checks for anomolous zero values in the aircraft position.
Tar_Position = any(pos_tar_aspen ~= 0, 1); % Checks for anomolous zero values in the target position.

%% Questions 3

%Data set 3
x = figure(); % Figure to plot aircraft and target positions 
plot3(pos_av_aspen(1,AV_Position), pos_av_aspen(2,AV_Position), pos_av_aspen(3,AV_Position),'-b',LineWidth = 1); % Plots aircraft position in time.
hold on
plot3(pos_tar_aspen(1,Tar_Position), pos_tar_aspen(2,Tar_Position), pos_tar_aspen(3,Tar_Position), '--r',LineWidth = 1); % Plots target position in time.
hold off

xlabel('X-Position (m)'); % Adds x, y, and z labels for position
ylabel('Y-Position(m)');
zlabel('Z-Position (m)');
title('A/V Position vs Target Position from Test 3 in the N Frame'); % Adds title
% legend("A/V Path", "Target Path") % Adds legend
grid on; % Enables grid.
saveas(x,'Q3.jpg') % Saves the figure as a JPG

%% Question 4

[t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename); % Loads converted data from LooadASPENData function (which itself calls ConvertASPENData)

AV_Position = any(av_pos_inert ~= 0, 1); % Re-checks for anomolous zero values for the drone
Tar_Position = any(tar_pos_inert ~= 0, 1); % Re-checks for anomolous zero values for the target

%Find where attidudes are not anomolous.
AV_Att = any(av_att ~= 0, 1); 
Tar_Att = any(tar_att ~= 0, 1); 

%Data set 3 position vector as a function of time
x = figure();

subplot(3,1,1); % Plots drone and target x position in time.
plot(t_vec(AV_Position), av_pos_inert(1,AV_Position), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Position), tar_pos_inert(1,Tar_Position), '--r', LineWidth=1);
grid on
hold off
xlabel('Time (s)');
ylabel('X Position (m)');
title('Position X vs Time for Data Set 3');
legend("A/V Position", "Target Position");

subplot(3,1,2); % Plots drone and target y position in time.
plot(t_vec(AV_Position), av_pos_inert(2,AV_Position), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Position), tar_pos_inert(2,Tar_Position), '--r', LineWidth=1);
grid on
hold off
xlabel('Time (s)');
ylabel('Y Position (m)');
title('Position Y vs Time for Test 3');
% legend("A/V Position", "Target Position");

subplot(3,1,3); % Plots drone and target z position in time.
plot(t_vec(AV_Position), av_pos_inert(3,AV_Position), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Position), tar_pos_inert(3,Tar_Position), '--r', LineWidth=1);
grid on
hold off
xlabel('Time (s)');
ylabel('Z Position (m)');
title('Position Z vs Time for Test 3');
% legend("A/V Position", "Target Position");

saveas(x,'Q41.jpg') % Saves figure for use in report.

%figure 2
%Data set 3 Euler angles as a function of time
x = figure();

subplot(3,1,1); % Plots drone and target phi euler angle in time.
plot(t_vec(AV_Att), (av_att(1,AV_Att).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Att), (tar_att(1,Tar_Att).*(180/pi)), '--r', LineWidth=1);
grid on
hold off
xlabel('Time (s)');
ylabel('Phi (degree)');
title('Phi vs Time for Test 3');
legend("A/V Angle", "Target Angle");

subplot(3,1,2); % Plots drone and target theta euler angle in time.
plot(t_vec(AV_Att), (av_att(2,AV_Att).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Att), (tar_att(2,Tar_Att).*(180/pi)), '--r', LineWidth=1);
grid on
hold off
xlabel('Time (s)');
ylabel('Theta (degree)');
title('Theta vs Time for Test 3');
% legend("A/V Angle", "Target Angle");

subplot(3,1,3); % Plots drone and target psi euler angle in time.
plot(t_vec(AV_Att), (av_att(3,AV_Att).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Att), (tar_att(3,Tar_Att).*(180/pi)), '--r', LineWidth=1);
grid on
hold off
xlabel('Time (s)');
ylabel('Psi (degree)');
title('Psi vs Time for Test 3');
% legend("A/V Angle", "Target Angle");

saveas(x,'Q42.jpg') % Saves figure for use in report

%% Question 5

% Preallocate the DCM321 and Euler 313 arrays
DCM321av = zeros(3,3,length(av_att));
Euler313av = zeros(length(av_att),3);
% Preallocates aircraft position and target position arrays
av_pos_body = zeros(length(av_att),3);
tar_pos_avBody = zeros(length(av_att),3);

for i = 1:length(av_att)

    if AV_Position(i) == 1 % If aircraft position in nonzero
        DCM321av(:,:,i) = RotationMatrix321(av_att(:,i)); % Calculates 321 DCM for drone
        DCM321tar(:,:,i) = RotationMatrix321(tar_att(:,i)); % Calculates 321 DCM for target

        Euler313av(i,:) = EulerAngles313(DCM321av(:,:,i)); % Calculates Euler angles for 313 for drone 
        Euler313tar(i,:) = EulerAngles313(DCM321tar(:,:,i)); % Calculates Euler angles for 313 for target

        av_pos_body(i,:) = DCM321av(:,:,i)*av_pos_inert(:,i); % Calculates aircraft body position for 321 case
        tar_pos_avBody(i,:) = DCM321av(:,:,i)*tar_pos_inert(:,i); % Calculates target body position for 321 case
    end
end


x=figure(); % Figure to plot euler angles in degrees as function of time for target and drone

subplot(3,1,1);
plot(t_vec, (Euler313av(:,1).*(180/pi)), 'b', LineWidth=1); % Plot phi Euler angle for drone.
hold on
plot(t_vec, (Euler313tar(:,1).*(180/pi)), '--r', LineWidth=1); % Plot phi Euler angle for target.
grid on
hold off
xlabel('Time (s)');
ylabel('Phi (degree)');
title('Phi vs Time for Test 3');
legend("A/V Angle", "Target Angle", Location="northeast");

subplot(3,1,2);
plot(t_vec, (Euler313av(:,2).*(180/pi)), 'b', LineWidth=1); % Plot theta Euler angle for drone.
hold on
plot(t_vec, (Euler313tar(:,2).*(180/pi)), '--r', LineWidth=1); % Plot theta Euler angle for target.
grid on
hold off
xlabel('Time (s)');
ylabel('Theta (degree)');
title('Theta vs Time for Test 3');
% legend("A/V Angle", "Target Angle", Location="northeast");

subplot(3,1,3);
plot(t_vec, (Euler313av(:,3).*(180/pi)), 'b', LineWidth=1); % Plot psi Euler angle for drone.
hold on
plot(t_vec, (Euler313tar(:,3).*(180/pi)), '--r', LineWidth=1); % Plot psi Euler angle for target.
grid on
hold off
xlabel('Time (s)');
ylabel('Psi (degree)');
title('Psi vs Time for Test 3');
% legend("A/V Angle", "Target Angle", Location="northeast");

saveas(x,'Q5.jpg')

%% Question 6

pos_vec_tar = tar_pos_inert - av_pos_inert; % Calculates position vector of the target relative to the drone in time.
pos_vec_tar = pos_vec_tar';

x=figure(); % Plots position vector of target realtive to drone in time in x, y, and z.

PlotTitles = ['X', 'Y', 'Z'];
hold on


for i=1:3
    subplot(3,1,i)
    plot(t_vec, pos_vec_tar(:,i),'-r', LineWidth=1); % Plot x, y, and z distances.
    ylabel('Target Position (m)');
    xlabel('Time (s)');
    title(['Position of the Target Relative to the Aerospace Vehicle, ', PlotTitles(i), ' Direction']);
    grid on;
end






saveas(x,'Q6.jpg') % Save figure for report.
%% Question 7


rel_loc_body = tar_pos_avBody - av_pos_body; % Calculates the position vector of the target relative to the drone in the drone's body frame cords


x=figure(); % Plots position of target relative to drone in drone's body frame
hold on

for i=1:3
    subplot(3,1,i)
    plot(t_vec, rel_loc_body(:,i), '-r', LineWidth=1);
    ylabel('Target Position (m)');
    xlabel('Time (s)');
    title(['Position of the Target Relative to the Aerospace Vehicle, Body ', PlotTitles(i), ' Direction']);
    grid on;
end






saveas(x,'Q7.jpg')