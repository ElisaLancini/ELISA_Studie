%% Path
clear
path.root    = '/Users/elisalancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';

% mac book laptop
%path.root    = '/Users/elisalancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';
cd(path.root)

%% Encoding 
% Fix cross number 1 , type 1

A=load('Enc_Fix1_1.mat'); %(1-5)
B=load('Enc_Fix1_2.mat'); %(1-5)

trial_type_ISI=[A.design_struct.eventlist(:, 3); B.design_struct.eventlist(:, 3)];
trial_type_ISI(trial_type_ISI==2)=0;

howmany1(1,1)=sum(trial_type_ISI==1)
howmany2(1,1)=sum(trial_type_ISI==0)

ISI= [A.design_struct.eventlist(:, 4); B.design_struct.eventlist(:, 4)]; %PTB uses seconds

average(1,1)=mean(ISI)
piccolo(1,1)=min(ISI)
grande(1,1)=max(ISI)
total(1,1)=sum(ISI)

design_struct.eventlist(:, 3)=trial_type_ISI
design_struct.eventlist(:, 4)=ISI
save('Enc_Fix1_1_merged.mat','design_struct')

clearvars -except path.root howmany1 howmany2 average piccolo grande total

% Fix cross number 2 , type 1
C=load('Enc_Fix2_1.mat'); %(1-3)
D=load('Enc_Fix2_2.mat'); %(1-3)

trial_type_ISI=[C.design_struct.eventlist(:, 3); D.design_struct.eventlist(:, 3)]
trial_type_ISI(trial_type_ISI>=2)=0;

howmany1(2,1)=sum(trial_type_ISI==1)
howmany2(2,1)=sum(trial_type_ISI==0)

ISI= [C.design_struct.eventlist(:, 4); D.design_struct.eventlist(:, 4)]; %PTB uses seconds

average(2,1)=mean(ISI)
piccolo(2,1)=min(ISI)
grande(2,1)=max(ISI)
total(2,1)=sum(ISI)


design_struct.eventlist(:, 3)=trial_type_ISI
design_struct.eventlist(:, 4)=ISI
save('Enc_Fix2_1_merged.mat','design_struct')


clearvars -except path.root howmany1 howmany2 average piccolo grande total

% Fix cross number 1 , type 2

E=load('Enc_Fix1_3.mat'); %(1-5)
F=load('Enc_Fix1_4.mat'); %(1-5)

trial_type_ISI=[E.design_struct.eventlist(:, 3); F.design_struct.eventlist(:, 3)]
trial_type_ISI(trial_type_ISI>=2)=0;

howmany1(3,1)=sum(trial_type_ISI==1)
howmany2(3,1)=sum(trial_type_ISI==0)

ISI= [E.design_struct.eventlist(:, 4); F.design_struct.eventlist(:, 4)]; %PTB uses seconds

average(3,1)=mean(ISI)
piccolo(3,1)=min(ISI)
grande(3,1)=max(ISI)
total(3,1)=sum(ISI)


design_struct.eventlist(:, 3)=trial_type_ISI
design_struct.eventlist(:, 4)=ISI
save('Enc_Fix1_2_merged.mat','design_struct')


clearvars -except path.root howmany1 howmany2 average piccolo grande total
% Fix cross number 2 , type 1

G=load('Enc_Fix2_3.mat'); %(1-3)
H=load('Enc_Fix2_4.mat'); %(1-3)

trial_type_ISI=[G.design_struct.eventlist(:, 3); H.design_struct.eventlist(:, 3)]
trial_type_ISI(trial_type_ISI>=2)=0;

howmany1(4,1)=sum(trial_type_ISI==1)
howmany2(4,1)=sum(trial_type_ISI==0)

ISI= [G.design_struct.eventlist(:, 4); H.design_struct.eventlist(:, 4)]; %PTB uses seconds

average(4,1)=mean(ISI)
piccolo(4,1)=min(ISI)
grande(4,1)=max(ISI)
total(4,1)=sum(ISI)


design_struct.eventlist(:, 3)=trial_type_ISI
design_struct.eventlist(:, 4)=ISI
save('Enc_Fix2_2_merged.mat','design_struct')


clearvars -except path.root howmany1 howmany2 average piccolo grande total

