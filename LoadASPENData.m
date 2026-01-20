function [t_vec, av_pos_inert, av_att, tar_pos_inert, tar_att] = LoadASPENData(filename)

FullFileDataset = readmatrix(filename,'NumHeaderLines',5);

t_vec = FullFileDataset(:,1)./100;
pos_av_aspen = FullFileDataset(:, [12,13,14]);
att_av_aspen = FullFileDataset(:, [9,10,11]);
pos_tar_aspen = FullFileDataset(:, [6,7,8]);
att_tar_aspen = FullFileDataset(:, [3,4,5]);

[av_pos_inert, av_att, tar_pos_inert, tar_att] = ConvertASPENData(pos_av_aspen, att_av_aspen,  pos_tar_aspen, att_tar_aspen);

av_pos_inert = av_pos_inert./1000;
tar_pos_inert = tar_pos_inert./1000;

end
