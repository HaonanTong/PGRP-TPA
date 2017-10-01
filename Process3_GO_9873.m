% For each time point get genes that is associated with GO:0009873
myDir = 'period*';
myFiles = dir(fullfile(myDir,'DEGs*.txt'));

for i = 1 : length(myFiles)% Gene List Associated with GO:0009873
    unix(sprintf('grep -f %s/%s ATH_GO_GOSLIM.txt | awk ''/GO:0009873/ {print $1}'' > %s/ATH_GO_%s',...
        myFiles(i).folder,myFiles(i).name,myFiles(i).folder,myFiles(i).name));
end