% Together
EncodingResults = array2table([howmany1 howmany2 piccolo grande average total],'VariableNames',{'Nstimuli1','Nstimuli2','Minimum','Maximum','Average','Total'},'RowNames',{'Enc_Fix_1_1' 'Enc_Fix_2_1' 'Enc_Fix_1_2' 'Enc_Fix_2_2'})

clearvars -except path.root EncodingResults


%% Retrieval

% Fix cross number 1 , type 1

load('Retr_Fix1_1.mat'); %(1-5)


trial_type_ISI = [design_struct.eventlist(:, 3)];
trial_type_ISI(trial_type_ISI>=2)=0;

howmany1(1,1)=sum(trial_type_ISI==1)
howmany2(1,1)=sum(trial_type_ISI==0)

ISI= [design_struct.eventlist(:, 4)]; %PTB uses seconds

average(1,1)=mean(ISI)
piccolo(1,1)=min(ISI)
grande(1,1)=max(ISI)
total(1,1)=sum(ISI)

design_struct.eventlist(:, 3)=trial_type_ISI;
save('Retr_Fix1_1_repl.mat','design_struct')

clearvars -except path.root howmany1 howmany2 average piccolo grande total EncodingResults


% Fix cross number 2 , type 1

load('Retr_Fix2_1.mat'); %(1-3)

trial_type_ISI = [design_struct.eventlist(:, 3)];
trial_type_ISI(trial_type_ISI>=2)=0;

howmany1(2,1)=sum(trial_type_ISI==1)
howmany2(2,1)=sum(trial_type_ISI==0)

ISI= [design_struct.eventlist(:, 4)]; %PTB uses seconds

average(2,1)=mean(ISI)
piccolo(2,1)=min(ISI)
grande(2,1)=max(ISI)
total(2,1)=sum(ISI)

design_struct.eventlist(:, 3)=trial_type_ISI;
save('Retr_Fix2_1_repl.mat','design_struct')

clearvars -except path.root howmany1 howmany2 average piccolo grande total EncodingResults


% Fix cross number 1 , type 2

load('Retr_Fix1_2.mat'); %(1-5)


trial_type_ISI = [design_struct.eventlist(:, 3)];
trial_type_ISI(trial_type_ISI>=2)=0;

howmany1(3,1)=sum(trial_type_ISI==1)
howmany2(3,1)=sum(trial_type_ISI==0)

ISI= [design_struct.eventlist(:, 4)]; %PTB uses seconds

average(3,1)=mean(ISI)
piccolo(3,1)=min(ISI)
grande(3,1)=max(ISI)
total(3,1)=sum(ISI)

design_struct.eventlist(:, 3)=trial_type_ISI;
save('Retr_Fix1_2_repl.mat','design_struct')

clearvars -except path.root howmany1 howmany2 average piccolo grande total EncodingResults

% Fix cross number 2 , type 1

load('Retr_Fix2_2.mat'); %(1-3)

trial_type_ISI = [design_struct.eventlist(:, 3)];
trial_type_ISI(trial_type_ISI>=2)=0;

howmany1(4,1)=sum(trial_type_ISI==1)
howmany2(4,1)=sum(trial_type_ISI==0)

ISI= [design_struct.eventlist(:, 4)]; %PTB uses seconds

average(4,1)=mean(ISI)
piccolo(4,1)=min(ISI)
grande(4,1)=max(ISI)
total(4,1)=sum(ISI)

design_struct.eventlist(:, 3)=trial_type_ISI;
save('Retr_Fix2_2_repl.mat','design_struct')

clearvars -except path.root howmany1 howmany2 average piccolo grande total EncodingResults


% Together
RetrievalResults = array2table([howmany1 howmany2 piccolo grande average total],'VariableNames',{'Nstimuli1','Nstimuli2','Minimum','Maximum','Average','Total'},'RowNames',{'Retr_Fix_1_1' 'Retr_Fix_2_1' 'Retr_Fix_1_2' 'Retr_Fix_2_2'})


%% Write 
Rownames=["Enc_Fix_1_1"; "Enc_Fix_2_1"; "Enc_Fix_1_2" ;"Enc_Fix_2_2"; "Retr_Fix_1_1"; "Retr_Fix_2_1"; "Retr_Fix_1_2"; "Retr_Fix_2_2"]
Rownames = array2table(Rownames)
T = [EncodingResults; RetrievalResults]; 
T1= [Rownames,T ]
writetable(T1,'1_ISI_Info.txt')  
writetable(T1,'1_ISI_Info.xlsx')




