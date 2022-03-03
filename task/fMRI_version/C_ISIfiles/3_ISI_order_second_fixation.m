%% Path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path.root    = '/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';
%path.root    = '/Users/elisalancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';
cd(path.root)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Encoding : Fix 1 type 1 (A) - Fix 2 type 1 (B) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=load('Enc_Fix1_1_merged.mat'); % 
B=load('Enc_Fix2_1_merged.mat'); % To be sorted

ISI_A= [A.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_A=[A.design_struct.eventlist(:, 3)];
temp_A= [ISI_A trial_type_ISI_A];

ISI_B= [B.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_B=[B.design_struct.eventlist(:, 3)];
temp_B= [ISI_B trial_type_ISI_B];

%find where are trial stimuli and control stimuli
indexones_A = find([trial_type_ISI_A(:,:)] == 1)';
indexzeros_A = find([trial_type_ISI_A(:,:)] == 0)';

% recreate a second fixation cross list , based on the first.
indexones_B = find([trial_type_ISI_B(:,:)] == 1)';
indexzeros_B = find([trial_type_ISI_B(:,:)] == 0)';

% replace rows
temp_B_ordered=[];

for i = 1:80 % first block
    m = indexzeros_A(i); %new position of the '0' stimuli 
    n = indexzeros_B(i);% old position of the '0' stimuli
    
    temp_B_ordered(m,1)=temp_B(n,1);
    temp_B_ordered(m,2)=temp_B(n,2);
   
end

for ii = 1:80 %second block
    m = indexones_A(ii); %new position of the '0' stimuli (position ITI)
    n = indexones_B(ii);% old position of the '0' stimuli
    
    temp_B_ordered(m,1)=temp_B(n,1);
    temp_B_ordered(m,2)=temp_B(n,2);
end

 
% Save
design_struct.eventlist(:, 3)=temp_B_ordered(:,2);
design_struct.eventlist(:, 4)=temp_B_ordered(:,1);
save('Enc_Fix2_1_merged_sorted.mat','design_struct')


clearvars -except path;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Encoding: Fix 1 type 2 (A) - Fix 2 type 2 (B) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C=load('Enc_Fix1_2_merged.mat'); % 
D=load('Enc_Fix2_2_merged.mat'); % To be sorted

ISI_C= [C.design_struct.eventlist(:, 4)]; %PTD uses seconds
triCl_type_ISI_C=[C.design_struct.eventlist(:, 3)];
temp_C= [ISI_C triCl_type_ISI_C];
 
ISI_D= [D.design_struct.eventlist(:, 4)]; %PTD uses seconds
triCl_type_ISI_D=[D.design_struct.eventlist(:, 3)];
temp_D= [ISI_D triCl_type_ISI_D];
 
%find where Cre triCl stimuli Cnd control stimuli
indexones_C = find([triCl_type_ISI_C(:,:)] == 1)';
indexzeros_C = find([triCl_type_ISI_C(:,:)] == 0)';
 
% recreCte C second fixCtion cross list , DCsed on the first.
indexones_D = find([triCl_type_ISI_D(:,:)] == 1)';
indexzeros_D = find([triCl_type_ISI_D(:,:)] == 0)';
 
% replCce rows
temp_D_ordered=[];
 
for i = 1:80 % first Dlock
    m = indexzeros_C(i); %new position of the '0' stimuli 
    n = indexzeros_D(i);% old position of the '0' stimuli
    
    temp_D_ordered(m,1)=temp_D(n,1);
    temp_D_ordered(m,2)=temp_D(n,2);
   
end
 
for ii = 1:80 %second Dlock
    m = indexones_C(ii); %new position of the '0' stimuli (position ITI)
    n = indexones_D(ii);% old position of the '0' stimuli
    
    temp_D_ordered(m,1)=temp_D(n,1);
    temp_D_ordered(m,2)=temp_D(n,2);
end
 
% Save
design_struct.eventlist(:, 3)=temp_D_ordered(:,2);
design_struct.eventlist(:, 4)=temp_D_ordered(:,1);
save('Enc_Fix2_2_merged_sorted.mat','design_struct')

clearvars -except path;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieval : Fix 1 type 1 (A) - Fix 2 type 1 (B) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=load('Retr_Fix1_1_repl.mat'); % 
B=load('Retr_Fix2_1_repl.mat'); % To be sorted

ISI_A= [A.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_A=[A.design_struct.eventlist(:, 3)];
temp_A= [ISI_A trial_type_ISI_A];

ISI_B= [B.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_B=[B.design_struct.eventlist(:, 3)];
temp_B= [ISI_B trial_type_ISI_B];

%find where are trial stimuli and control stimuli
indexones_A = find([trial_type_ISI_A(:,:)] == 1)';
indexzeros_A = find([trial_type_ISI_A(:,:)] == 0)';

% recreate a second fixation cross list , based on the first.
indexones_B = find([trial_type_ISI_B(:,:)] == 1)';
indexzeros_B = find([trial_type_ISI_B(:,:)] == 0)';

% replace rows
temp_B_ordered=[];

for i = 1:40 % first block
    m = indexzeros_A(i); %new position of the '0' stimuli 
    n = indexzeros_B(i);% old position of the '0' stimuli
    
    temp_B_ordered(m,1)=temp_B(n,1);
    temp_B_ordered(m,2)=temp_B(n,2);
   
end

for ii = 1:40 %second block
    m = indexones_A(ii); %new position of the '0' stimuli (position ITI)
    n = indexones_B(ii);% old position of the '0' stimuli
    
    temp_B_ordered(m,1)=temp_B(n,1);
    temp_B_ordered(m,2)=temp_B(n,2);
end

 
% Save
design_struct.eventlist(:, 3)=temp_B_ordered(:,2);
design_struct.eventlist(:, 4)=temp_B_ordered(:,1);
save('Retr_Fix2_1_repl_sorted.mat','design_struct')


clearvars -except path;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retr: Fix 1 type 2 (A) - Fix 2 type 2 (B) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C=load('Retr_Fix1_1_repl.mat'); % 
D=load('Retr_Fix2_1_repl.mat'); % To be sorted
 
ISI_C= [C.design_struct.eventlist(:, 4)]; %PTD uses seconds
trial_type_ISI_C=[C.design_struct.eventlist(:, 3)];
temp_C= [ISI_C trial_type_ISI_C];
 
ISI_D= [D.design_struct.eventlist(:, 4)]; %PTD uses seconds
trial_type_ISI_D=[D.design_struct.eventlist(:, 3)];
temp_D= [ISI_D trial_type_ISI_D];
 
%find where are trial stimuli and control stimuli
indexones_C = find([trial_type_ISI_C(:,:)] == 1)';
indexzeros_C = find([trial_type_ISI_C(:,:)] == 0)';
 
% recreate a second fixation cross list , based on the first.
indexones_D = find([trial_type_ISI_D(:,:)] == 1)';
indexzeros_D = find([trial_type_ISI_D(:,:)] == 0)';
 
% replace rows
temp_D_ordered=[];
 
for i = 1:40 % first block
    m = indexzeros_C(i); %new position of the '0' stimuli 
    n = indexzeros_D(i);% old position of the '0' stimuli
    
    temp_D_ordered(m,1)=temp_D(n,1);
    temp_D_ordered(m,2)=temp_D(n,2);
   
end
 
for ii = 1:40 %second block
    m = indexones_C(ii); %new position of the '0' stimuli (position ITI)
    n = indexones_D(ii);% old position of the '0' stimuli
    
    temp_D_ordered(m,1)=temp_D(n,1);
    temp_D_ordered(m,2)=temp_D(n,2);
end
 
 
% Save
design_struct.eventlist(:, 3)=temp_D_ordered(:,2);
design_struct.eventlist(:, 4)=temp_D_ordered(:,1);
save('Retr_Fix2_2_repl_sorted.mat','design_struct')
 
 
clearvars -except path;

