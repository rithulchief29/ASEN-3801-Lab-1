clc
clear all
close all

filename ='3801_Sec002_Test2_Cleaned.csv';

FullFileDataset = readmatrix(filename); % Reads the datasheet from the prvided CSV file.

t_vec = FullFileDataset(:,1)./100; % Pulls time from the matrix of data and divides by 100 to convert from Hz to seconds.
pos_av_aspen = FullFileDataset(:, [11,12,13])'; % Pulls the 3 dimensional position data for the drone from the dataset.
att_av_aspen = FullFileDataset(:, [8,9,10])'; % Pulls the 3 dimensional helical angles for the drone's attitude.
pos_tar_aspen = FullFileDataset(:, [5,6,7])'; % Pulls the 3 dimensional position data for the target from the dataset.
att_tar_aspen = FullFileDataset(:, [2,3,4])'; % Pulls the 3 dimensional helical angles for the target's attitude.

pos_av_aspen = pos_av_aspen./1000; % Converts position values from (mm) to (m) for the drone.
pos_tar_aspen = pos_tar_aspen./1000; % Converts position values from (mm) to (m) for the target.

AV_Position = any(pos_av_aspen ~= 0, 1);
Tar_Position = any(pos_tar_aspen ~= 0, 1);
AV_Att = any(att_av_aspen ~= 0, 1);
Tar_Att = any(att_tar_aspen ~= 0, 1);

%% Questions 3

%Data set 3
x = figure();
plot3(pos_av_aspen(1,AV_Position), pos_av_aspen(2,AV_Position), pos_av_aspen(3,AV_Position),'-b',LineWidth = 1);
hold on
plot3(pos_tar_aspen(1,Tar_Position), pos_tar_aspen(2,Tar_Position), pos_tar_aspen(3,Tar_Position), '--r',LineWidth = 1);
hold off

xlabel('X-Position (m)');
ylabel('Y-Position(m)');
zlabel('Z-Position (m)');
title('A/V Position vs Target Position from Test 3 in the N Frame');
legend("A/V Path", "Target Path")
grid on;
saveas(x,'Q3.jpg')

%% Question 4

[t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename);

AV_Position = any(av_pos_inert ~= 0, 1);
Tar_Position = any(tar_pos_inert ~= 0, 1);
AV_Att = any(av_att ~= 0, 1);
Tar_Att = any(tar_att ~= 0, 1);

%Figure 1

%Data set 3 position vector as a function of time
x = figure();

subplot(3,1,1);
plot(t_vec(AV_Position), av_pos_inert(1,AV_Position), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Position), tar_pos_inert(1,Tar_Position), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('X Position (m)');
title('Position X vs Time for Data Set 3');
legend("A/V Position", "Target Position");

subplot(3,1,2);
plot(t_vec(AV_Position), av_pos_inert(2,AV_Position), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Position), tar_pos_inert(2,Tar_Position), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Y Position (m)');
title('Position Y vs Time for Test 3');
legend("A/V Position", "Target Position");

subplot(3,1,3);
plot(t_vec(AV_Position), av_pos_inert(3,AV_Position), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Position), tar_pos_inert(3,Tar_Position), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Z Position (m)');
title('Position Z vs Time for Test 3');
legend("A/V Position", "Target Position");

saveas(x,'Q41.jpg')

%figure 2
%Data set 3 Euler angles as a function of time
x = figure();

subplot(3,1,1);
plot(t_vec(AV_Att), (av_att(1,AV_Att).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Att), (tar_att(1,Tar_Att).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Phi (degree)');
title('Phi vs Time for Test 3');
legend("A/V Angle", "Target Angle");

subplot(3,1,2);
plot(t_vec(AV_Att), (av_att(2,AV_Att).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Att), (tar_att(2,Tar_Att).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Theta (degree)');
title('Theta vs Time for Test 3');
legend("A/V Angle", "Target Angle");

subplot(3,1,3);
plot(t_vec(AV_Att), (av_att(3,AV_Att).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec(Tar_Att), (tar_att(3,Tar_Att).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Psi (degree)');
title('Psi vs Time for Test 3');
legend("A/V Angle", "Target Angle");

saveas(x,'Q42.jpg')

%% Question 5


DCM321av = zeros(3,3,length(av_att));
Euler313av = zeros(length(av_att),3);

av_pos_body = zeros(length(av_att),3);
tar_pos_avBody = zeros(length(av_att),3);

for i = 1:length(av_att)

    if AV_Position(i) == 1
        DCM321av(:,:,i) = RotationMatrix321(av_att(:,i));
        DCM321tar(:,:,i) = RotationMatrix321(tar_att(:,i));

        Euler313av(i,:) = EulerAngles313(DCM321av(:,:,i));
        Euler313tar(i,:) = EulerAngles313(DCM321tar(:,:,i));


        av_pos_body(i,:) = DCM321av(:,:,i)*av_pos_inert(:,i);
        tar_pos_avBody(i,:) = DCM321av(:,:,i)*tar_pos_inert(:,i);
    end
end


x=figure();

subplot(3,1,1);
plot(t_vec, (Euler313av(:,1).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec, (Euler313tar(:,1).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Phi (degree)');
title('Phi vs Time for Test 3');
legend("A/V Angle", "Target Angle", Location="northeast");

subplot(3,1,2);
plot(t_vec, (Euler313av(:,2).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec, (Euler313tar(:,2).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Theta (degree)');
title('Theta vs Time for Test 3');
legend("A/V Angle", "Target Angle", Location="northeast");

subplot(3,1,3);
plot(t_vec, (Euler313av(:,3).*(180/pi)), 'b', LineWidth=1);
hold on
plot(t_vec, (Euler313tar(:,3).*(180/pi)), '--r', LineWidth=1);
hold off
xlabel('Time (s)');
ylabel('Psi (degree)');
title('Psi vs Time for Test 3');
legend("A/V Angle", "Target Angle", Location="northeast");

saveas(x,'Q5.jpg')

%% Question 6


pos_vec_tar = tar_pos_inert - av_pos_inert;
pos_vec_tar = pos_vec_tar';

x=figure();
plot(t_vec, pos_vec_tar(:,1), LineWidth=1);
hold on
plot(t_vec, pos_vec_tar(:,2), LineWidth=1);
plot(t_vec, pos_vec_tar(:,3), LineWidth=1);
hold off

xlabel('Time (s)');
ylabel('Target Position');
title('Position of the Target Relative to the Aerospace Vehicle, Inertial Frame');
legend("X position", "Y position", "Z position")
grid on;

saveas(x,'Q6.jpg')
%% Question 7


rel_loc_body = tar_pos_avBody - av_pos_body;


x=figure();
plot(t_vec,rel_loc_body)
xlabel('Time (s)');
ylabel('Target Position');
title('Position of the Target Relative to the Aerospace Vehicle, Aircraft Body Frame');
legend("X position", "Y position", "Z position")
grid on;

saveas(x,'Q7.jpg')