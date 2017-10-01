%% Tendency and Time point for the activation
myDir = 'period*';
myFiles_up = dir(fullfile(myDir,'DEGs-time-Activation*-up.csv'));
myFiles_down = dir(fullfile(myDir,'DEGs-time-Activation*-down.csv'));
T_Summary = cell(1,6);
for i = 1 : length(myFiles_up)
    Table_up = readtable(...
        sprintf('%s/%s',myFiles_up(i).folder,myFiles_up(i).name),...
        'ReadRowNames',true,'ReadVariableNames',true);
    [ngn_up,~] = size(Table_up);
    Gup = ones(ngn_up,1);
    Table_down = readtable(...
        sprintf('%s/%s',myFiles_down(i).folder,myFiles_down(i).name),...
        'ReadRowNames',true,'ReadVariableNames',true);
    [ngn_down,~] = size(Table_down);
    Gdown = zeros(ngn_down,1);
    
    ATP = i * ones(ngn_up+ngn_down,1);
    ID = [Table_up.Properties.RowNames;Table_down.Properties.RowNames];
    Tendency = [Gup; Gdown];
    
    T_Summary{i} = table(ID,Tendency,ATP);
end

T = [];
for i = 1 : 6
    T = [T; T_Summary{i}];
end
writetable(T, 'Table_Summary_Gene.csv',...
    'WriteRowNames',true,'WriteVariableNames',true);


%% Identify DEGs is TF or nTF;
T = readtable('Table_Summary_Gene.csv','ReadRowNames',true,'ReadVariableNames',true);
T.TF = zeros( size(T,1) ,1 );

T_TFs = readtable(...
       'Arabidopsis_TFs.csv',...
        'ReadRowNames',false,'ReadVariableNames',true);
TFs = table2array(T_TFs);

for j = 1 : length(TFs)
    if(any(strcmp(TFs{j},T.Properties.RowNames)))
        T(TFs{j},'TF') = {1};
    end
end

sum(T(:,end))
writetable(T, 'Table_Summary_Gene.csv',...
    'WriteRowNames',true,'WriteVariableNames',true);        
    
    