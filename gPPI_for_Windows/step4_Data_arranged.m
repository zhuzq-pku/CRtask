clear
clc

basePath = 'G:\[your path]\First_level\First_level_Regular_2runs'; % base
newPath = 'G:\[your path]\gPPI_analysis\PPI_Reslice_PCC_neuros'; % target
sublistFile = 'G:\[your path]\CODE\gPPI_for_Windows\Sublist_Regular_2runs_twolevel.txt'; % ID list


fid = fopen(sublistFile, 'r'); 
subIDs = textscan(fid, '%s'); % read all ID
fclose(fid); 
subIDs = subIDs{1}; 


for i = 1:length(subIDs)
    subID = subIDs{i}; 
    
    sourceDir = fullfile(basePath, subID, 'fmri', 'stats_spm12', 'ER', 'stats_spm12_swcar_gPPI', 'PPI_Reslice_PCC_neuros');
    
    sourceFiles = dir(fullfile(sourceDir, '*con_PPI_Decrease_*.img'));
    
        for j = 1:length(sourceFiles)
            sourceFilePath = fullfile(sourceDir, sourceFiles(j).name); 
            
            [~, fileName, fileExt] = fileparts(sourceFiles(j).name); 
            destFilePath = fullfile(newPath, [subID fileExt]); 
            
            copyfile(sourceFilePath, destFilePath);
            fprintf('Copied: %s -> %s\n', sourceFilePath, destFilePath); 
        end
end

disp('Task arrange completed!');