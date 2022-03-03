%% Path
clear
%path.root    = '/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';
%mac book laptop
path.root    = '/Users/elisalancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';

cd(path.root)

%% Encoding 
% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 1)
A=load('Enc_Fix1_1_merged.mat'); %(1-5)
ISI_A= A.design_struct.eventlist(:, 4);
trial_type_ISI_A=A.design_struct.eventlist(:, 3);

B =load('Enc_Fix2_1_merged_sorted.mat'); %(1-3)
ISI_B= B.design_struct.eventlist(:, 4);
trial_type_ISI_B=B.design_struct.eventlist(:, 3);
 
[R,P] = corrcoef(ISI_A,ISI_B)
p1=P;
[R,P] = corrcoef(trial_type_ISI_A,trial_type_ISI_B) 
p2=P;

enc1=horzcat(p1,p2);

    % Create timings list
    timings=repmat([0 7 0.80 0 3 3]',160,1);X=(1:6:960);Y=(4:6:960);timings_full=timings;
    trial_type_ISI_all=[trial_type_ISI_A; trial_type_ISI_B]; Z=(6:6:960);
    for i = 1:length(ISI_A)     
        x=X(i);placethis_1=ISI_A(i); timings_full(x,1)=placethis_1;
        y=Y(i);placethis_2=ISI_B(i); timings_full(y,1)=placethis_2;  
        z=Z(i);timings_full(x:z,2)=repmat(trial_type_ISI_A(i),6,1);
    end
        clear X Y Z x y z
        
    %Create onsets variables
    room_onsets(1)=timings_full(1);
    selection_onsets(1)=sum(timings_full(1:4));
    feedback_onsets(1)=sum(timings_full(1:5))
    
    Y=(8:6:960); 
    YA=(10:6:960); 
    YB=(11:6:960); 
    
 for i = 1:159 %(NOT 160 because first data is already calculated , see lines 41-41-43)
         
    room_onsets(i+1)=sum(timings_full(1:Y(i)));
    selection_onsets(i+1)=sum(timings_full(1:YA(i)));
    feedback_onsets(i+1)=sum(timings_full(1:YB(i)));
 end
 
    % couple those variables with trialtype
    room_onsets=room_onsets';
    room_onsets(:,2)=trial_type_ISI_A;
    selection_onsets=selection_onsets';
    selection_onsets(:,2)=trial_type_ISI_A;
    feedback_onsets=feedback_onsets';
    feedback_onsets(:,2)=trial_type_ISI_A;
    
    % extract onsets based on trial type
    room_task=room_onsets(room_onsets(:, 2) == 1, :) 
    selection_task=selection_onsets(room_onsets(:, 2) == 1, :) 
    feedback_task=feedback_onsets(room_onsets(:, 2) == 1, :) 
    
    room_control=room_onsets(room_onsets(:, 2) == 0, :) 
    selection_control=selection_onsets(room_onsets(:, 2) == 0, :) 
    feedback_control=feedback_onsets(room_onsets(:, 2) == 0, :)
    
    % extract trialtypes
    rooms = room_onsets(2:6:end,:);
    rooms1= rooms(:,2); 
    rooms2= rooms(:,2)+1; 

    selection = room_onsets(5:6:end,:);
    feedback = room_onsets(6:6:end,:);
    
    % couple those variables with trialtype
%    [R,P] = corrcoef(room_task(:,1),selection_task(:,1)) 
%        p3=P;
%    [R,P] = corrcoef(room_task(:,1),feedback_task(:,1)) 
%        p4=P;
%    [R,P] = corrcoef(room_control(:,1),selection_control(:,1)) 
%        p5=P;
%    [R,P] = corrcoef(room_control(:,1),feedback_control(:,1)) 
%        p6=P;
%    [R,P] = corrcoef(room_task(:,1),room_control(:,1)) 
%        p7=P;
%    [R,P] = corrcoef(selection_task(:,1),selection_control(:,1)) 
%        p8=P;
%    [R,P] = corrcoef(feedback_task(:,1),feedback_control(:,1)) 
%        p9=P;
        
%    enc1_type_of_trials=horzcat(p1,p2,p3,p4,p5,p6,p7,p8,p9);

    
clearvars -except enc1


% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 2)
C=load('Enc_Fix1_2_merged.mat'); %(1-5)
ISI_C= C.design_struct.eventlist(:, 4);
trial_type_ISI_C=C.design_struct.eventlist(:, 3);
 
D =load('Enc_Fix2_2_merged_sorted.mat'); %(1-3)
ISI_D= D.design_struct.eventlist(:, 4);
trial_type_ISI_D=D.design_struct.eventlist(:, 3);
 
[R,P] = corrcoef(ISI_C,ISI_D)
p1=P;
[R,P] = corrcoef(trial_type_ISI_C,trial_type_ISI_D) 
p2=P;

