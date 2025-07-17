%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     The evaluation code for 
%%%             2D Scene Image-Based 3D Scene Retrieval   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input:
%       rank list files (training or testing dataset by changing the 3rd
%       clause)
%       
%       classification files (training or testing dataset, target model dataset) 

%Output:
%       Precision Recall performance                         -- "PR.txt"
%       Other performance metrics (each model and average)   -- "Stats.txt"

%Evaluation measures:
%       NN, 1-Tier, 2-Tier, e_Measure, DCG

%Author: Juefei Yuan
%Email: juefei.yuan@gmail.com
%Date: August 7, 2018
%@University of Southern Mississippi, Mississippi, US



%Please cite:
% XXXXXXXXXXXXXXXXXXXXXX  % SHREC'18 -- 2D Scene Image-Based 3D Scene Retrieval, 3DOR'18, 2018

%Note: please note the comments started with "%Change..." to adjust to your
%cases

clear all;
clc

[imageclass, Ns]=read_classification_file('SceneIBR_Image_ALL.cla');

[modelclass,N]=read_classification_file('SceneIBR_Model_ALL.cla');

number_of_queries=size(imageclass,1);
number_of_target=size(modelclass,1);
number_of_classes=size(N,1);
  
for qqq=1:number_of_queries 
    for ccc=1:number_of_classes
        if (strcmp(imageclass{qqq,2},N{ccc,1})==1)
            C(qqq,1)=N{ccc,2};
            break;
        end
    end
end
   
%Change to the folder that contains all your rank list files accordingly
RANK_DIR='JuefeiYuan\';



P_points=zeros(number_of_queries,max(C));
Av_Precision=zeros(1,number_of_queries); 
NN=zeros(1,number_of_queries);
FT=zeros(1,number_of_queries);
ST=zeros(1,number_of_queries);
dcg=zeros(1,number_of_queries);
E=zeros(1,number_of_queries);
filename=[RANK_DIR 'Stats.txt'];
fid=fopen(filename,'w');
fprintf(fid,'        NN     FT     ST      E       DCG\n');
fclose(fid); 

for qqq=4:number_of_queries    
    query_name=imageclass{qqq,1};
    filename=[RANK_DIR query_name];
    
    [S, R]=read_rank_list(filename,number_of_target);

    query_class=imageclass{qqq,2};
    
    retrieved_class=cell(1,length(R));
    G=zeros(1,number_of_target);
    for r=1:number_of_target
        for i=1:number_of_target
            if (strcmp(R{r},modelclass{i,1})==1)                        
                n=i;
                break;
            end
        end
        retrieved_class{1,r}=modelclass{n,2};
        if (strcmp(query_class,retrieved_class{1,r})==1)
            G(r)=1;
        end
    end;
    
    G_sum=cumsum(G); 
    
    R_points=zeros(1,C(qqq));
    for rec=1:C(qqq)
        R_points(rec)=find((G_sum==rec),1);
    end;
    
    P_points(qqq,1:C(qqq))=G_sum(R_points)./R_points;
    Av_Precision(qqq)=mean(P_points(qqq,:));
    
    NN(qqq)=G(1);
    FT(qqq)=G_sum(C(qqq))/C(qqq);
    ST(qqq)=G_sum(2*C(qqq))/C(qqq);
    P_32=G_sum(32)/32;
    R_32=G_sum(32)/C(qqq);
    
    if (P_32==0)&&(R_32==0);
        E(qqq)=0;
    else
        E(qqq)=2*P_32*R_32/(P_32+R_32);
    end;
    
    NORM_VALUE=1+sum(1./log2([2:C(qqq)]));
    dcg_i=(1./log2([2:length(R)])).*G(2:end);
    dcg_i=[G(1);dcg_i(:)];
    dcg(qqq)=sum(dcg_i)/NORM_VALUE;
    
    filename=[RANK_DIR 'Stats.txt'];
    fid=fopen(filename,'a');
    fprintf(fid,'No.%d: %2.3f\t %2.3f\t %2.3f\t %2.3f\t %2.3f\n',qqq, NN(qqq),FT(qqq),ST(qqq),E(qqq),dcg(qqq));
    fclose(fid);    
end;

NN_av=mean(NN)
FT_av=mean(FT)
ST_av=mean(ST)
dcg_av=mean(dcg)
E_av=mean(E)
Mean_Av_Precision=mean(Av_Precision) 
filename=[RANK_DIR 'Stats.txt'];
fid=fopen(filename,'a');
fprintf(fid,'NN       FT       ST       E       DCG \n');
fprintf(fid,'%2.3f\t %2.3f\t %2.3f\t %2.3f\t %2.3f\n',NN_av,FT_av,ST_av,E_av,dcg_av);
fclose(fid);

filename=[RANK_DIR 'PR.txt'];
fid=fopen(filename,'w');
fprintf(fid,'Recall      Precision\n');
fclose(fid); 
Precision=calcAvgPerf(P_points, C, number_of_queries, filename);
Recall=[1:20]/20;

plot(Recall,Precision);
hold on;
plot(Recall,Precision,'*');
axis([0 1 0 1])
hold off;

xlabel('Precision'),ylabel('Recall')
