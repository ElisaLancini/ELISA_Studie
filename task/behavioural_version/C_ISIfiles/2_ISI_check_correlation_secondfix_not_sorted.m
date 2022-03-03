% Path
path.root    = '/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';
% mac book laptop
%path.root    = '/Users/elisalancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';


cd(path.root)



%% Encoding 
% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 1)
A=load('Enc_Fix1_1.mat'); %(1-5)
B=load('Enc_Fix1_2.mat'); %(1-5)
ISI_AB= [A.design_struct.eventlist(:, 4); B.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_AB=[A.design_struct.eventlist(:, 3); B.design_struct.eventlist(:, 3)];


C=load('Enc_Fix2_1.mat'); %(1-3)
D=load('Enc_Fix2_2.mat'); %(1-3)
ISI_CD= [C.design_struct.eventlist(:, 4); D.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_CD=[C.design_struct.eventlist(:, 3); D.design_struct.eventlist(:, 3)];


[R,P] = corrcoef(ISI_AB,ISI_CD)
[R,P] = corrcoef(trial_type_ISI_AB,trial_type_ISI_CD) 


clearvars -except path.root 

% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 2)
E=load('Enc_Fix1_3.mat'); %(1-5)
F=load('Enc_Fix1_4.mat'); %(1-5)
ISI_EF= [E.design_struct.eventlist(:, 4); F.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_EF=[E.design_struct.eventlist(:, 3); F.design_struct.eventlist(:, 3)];

G=load('Enc_Fix2_3.mat'); %(1-3)
H=load('Enc_Fix2_4.mat'); %(1-3)
ISI_GH= [G.design_struct.eventlist(:, 4); H.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_GH=[G.design_struct.eventlist(:, 3); H.design_struct.eventlist(:, 3)];

[R,P] = corrcoef(ISI_EF,ISI_GH)
[R,P] = corrcoef(trial_type_ISI_EF,trial_type_ISI_GH) 


clearvars -except path.root 

%% Retrieval 
% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 1)
A=load('Retr_Fix1_1.mat'); %(1-5)

ISI_A= [A.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_A=[A.design_struct.eventlist(:, 3)];


B=load('Retr_Fix2_1.mat'); %(1-3)

ISI_B= [B.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_B=[B.design_struct.eventlist(:, 3)];

[R,P] = corrcoef(ISI_A,ISI_B)
[R,P] = corrcoef(trial_type_ISI_A,trial_type_ISI_B) 


clearvars -except path.root 

% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 2)
C=load('Retr_Fix1_1.mat'); %(1-5)

ISI_C= [C.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_C=[C.design_struct.eventlist(:, 3)];

D=load('Retr_Fix2_2.mat'); %(1-3)

ISI_D= [D.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_D=[D.design_struct.eventlist(:, 3)];

[R,P] = corrcoef(ISI_C,ISI_D) 
[R,P] = corrcoef(trial_type_ISI_C,trial_type_ISI_D) 

clearvars -except path.root 



