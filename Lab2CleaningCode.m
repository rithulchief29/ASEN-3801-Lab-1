filename = '3801_Sec002_Test3.csv';

FullFileDataset = readmatrix(filename, "NumHeaderLines", 5);

A = FullFileDataset(:,[1,3:13]);

writematrix(A,'3801_Sec002_Test3_Cleaned.csv');