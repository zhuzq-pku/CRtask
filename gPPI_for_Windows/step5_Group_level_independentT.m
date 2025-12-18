clc;clear
second='G:\[your path]\gPPI_analysis\Groupcomparison_Ttest\PPI_r2_Amy_L_AAL';cd(second);
datapath='G:\[your path]\gPPI_analysis\gPPI_firstlevel_regular_2runs\PPI_r2_Amy_L_AAL'
database=readtable(['G:\[your path]\Second_level' filesep 'Regular_Sublist_2runs.xlsx']);
HC=table2cell(database(ismember(database.group,'HC'),1));
ADHD=table2cell(database(ismember(database.group,'ADHD'),1));
matlabbatch{1}.spm.stats.factorial_design.dir = {second};
%%
for subid_ADHD=1:length(ADHD)
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1(subid_ADHD,:) = {[datapath filesep ADHD{subid_ADHD,1} '.img,1']};
end

for subid_HC=1:length(HC)
    matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2(subid_HC,:) = {[datapath filesep HC{subid_HC,1} '.img,1']};
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