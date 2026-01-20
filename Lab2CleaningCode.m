filename = '3801_Sec002_Test1.csv';

FullFileDataset = readmatrix(filename, "NumHeaderLines", 5);

A = FullFileDataset(:,[1,3:14]);

writematrix(A,'3801_Sec002_Test1_Cleaned.csv');