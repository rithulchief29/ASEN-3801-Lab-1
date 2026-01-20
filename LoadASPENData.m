function [t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename)

FullFileDataset = readmatrix(filename);

t_vec = FullFileDataset(:,1)./100;
pos_av_aspen = FullFileDataset(:, [11,12,13])';
att_av_aspen = FullFileDataset(:, [8,9,10])';
pos_tar_aspen = FullFileDataset(:, [5,6,7])';
att_tar_aspen = FullFileDataset(:, [2,3,4])';

[av_pos_inert, av_att, tar_pos_inert, tar_att] = ConvertASPENData(pos_av_aspen, att_av_aspen,  pos_tar_aspen, att_tar_aspen);

av_pos_inert = av_pos_inert./1000;
tar_pos_inert = tar_pos_inert./1000;

end
