% Based on Gene object activated at different time point; Focus on .1 genes. 

myDir = 'Data/period*';
myFiles = dir(fullfile(myDir,'*.csv'));
for i = 1 : length(myFiles)
    file_tmp = sprintf('%s/%s',myFiles(i).folder,myFiles(i).name);
    Table_tmp = readtable(file_tmp,'ReadRowNames',true,'ReadVariableNames',true);
    RowName_tmp = Table_tmp.Properties.RowNames;
    subT = [];
    for j = 1 : length(RowName_tmp)
        indx = regexp(RowName_tmp{j},'AT\dG\d{5}.1');
        if ~isempty(indx)
            subT=[subT; Table_tmp(j,:)];
        end
    end
    
    %filter subT
    if ~isempty(subT)
        RowName_subT = subT.Properties.RowNames;
    
        for j = 1 : length(RowName_subT)
            tmp = RowName_subT{j};
            RowName_subT{j} = tmp(1:9);
        end
        subT.Properties.RowNames = RowName_subT;
    
        % Wrtie  table
        writetable(subT,myFiles(i).name,'WriteRowNames',true,'WriteVariableNames',true);
    end
    
    if isempty(subT)
        writetable(Table_tmp,myFiles(i).name,'WriteRowNames',true,'WriteVariableNames',true);
    end

end    

mkdir period1
mkdir period2
mkdir period3
mkdir period4
mkdir period5
mkdir period6
for i = 1 : 6
    unix(sprintf('mv *%d*.csv period%d',i,i));
end


%% Analysis
disp('Analysis on number of genes activated at different time point');
for i = 1 : 6
    disp('-------------------------');
    fprintf('For time point %d\n',i); 
    myDir = sprintf('period%d',i);
    myFiles = dir(fullfile(myDir,'*.csv'));
    ng_array = [];
    for j = 1 : length(myFiles)
        T = readtable(sprintf('%s/%s',myFiles(j).folder,myFiles(j).name));
        [ngenes,~]=size(T);
        ng_array = [ng_array ngenes];
        fprintf('%s: %d\n',myFiles(j).name,ngenes);
    end
    Matrix_Analysis(i,:) = ng_array;
end

Matrix_Analysis = [Matrix_Analysis ; sum(Matrix_Analysis)];

Table_Analysis = array2table(Matrix_Analysis);
Table_Analysis.Properties.RowNames = {'T0.25','T0.5','T1','T4','T12','T24','SUM'};
Table_Analysis.Properties.VariableNames = {'DEGs_Down','DEGs_up','DEGs','TFs_Down','TFs_Up','TFs','nTFs_down','nTFs_up','nTFs'};
writetable(Table_Analysis,'Table_Summary.csv','WriteRowNames',true,'WriteVariableNames',true);


%% GO Association
for i = 1 : 6
    myDir = sprintf('period%d',i);
    myFile = fullfile(myDir,sprintf('DEGs-time-Activation%d.csv',i'));
    T = readtable(myFile,'ReadRowNames',true,'ReadVariableNames',true);
    DEGList = T.Properties.RowNames;
    fileID = fopen(sprintf('%s/DEGs%d.txt',myDir,i),'w');
    for j = 1 : length(DEGList)
        fprintf(fileID,'%s\n',DEGList{j});
    end
 %   unix(sprintf('sed -E ''s/[[:space:]]+//g'' %s > %s',...
 %       sprintf('%s/DEGs%d.txt',myDir,i),sprintf('%s/DEGs%d.txt',myDir,i)));

end

unix('paste -d ''\t'' period*/DEGs*.txt > TPA_GO.txt')





