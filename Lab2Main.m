
%% Housekeeping
clc
clear all
close all

%% Load and convert data

filename = '3801_Sec002_Test1_Cleaned.csv';

[t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename);

% On the same figure, plot the 3D position of both objects in frame 𝑁𝑁; draw the aerospace vehicle’s path
% in solid blue and the target’s path in dashed red. Label all axes and include a legend. Be sure to follow
% the plotting best practices presented in Lab 1.

figure; 
hold on;
plot3(av_pos_inert(1,:),av_pos_inert(2,:),av_pos_inert(3,:), '--r');
plot3(tar_pos_inert(1,:),tar_pos_inert(2,:),tar_pos_inert(3,:), '-b');
grid on;
