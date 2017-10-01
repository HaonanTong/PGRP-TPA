% Filter Profile-ANan-DEGs.csv' to get rid of .1 part.
Table_tmp = readtable('Profiles-ANan-DEGs.csv','ReadRowNames',true,'ReadVariableNames',true);
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
    writetable(subT,'Profiles-ANan-DEGs-Filtered.csv','WriteRowNames',true,'WriteVariableNames',true);
end
