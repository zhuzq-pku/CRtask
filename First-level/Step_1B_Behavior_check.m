% written by Xu Jiahua(2024/10/03)
% Any Question: 18009445566@163.com

%!!!!!! If run on the Linux and Unix, please do change the \ into /.!!!!!!!!!!!!!
clc;
clear;
path_code='G:\[your path]\ER_PM' % Raw data of eprime and parameter
preprocess='G:\[your path]\preprocessing' % preprocessing dir  before year folder
cd(path_code)
runnum=2
fileName=['ER' num2str(runnum) '_merged.txt']%'ER1_merged.txt'; % eprime data ,NO CHANGE DATA STRUCTURE!!!!
subj_list=['ER_list_R' num2str(runnum) '.txt']

opts = detectImportOptions(subj_list);
opts = setvartype(opts, 'imaging', 'char');
opts.SelectedVariableNames = {'behavior','imaging'};


database=table2cell(readtable([path_code filesep fileName]));
participant_label=readtable([path_code filesep subj_list],opts)
imagefile=participant_label.imaging
subj=participant_label.behavior
dataall=[]
%unique(cell2mat(database(:,2)))
for ii=1:length(subj)
    ERtemp=database(cell2mat(database(:,2))==subj(ii,1),:);
    Subjnum=ERtemp(:,2)
    type1=ERtemp(:,63);
    type2=ERtemp(:,32);
    AVV1= ismember(type1,'Aversive') & ismember(type2,'Stimuli\LOOK.bmp')
    AVD1= ismember(type1,'Aversive') & ismember(type2,'Stimuli\LESS.bmp')
    Ne=ismember(type1,'Neutral') & ismember(type2,'Stimuli\LOOK.bmp')
  
  
    Rating=cell2mat(ERtemp(:,40));
    RT=cell2mat(ERtemp(:,41));
    AVDR=mean(Rating(AVD1==1 & isnan(Rating)==0));

    stdAVDR=std(Rating(AVD1==1 & isnan(Rating)==0))

    AVDRT=mean(RT(AVD1==1 & RT~=0)/1000);
    NanAVDR=mean(isnan(Rating(AVD1==1))==1);

    NeR=mean(Rating(Ne==1 &isnan(Rating)==0));

    stdNeR=std(Rating(Ne==1 &isnan(Rating)==0))


    NeRT=mean(RT(Ne==1 & RT~=0)/1000);
    NanNeR=mean(isnan(Rating(Ne==1))==1);

    AVVR=mean(Rating(AVV1==1 & isnan(Rating)==0));

    stdAVVR=std(Rating(AVV1==1 & isnan(Rating)==0))

    AVVRT=mean(RT(AVV1==1 & RT~=0)/1000);
    NanAVVR=mean(isnan(Rating(AVV1==1))==1);

    data_temp_all=[subj(ii,1),AVDR,AVDRT,NeR,NeRT,AVVR,AVVRT,NanAVDR,NanNeR,NanAVVR,stdAVDR,stdAVVR,stdNeR]
    dataall=[dataall;data_temp_all]
end

Head={'subj_name','aversive_regulate_rating','aversive_regulate_RT','Neutral_rating','Neutral_RT','aversive_view_rating','aversive_view_RT','missingAVD','missingNeutral','missingAVV','stdAVDR','stdAVVR','stdNeR','image_name'}
final=[Head;[num2cell(dataall),imagefile]];

Behavior_name=[path_code filesep 'Behavior' filesep 'Result_Run_' num2str(runnum) '.csv' ]
cell2csv(Behavior_name,final)