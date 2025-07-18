%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read a retrieval list for a query image (model names, distances).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S, R]=read_rank_list(filename,number_of_target)

fp=fopen(filename,'r');
%q{1}=fscanf(fp,'%s',1);
for i=1:number_of_target
    S{i,:}=fscanf(fp,'%lf',1);
    R{i,:}=fscanf(fp,'%s',1);
end
fclose(fp);

    
    