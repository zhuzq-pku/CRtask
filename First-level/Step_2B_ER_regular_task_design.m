% written by Xu Jiahua(2018/12/21)
% Any Question: 18009445566@163.com
% qinlab.BNU
%!!!!!! If run on the Linux and Unix, please do change the \ into /.!!!!!!!!!!!!!
clc;
clear;
path_code='G:\[your path]\ER_PM' % Raw data of eprime and parameter
preprocess='G:\[your path]\taskdes' % preprocessing dir  before year foldercd(path_code)
%year=2016
runnum=1
fileName=['ER' num2str(runnum) '_merged.txt']%'ER1_merged.txt'; % eprime data ,NO CHANGE DATA STRUCTURE!!!!
subj_list=['ER_list_R' num2str(runnum) '.txt']

opts = detectImportOptions(subj_list);
opts = setvartype(opts, 'imaging', 'char');
opts.SelectedVariableNames = {'behavior','imaging'};

database=table2cell(readtable([path_code filesep fileName]));
participant_label=readtable([path_code filesep subj_list],opts)
imagefile=participant_label.imaging
subj=participant_label.behavior
for ii=1:length(subj)
    ERtemp=database(cell2mat(database(:,2))==subj(ii,1),:);
    Subjnum=ERtemp(:,2)
    type1=ERtemp(:,63);
    type2=ERtemp(:,32);
    AVV1= ismember(type1,'Aversive') & ismember(type2,'Stimuli\LOOK.bmp')
    AVD1= ismember(type1,'Aversive') & ismember(type2,'Stimuli\LESS.bmp')
    Ne=ismember(type1,'Neutral') & ismember(type2,'Stimuli\LOOK.bmp')
    Type=cell2mat(ERtemp(:,31))
    BaselineTime=unique(cell2mat(ERtemp(:,14)))
    OnsetRatingRaw=cell2mat(ERtemp(:,38))
    OnsetRating=(OnsetRatingRaw-BaselineTime)/1000

    %     OnsetViewRaw=cell2mat(ERtemp(:,55))
    %     OnsetView=(OnsetViewRaw-BaselineTime)/1000

    %     OnsetCue=OnsetView-2
    Rating=cell2mat(ERtemp(:,40));
    RT=cell2mat(ERtemp(:,41));
    AVDR=Rating(AVD1==1 & isnan(Rating)==0);
    AVDRT=RT(AVD1==1 & RT~=0)/1000;
    NanAVDR=find(isnan(Rating(AVD1==1))==1);

    NeR=Rating(Ne==1 &isnan(Rating)==0);
    NeRT=RT(Ne==1 & RT~=0)/1000;
    NanNeR=find(isnan(Rating(Ne==1))==1);

    AVVR=Rating(AVV1==1 & isnan(Rating)==0);
    AVVRT=RT(AVV1==1 & RT~=0)/1000;
    NanAVVR=find(isnan(Rating(AVV1==1))==1);



    AvDRatOnset=OnsetRating(AVD1==1)
    NeRatOnset=OnsetRating(Ne==1)
    AvRatOnset=OnsetRating(AVV1==1)
    task_design_path=[preprocess filesep imagefile{ii,1} filesep 'fmri' filesep 'ER' num2str(runnum) filesep 'task_design'];
    mkdir(task_design_path);
    fp=fopen([task_design_path filesep 'taskdesign_ER_regular.m'],'w');
    
    
    fprintf(fp, '%s\n', 'sess_name =''ER'';');


    %%aversive regulation Rat
    fprintf(fp, '%s\n','names{1}   = [''AvDRatOnset''];');
    AvDRatOnset1 = num2cell(AvDRatOnset(isnan(Rating(AVD1==1))~=1));
    fprintf(fp, [ ...
        'onsets{1}    = [', repmat('%f ', 1, length(AvDRatOnset1)), '];\n'], AvDRatOnset1{:});
    DurationRat1 = num2cell(AVDRT);
    fprintf(fp, [ ...
        'durations{1}    = [', repmat('%f ', 1, length(DurationRat1)), '];\n'], DurationRat1{:});
   
    %% neutral rating
    fprintf(fp, '%s\n','names{2}   = [''NeRatOnset''];');
    NeRatOnset1 = num2cell(NeRatOnset(isnan(Rating(Ne==1))~=1));
    fprintf(fp, [...
        'onsets{2}    = [', repmat('%f ', 1, length(NeRatOnset1)), '];\n'], NeRatOnset1{:});
    DurationRat2 = num2cell(NeRT);
    fprintf(fp, [ ...
        'durations{2}    = [', repmat('%f ', 1, length(DurationRat2)), '];\n'], DurationRat2{:});

    %% averive rating
    fprintf(fp, '%s\n','names{3}   = [''AvRatOnset''];');
    AvRatOnset1 = num2cell(AvRatOnset(isnan(Rating(AVV1==1))~=1));
    fprintf(fp, [ ...
        'onsets{3}    = [', repmat('%f ', 1, length(AvRatOnset1)), '];\n'], AvRatOnset1{:});
    DurationRat3 = num2cell(AVVRT);
    fprintf(fp, [ ...
        'durations{3}    = [', repmat('%f ', 1, length(DurationRat3)), '];\n'], DurationRat3{:});

    %% ending
    fprintf(fp, '%s\n','rest_exists  = 1;');
    fprintf(fp, '%s\n','save task_design.mat sess_name names onsets durations rest_exists');

    fclose(fp)
    clear fp
 
end