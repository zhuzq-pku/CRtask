clc;clear

path = 'G:\[your path]\First_level\First_level_Regular_2runs';cd(path);

filesname = dir('5*')
files={filesname.name}'

roi={'PPI_r2_Amy_L_AAL','PPI_r2_Amy_R_AAL','PPI_r2_Resliced_BinaryMask_CM_L_ROI1','PPI_r2_Resliced_BinaryMask_CM_R_ROI2','PPI_r2_Resliced_BinaryMask_LB_L_ROI3','PPI_r2_Resliced_BinaryMask_LB_R_ROI4','PPI_r2_Resliced_BinaryMask_SF_L_ROI5','PPI_r2_Resliced_BinaryMask_SF_R_ROI6'}'

for ii = 1:length(files)
    for kk=1:length(roi)
    tempdir =[path filesep files{ii,1} filesep 'fmri\stats_spm12\ER\stats_spm12_swcar_gPPI_Ne' filesep roi{kk,1}];cd(tempdir);
    temp=[ 'con_PPI_NeView_' files{ii,1} '.img']; %Decrease, EmoReact, AvView

    newname=[ 'con_PPI_NeView_' files{ii,1} '.nii'];

    movefile(temp, newname);
    end
end