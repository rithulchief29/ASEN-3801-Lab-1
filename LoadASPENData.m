function [t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename)

% Inputs: filename = the name of the CSV file that contains the ASPEN drone and stationary target data. 
% 
%
% Outputs: t_vec = vector of time (s) from the camera system
% av_pos_inert = position vector of the drone in time (m)
% av_att = 3-2-1 Euler Attitude angles of the drone in time (rads)
% tar_pos_inert = position vector of the target in time (m)
% tar_att = 3-2-1 Euler Attitude angles of the target in time (rads)
% 
% Methodology: Extract the above data matricies from the provided file and
% cnvert them into the prooper units. Further calls ConvertASPENData to
% conver the data to x,y,z formatting (with z down) and to use the 3-2-1 Euler angles

FullFileDataset = readmatrix(filename); % Reads the datasheet from the prvided CSV file.

t_vec = FullFileDataset(:,1)./100; % Pulls time from the matrix of data and divides by 100 to convert from Hz to seconds.
pos_av_aspen = FullFileDataset(:, [11,12,13])'; % Pulls the 3 dimensional position data for the drone from the dataset.
att_av_aspen = FullFileDataset(:, [8,9,10])'; % Pulls the 3 dimensional helical angles for the drone's attitude.
pos_tar_aspen = FullFileDataset(:, [5,6,7])'; % Pulls the 3 dimensional position data for the target from the dataset.
att_tar_aspen = FullFileDataset(:, [2,3,4])'; % Pulls the 3 dimensional helical angles for the target's attitude.

[av_pos_inert, av_att, tar_pos_inert, tar_att] = ConvertASPENData(pos_av_aspen, att_av_aspen,  pos_tar_aspen, att_tar_aspen); % Calls ConvertASPENData to put the positions into the 'class' coordinate system and convert the helical angles to Euler angles.

av_pos_inert = av_pos_inert./1000; % Converts position values from (mm) to (m) for the drone.
tar_pos_inert = tar_pos_inert./1000; % Converts position values from (mm) to (m) for the target.

end
