cd G:\[your path]\gPPI_analysis\Groupcomparison_Ttest
% read file of list.txt
fileID = fopen('G:\[your path]\gPPI_analysis\Groupcomparison_Ttest\list.txt', 'r');
fileNames = textscan(fileID, '%s');
fclose(fileID);


fileNames = fileNames{1};

for i = 1:length(fileNames)
    folderName = fileNames{i};
    if ~exist(folderName, 'dir')
        mkdir(folderName);
        fprintf('Created: %s\n', folderName);
    else
        fprintf('Existed already: %s\n', folderName);
    end
end