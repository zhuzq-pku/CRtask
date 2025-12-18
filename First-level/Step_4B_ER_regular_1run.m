%% Firstlv Analysis for Parameter Modulation %%
%% Design For 3 Runs Math Program %%
%% Task Design Should be Arranged as taskdesign.m in Depend/Demo%%
%% Jiahua Edit Oringinal at 2019-01-17%%
%% xujiahuapsy@gmail.com %%


%% ------------------------------ Set Up ------------------------------- %%
clear;clc;restoredefaultpath;
% Setting Up
rawpath='G:\[your path]\taskdes'; % Task folder before year folder
spmpath='G:\[your path]\spm12\' %SPM Path
Scripts='G:\[your path]\ER_PM\'
Firstlvdir='G:\[your path]\First_level_Regular_run2'
cd(rawpath);
TaskName='ER'
HowMuchRun=2%%!!!!!!!!!!!!!!!1/2 for run1/2
whichrun=2 %%!!!!!!!!!!!!!!!1/2 for run 1/2, if process seperately
% Sublist
[~, ~, subid] = xlsread('G:\[your path]\ER_PM\Sublist_run2.xlsx','Sheet1');
addpath (genpath (spmpath));
addpath (genpath (Scripts));

for ii=1:length(subid)
    load(fullfile(Scripts,'depend','Single_run_regular.mat'))
    subtind=subid{ii,1}
    % Year=strcat('20',subtind(1:2))
    subdatapath=fullfile(rawpath,num2str(subtind))
    Topath=fullfile(Firstlvdir,num2str(subtind),'fmri','stats_spm12',[TaskName num2str(whichrun)],'stats_spm12_swcar')
    mkdir(Topath)
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 43;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 21;
    %   for rr=HowMuchRun %% Run Number
    ses=[TaskName num2str(whichrun)]
    matlabbatch{1}.spm.stats.fmri_spec.dir = {Topath};
    scanData=strcat(subdatapath,'\fmri\',ses,'\','smoothed_spm12');cd(scanData)
    for kk=1:245
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans(kk,1) = {[scanData filesep 'swcarI.nii,' num2str(kk)]}
    end
    TaskDesignPath=strcat(subdatapath,'\fmri\',ses,'\','task_design\');cd(TaskDesignPath)
    taskdesign_ER_regular
    load('task_design.mat')
    for connum=1:length(onsets)
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(connum).name = names{1,connum};
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(connum).onset =onsets{1,connum}';
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(connum).duration = durations{1,connum}';
        matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(connum).tmod = 0;
    end

    RegrePath=[scanData filesep 'rp_arI.txt']
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {RegrePath};
    cd(scanData)
    %       nifti_3dto4d_convert_recursive1(scanData,spmpath)

    cd(Topath)
    if exist('SPM.mat', 'file')
        disp('The stats directory contains SPM.mat. It will be deleted.');
        delete('SPM.mat')
        % unix('/bin/rm -rf *');
    end
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    load(fullfile(Scripts,'Contrast','contrast_1run_regular.mat'))
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    for con=1:5
        matlabbatch{3}.spm.stats.con.consess{con}.tcon.name = contrastNames{1,con};
        matlabbatch{3}.spm.stats.con.consess{con}.tcon.weights =contrastVecs{1,con}
        matlabbatch{3}.spm.stats.con.consess{con}.tcon.sessrep = 'none';
    end
    spm_jobman('initcfg')
    spm('defaults', 'FMRI');
    spm_jobman('serial', matlabbatch, '',cell(0, 1));
    clear matlabbatch
end
