Precision=calcAvgPerf(P_points, C, number_of_queries, filename);
Recall=[1:20]/20;

plot(Recall,Precision);
hold on;
plot(Recall,Precision,'*');
axis([0 1 0 1])
hold off;

xlabel('Precision'),ylabel('Recall')
