% multiViewAdjuster(3, 10, 50, 0); 
% multiViewAdjuster(3, 41, 69, 1); 
% multiViewAdjuster(4, 50, 198, 2); 
% multiViewAdjuster(18, 90, 151, 1); 
% multiViewAdjuster(18, 148, 230, 2); 
% multiViewAdjuster(18, 90, 230, 3);
% altMultiView(3, 10, 50, 0);
% multiViewAdjuster(3, 90, 95, 1);
% seq3;
system("rm errors.txt");
altMultiView(3, 41, 132, 1);
computeErrors(3, 41, 132, 1);
seq3;
computeErrors(3, 41, 132, 1);
% computeErrors(4, 50, 198, 2);
% computeErrors(18, 90, 151, 1);
% computeErrors(18, 148, 230, 2);
% computeErrors(18, 90, 230, 3);
importdata("errors.txt")