
%% Housekeeping
clc
clear all
close all

%% Load and convert data

filename = '3801_Sec002_Test1.csv';

[t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename);
