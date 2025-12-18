clc;
clear;
%% Xujiahua 2019/07/25%%%
%% Fix SPM.xY and swd pathway%
%% Any Problems xujiahuapsy@gmail.com
%% data structure 
% Program
%    |____PreProcessing
%    |           |_______year(2017,etc)
%    |                      |_____17-11-01.1math(examples)
%    |                                    |____fmri
%    |                                           |_____task(run)
%    |                                                   |______smoothed_spm12
%    |                                                   |______task_design
%    |                                                   |______unnormalized          
%    |____Firstlevel
%            |_______year(2017,etc)
%    |                      |_____17-11-01.1math(examples)
%    |                                    |____stats_spm12
%    |                                           |_____task(run)
%    |                                                   |______stats_spm12_swcar
% old G:\[your path]\taskdes\5619\fmri\ER1\smoothed_spm12
% New G:\[your path]\preprocessing\5617\fmri\ER1\smoothed_spm12
workdir='G:\[your path]\gPPI_for_Windows' 
OldPre='G:\[your path]\taskdes'
prep='G:\[your path]\preprocessing'
firstlevel='G:\[your path]\First_level\First_level_Regular_2runs'
subjlist=[workdir filesep 'Sublist_Regular_2runs_twolevel.txt']
taskname='ER'
fid = fopen (subjlist); Subjects = {}; cnt = 1;
while ~feof (fid)
    linedata = textscan (fgetl (fid), '%s', 'Delimiter', '\t');
    Subjects (cnt, :) = linedata {1}; cnt = cnt+1; %#ok<*SAGROW>
end
fclose (fid);

for ii=1:length(Subjects)
  % year = ['20', Subjects{ii}(1:2)];
   cd ([firstlevel filesep Subjects{ii} filesep 'fmri\stats_spm12' filesep taskname filesep 'stats_spm12_swcar' ])
   copyfile('SPM.mat','SPMold.mat')
  % EPIrun1 = spm_select('ExtFPList',  fullfile(prep, year,Subjects{ii},'fmri','run1','smoothed_spm12'), ['^swca' '.*\.nii$'], Inf); 
   %EPIrun1U=cellstr(EPIrun1);  
   spm_changepath('SPM.mat', [OldPre  filesep Subjects{ii} ], [prep filesep Subjects{ii} ])
   %spm_changepath('SPM.mat', [OldPre filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run2' filesep 'smoothed_spm12'], [prep filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run2' filesep 'smoothed_spm12']);
   %spm_changepath('SPM.mat', [OldPre filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run3' filesep 'smoothed_spm12'], [prep filesep year filesep Subjects{ii} filesep 'fmri' filesep 'run3' filesep 'smoothed_spm12']);
   load ('SPM.mat' )
   SPM.swd=pwd
   %SPM.SPMid='SPM5: spm_spm (v$Rev: 946 $)'
   save('SPM.mat','SPM')
   clear SPM 
end