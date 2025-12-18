
%%copy files of contrast.nii to Second_gppi directory for value extraction
sourceBasePath = 'G:\[your path]\First_level\First_level_Regular_2runs';
targetPath = 'G:\[your path]\Second_gppi\Con0002_Ne\First_gPPI\SF_R';


subfolders = dir(fullfile(sourceBasePath, '5*'));
subfolders = subfolders([subfolders.isdir]); 


for i = 1:length(subfolders)
    folderName = subfolders(i).name;
    

    sourceFilePath = fullfile(sourceBasePath, folderName, 'fmri', 'stats_spm12', 'ER', ...
        'stats_spm12_swcar_gPPI_Ne', 'PPI_r2_Resliced_BinaryMask_SF_R_ROI6', ['con_PPI_NeView_' folderName '.nii']);

        targetFilePath = fullfile(targetPath, ['con_PPI_NeView_' folderName '.nii']);

        copyfile(sourceFilePath, targetFilePath);
        disp(['Copied: ' folderName]);
end

disp('All done!');