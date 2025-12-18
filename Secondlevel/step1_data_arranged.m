clc;clear
path='G:\[your path]\First_level\First_level_Regular_2runs';cd(path);
files=dir('5*');
filename={files.name}'
topath = 'G:\[your path]\Second_level_GroupT\Regular_arranged_2runs\con0002_Ne';mkdir(topath);
for ii=1:length(filename)
    temp=[path filesep filename{ii,1} filesep 'fmri' filesep 'stats_spm12' filesep 'ER' filesep 'stats_spm12_swcar'];cd(temp);
    name1=[temp filesep 'con_0002.nii']
    name2=[topath filesep filename{ii,1} '.nii']
    copyfile(name1,name2)
end