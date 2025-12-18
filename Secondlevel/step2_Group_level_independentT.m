clc;clear 
second='G:\[your path]\Second_level_GroupT\Group_Ttest\Second_Regular_2runs_con0002Ne';cd(second);
datapath='G:\[your path]\Second_level_GroupT\Regular_arranged_2runs\con0002Ne'

%database=readtable(['G:\[your path]\Second_level_GroupT' filesep 'Regular_Sublist_2runs.xlsx']);
%HC=table2cell(database(ismember(database.group,'HC'),1));
%ADHD=table2cell(database(ismember(database.group,'ADHD'),1));

% Sublist
[~, ~, subid] = xlsread('G:\[your path]\CODE\gPPI_2level\sublist.xlsx','Sheet1');
ADHD=subid(ismember(subid(:,2),'ADHD'),1);
HC=subid(ismember(subid(:,2),'HC'),1);

matlabbatch{1}.spm.stats.factorial_design.dir = {second};
%%
for subid_ADHD=1:length(ADHD)
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1(subid_ADHD,:) = {[datapath filesep num2str(ADHD{subid_ADHD,1}) '.nii,1']}; %adhd编号没有引号，hc有
end

for subid_HC=1:length(HC)
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2(subid_HC,:) = {[datapath filesep HC{subid_HC,1} '.nii,1']};
end
%%
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
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'A_H';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('initcfg')
spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch, '',cell(0, 1));