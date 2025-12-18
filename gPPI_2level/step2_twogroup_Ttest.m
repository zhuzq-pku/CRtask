%% ------------------------------ Set Up ------------------------------- %%
clear;clc;
% Setting Up
rawpath='G:\[your path]\First_level\First_level_Regular_2runs'; % Task folder before year folder
% Sublist
[~, ~, subid] = xlsread('G:\[your path]\gPPI_2level\sublist.xlsx','Sheet1');
topath ='G:\[your path]\Second_gppi' %save path
adhd=subid(ismember(subid(:,2),'ADHD'),1);
hc=subid(ismember(subid(:,2),'HC'),1);
roi={'PPI_r2_Amy_L_AAL','PPI_r2_Amy_R_AAL','PPI_r2_Resliced_BinaryMask_CM_L_ROI1','PPI_r2_Resliced_BinaryMask_CM_R_ROI2','PPI_r2_Resliced_BinaryMask_LB_L_ROI3','PPI_r2_Resliced_BinaryMask_LB_R_ROI4','PPI_r2_Resliced_BinaryMask_SF_L_ROI5','PPI_r2_Resliced_BinaryMask_SF_R_ROI6'}'
for roilist=1:length(roi)
    temppath=[topath filesep roi{roilist,1}];mkdir(temppath);
    matlabbatch{1}.spm.stats.factorial_design.dir = { temppath};
    for ii=1:length(adhd)
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1(ii,1) = {[rawpath filesep num2str(adhd{ii,1}) filesep 'fmri\stats_spm12\ER\stats_spm12_swcar_gPPI_Ne' filesep roi{roilist,1} filesep 'con_PPI_NeView_' num2str(adhd{ii,1}) '.nii,1']}; 
    end
    for kk=1:length(hc)
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2(kk,1)={[rawpath filesep hc{kk,1} filesep 'fmri\stats_spm12\ER\stats_spm12_swcar_gPPI_Ne' filesep roi{roilist,1} filesep 'con_PPI_NeView_' hc{kk,1} '.nii,1']};  %con_PPI_Decrease_
    end
    
    matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Group';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;
    spm_jobman('initcfg')
    spm('defaults', 'FMRI');
    spm_jobman('serial', matlabbatch, '',cell(0, 1));
    clear matlabbatch
end