enc2=horzcat(p1,p2);

    % Create timings list
    timings=repmat([0 7 0.80 0 3 3]',160,1);X=(1:6:960);Y=(4:6:960);timings_full=timings;
    trial_type_ISI_all=[trial_type_ISI_C; trial_type_ISI_D]; Z=(6:6:960);
    for i = 1:length(ISI_C)     
        x=X(i);placethis_1=ISI_C(i); timings_full(x,1)=placethis_1;
        y=Y(i);placethis_2=ISI_D(i); timings_full(y,1)=placethis_2;  
        z=Z(i);timings_full(x:z,2)=repmat(trial_type_ISI_C(i),6,1);
    end
        clear X Y Z x y z
        
    %Create onsets variables
    room_onsets(1)=timings_full(1);
    selection_onsets(1)=sum(timings_full(1:4));
    feedback_onsets(1)=sum(timings_full(1:5))
    
    Y=(8:6:960); 
    YA=(10:6:960); 
    YB=(11:6:960); 
    
 for i = 1:159 %(NOT 160 because first data is already calculated , see lines 41-41-43)
         
    room_onsets(i+1)=sum(timings_full(1:Y(i)));
    selection_onsets(i+1)=sum(timings_full(1:YA(i)));
    feedback_onsets(i+1)=sum(timings_full(1:YB(i)));
 end
 
    % couple those variables with trialtype
    room_onsets=room_onsets';
    room_onsets(:,2)=trial_type_ISI_C;
    selection_onsets=selection_onsets';
    selection_onsets(:,2)=trial_type_ISI_C;
    feedback_onsets=feedback_onsets';
    feedback_onsets(:,2)=trial_type_ISI_C;
    
    % extract onsets based on trial type
    room_task=room_onsets(room_onsets(:, 2) == 1, :) 
    selection_task=selection_onsets(room_onsets(:, 2) == 1, :) 
    feedback_task=feedback_onsets(room_onsets(:, 2) == 1, :) 
    
    room_control=room_onsets(room_onsets(:, 2) == 0, :) 
    selection_control=selection_onsets(room_onsets(:, 2) == 0, :) 
    feedback_control=feedback_onsets(room_onsets(:, 2) == 0, :)
    
    % extract trialtypes
    rooms = room_onsets(2:6:end,:);
    rooms1= rooms(:,2); 
    rooms2= rooms(:,2)+1; 
 
    selection = room_onsets(5:6:end,:);
    feedback = room_onsets(6:6:end,:);
    
    % couple those variables with trialtype
%    [R,P] = corrcoef(room_task(:,1),selection_task(:,1)) 
%       p3=P;
%    [R,P] = corrcoef(room_task(:,1),feedback_task(:,1)) 
%        p4=P;
%    [R,P] = corrcoef(room_control(:,1),selection_control(:,1)) 
%        p5=P;
%    [R,P] = corrcoef(room_control(:,1),feedback_control(:,1)) 
%        p6=P;
%    [R,P] = corrcoef(room_task(:,1),room_control(:,1)) 
%        p7=P;
%    [R,P] = corrcoef(selection_task(:,1),selection_control(:,1)) 
%        p8=P;
%    [R,P] = corrcoef(feedback_task(:,1),feedback_control(:,1)) 
%        p9=P;
        
%    enc2_type_of_trials=horzcat(p1,p2,p3,p4,p5,p6,p7,p8,p9);


clearvars -except enc1 enc2


%% Retrieval 
% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 1)
A=load('Retr_Fix1_1_repl.mat'); %(1-5)

ISI_A= [A.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_A=[A.design_struct.eventlist(:, 3)];


B=load('Retr_Fix2_1_repl_sorted.mat'); %(1-3)

ISI_B= [B.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_B=[B.design_struct.eventlist(:, 3)];

[R,P] = corrcoef(ISI_A,ISI_B)
p1=P;
[R,P] = corrcoef(trial_type_ISI_A,trial_type_ISI_B) 
p2=P;

retr1=horzcat(p1,p2);

clearvars -except enc1 enc2 retr1

% Correlation between Fixation cross 1 and Fixation cross 2
% (Counterbalancing list = 2)
C=load('Retr_Fix1_2_repl.mat'); %(1-5)

ISI_C= [C.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_C=[C.design_struct.eventlist(:, 3)];

D=load('Retr_Fix2_2_repl_sorted.mat'); %(1-3)

ISI_D= [D.design_struct.eventlist(:, 4)]; %PTB uses seconds
trial_type_ISI_D=[D.design_struct.eventlist(:, 3)];

[R,P] = corrcoef(ISI_C,ISI_D) 
p1=P;
[R,P] = corrcoef(trial_type_ISI_C,trial_type_ISI_D) 
p2=P;

retr2=horzcat(p1,p2);

clearvars -except enc1 enc2 retr1 retr2

%% Concatenate and write

% Together
EncRes = array2table([vertcat(enc1,enc2)],'VariableNames',{'ISI_A_timing','ISI_B_timing', 'ISI_A_trialtype','ISI_B_trialtype'},'RowNames',{'ISI_A_timing','ISI_B_timing', 'ISI_A_trialtype','ISI_B_trialtype'})
RetrRes = array2table([vertcat(retr1,retr2)],'VariableNames',{'ISI_A_timing','ISI_B_timing', 'ISI_A_trialtype','ISI_B_trialtype'},'RowNames',{'ISI_A_timing','ISI_B_timing', 'ISI_A_trialtype','ISI_B_trialtype'})


% Write 
writetable(EncRes,'4_ISI_Check_correlation_aftersorting_enc.xlsx')  
writetable(RetrRes,'4_ISI_Check_correlation_aftersorting_retr.xlsx')




