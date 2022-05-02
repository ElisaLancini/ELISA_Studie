%% DataPreparation for GLM - Elisa-Sttudie 2021
%Log
% last update 24.10.2021
% Add trial definition so you alreaedy know which to extract
% Check row number position
clear
IDs = [1051 2027 3001 4052 5 6002 7003 8004 9005];
path_data='/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/results/raw/behavioural/';
path_res='/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/results/behavioural_data_prepared/';

for n=1:length(IDs)
    participantsID_behavioural=IDs(n)
    
    % In case a task was not completed, use the last backup file (like for participant 7:
    % To be done
    
    %% ENCODING
    load([path_data num2str(participantsID_behavioural) '_2.mat']);
    events={};
    
    % calculate duration
    duration.fixation1 = timing.fixation1_offset   - timing.fixation1_onset ;  % Already in seconds (to match with trigger time, that is calculated with "Secs")
    duration.fixation2 = timing.fixation2_offset   - timing.fixation2_onset ;  % Already in seconds
    duration.room      = timing.room_offset - timing.room_onset ;              % Already in seconds
    duration.empty     = timing.empty_offset - timing.empty_onset ;            % Already in seconds
    duration.selection = timing.selection_offset - timing.selection_onset ;    % Already in seconds
    duration.feedback  = timing.feedback_offset - timing.feedback_onset ;      % Already in seconds
    
    % Create eventlist
    a= [1:6:960];
    b= [2:6:960];
    c= [3:6:960];
    d= [4:6:960];
    e= [5:6:960];
    f= [6:6:960];
    
    for i=1:160
        ii=i-1;
        %fixation 1
        events{a(i),1}=timing.fixation1_onset(1,i);
        events{a(i),2}=timing.fixation1_offset(1,i);
        events{a(i),3}=duration.fixation1  (1,i);
        events{a(i),4}= 'fixation_1';
        events{a(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; % type of stimulus
        events{a(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  % stimulus name
        events{a(i),9}=stimuli.row_randomization(i,1);            % row reference
        if i>1 == 1
            events{a(i),10}= timing.fixation1_onset(1,i) + timing.fixation1_onset(1,ii); % Onsets as cumulative events, from second stimulus on
        else
            events{a(i),10}= timing.fixation1_onset(1,i);                                % Onset of the first stimulus doesnt need to be cumulative
        end
        events{a(i),11}=(events{a(i),10}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %room
        events{b(i),1}=timing.room_onset  (1,i);
        events{b(i),2}=timing.room_offset(1,i);
        events{b(i),3}=duration.room (1,i);
        events{b(i),4}= 'room';
        events{b(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; % type of stimulus
        events{b(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  % stimulus name
        events{b(i),9}=stimuli.row_randomization(i,1);            % row reference
        if i>1 == 1
            events{b(i),10}= timing.room_onset(1,i) + timing.room_onset(1,ii);% Onsets as cumulative events, from second stimulus on
        else
            events{b(i),10}= timing.room_onset(1,i); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{b(i),11}=(events{b(i),10}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %empty
        events{c(i),1}=timing.empty_onset (1,i);
        events{c(i),2}=timing.empty_offset(1,i);
        events{c(i),3}=duration.empty (1,i);
        events{c(i),4}= 'empty';
        events{c(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{c(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{c(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1 == 1
            events{c(i),10}= timing.empty_onset(1,i) + timing.empty_onset(1,ii);% Onsets as cumulative events, from second stimulus on
        else
            events{c(i),10}= timing.empty_onset(1,i); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{c(i),11}=(events{c(i),10}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %fixation 2
        events{d(i),1}=timing.fixation2_onset(1,i);
        events{d(i),2}=timing.fixation2_offset(1,i);
        events{d(i),3}=duration.fixation2 (1,i);
        events{d(i),4}= 'fixation_2';
        events{d(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{d(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{d(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1 == 1
            events{d(i),10}= timing.fixation2_onset(1,i) + timing.fixation2_onset(1,ii);% Onsets as cumulative events, from second stimulus on
        else
            events{d(i),10}= timing.fixation2_onset(1,i); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{d(i),11}=(events{d(i),10}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        % selection
        events{e(i),1}=timing.selection_onset  (1,i);
        events{e(i),2}=timing.selection_offset(1,i);
        events{e(i),3}=duration.selection (1,i);
        events{e(i),4}= 'selection';
        events{e(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{e(i),8}=stimuli.stimuli_randomized{1, 2}{i, 1}  ;  %stimulus name
        events{e(i),6}=  answer.all_answers  (i,1); %attach correspondent answer
        events{e(i),5}=answer.response_time  (i,1); %reaction time
        events{e(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1 == 1
            events{e(i),10}= timing.selection_onset(1,i) + timing.selection_onset(1,ii);% Onsets as cumulative events, from second stimulus on
        else
            events{e(i),10}= timing.selection_onset(1,i); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{e(i),11}=(events{e(i),10}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        % feedback
        events{f(i),1}=timing.feedback_onset  (1,i);
        events{f(i),2}=timing.feedback_offset(1,i);
        events{f(i),3}=duration.feedback (1,i);
        events{f(i),4}= 'feedback';
        events{f(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{f(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{f(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1
            events{f(i),10}= timing.feedback_onset(1,i) + timing.feedback_onset(1,ii);% Onsets as cumulative events, from second stimulus on
        else
            events{f(i),10}= timing.feedback_onset(1,i); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{f(i),11}=(events{f(i),10}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
    end
    
    events_encoding = array2table(events);
    events_encoding.Properties.VariableNames = {'onset' 'offset' 'duration' 'event' 'RT' 'answer' 'type_of_trial' 'stimulus_name' 'row' 'onset_cumulative' 'onsets_cumulative_trigger_adj' };
    clearvars -except participantsID_behavioural events_encoding path_data path_res IDs
    
    %% RETRIEVAL 0 (short delay)
    events={};
    load([path_data num2str(participantsID_behavioural) '_4.mat']);
    
    
    % calculate duration
    duration.fixation1 = timing.fixation1_offset   - timing.fixation1_onset ;
    duration.cue     = timing.cue_offset - timing.cue_onset ;
    duration.classification   = timing.classification_offset - timing.classification_onset ;
    duration.fixation2 = timing.fixation2_offset   - timing.fixation2_onset ;
    duration.selection   = timing.selection_offset - timing.selection_onset ;
    
    % Create eventlist
    a= [1:5:400];
    b= [2:5:400];
    c= [3:5:400];
    d= [4:5:400];
    e= [5:5:400];
    
    % %Are reported in columns or in rows? If column, then transform to rows
    % if size(timing.fixation1_onset)==[80,1] %get the numbers of columns, if 80,1 means that it is in vertical
    % timing.fixation1_onset=timing.fixation1_onset.';
    % timing.fixation1_offset=timing.fixation1_offset.';
    % timing.cue_onset=timing.cue_onset.';
    % timing.cue_offset=timing.cue_offset.';
    % timing.classification_onset=timing.classification_onset.';
    % timing.classification_offset=timing.classification_offset.';
    % timing.fixation2_onset=timing.fixation2_onset.';
    % timing.fixation2_offset=timing.fixation2_offset.';
    % timing.selection_onset=timing.selection_onset.';
    % timing.selection_offset=timing.selection_offset.';
    % end
    
    % record type of retrieval (0=short,1=long)
    for i=1:80
        ii=i-1;
        
        %fixation 1
        events{a(i),1}=timing.fixation1_onset(i,1);
        events{a(i),2}=timing.fixation1_offset(i,1);
        events{a(i),3}=duration.fixation1(i,1);
        events{a(i),4}= 'fixation_1';
        events{a(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{a(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{a(i),11}= 0; %type of retrieval
        events{a(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 == 1
            events{a(i),13}= timing.fixation1_onset(i,1) + timing.fixation1_onset(ii,1); % Onsets as cumulative events, from second stimulus on
        else
            events{a(i),13}= timing.fixation1_onset(i,1);                                % Onset of the first stimulus doesnt need to be cumulative
        end
        events{a(i),14}=(events{a(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %room
        events{b(i),1}=timing.cue_onset(i,1);
        events{b(i),2}=timing.cue_offset(i,1);
        events{b(i),3}=duration.cue (i,1);
        events{b(i),4}= 'cue';
        events{b(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{b(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{b(i),11}= 0; %type of retrieval
        events{b(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 == 1
            events{b(i),13}= timing.cue_onset(i,1) + timing.cue_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{b(i),13}= timing.cue_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{b(i),14}=(events{b(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %classification
        events{c(i),1}=timing.classification_onset (i,1);
        events{c(i),2}=timing.classification_offset(i,1);
        events{c(i),3}=duration.classification(i,1);
        events{c(i),4}= 'categorization';
        events{c(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{c(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{c(i),11}= 0; %type of retrieval
        events{c(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{c(i),5}=      answer.response_time_question  (i,1); %attach correspondent answer
        events{c(i),6}=      answer.all_classification_answer(i,1); %attach correspondent answer
        if i>1 == 1
            events{c(i),13}= timing.classification_onset(i,1) + timing.classification_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{c(i),13}= timing.classification_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{c(i),14}=(events{c(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %fixation 2
        events{d(i),1}=timing.fixation2_onset(i,1);
        events{d(i),2}=timing.fixation2_offset(i,1);
        events{d(i),3}=duration.fixation2(i,1);
        events{d(i),4}= 'fixation_2';
        events{d(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{d(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{d(i),11}= 0; %type of retrieval
        events{d(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 == 1
            events{d(i),13}= timing.fixation2_onset(i,1) + timing.fixation2_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{d(i),13}= timing.fixation2_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{d(i),14}=(events{d(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %selection
        events{e(i),1}=timing.selection_onset(i,1);
        events{e(i),2}=timing.selection_offset(i,1);
        events{e(i),3}=duration.selection (i,1);
        events{e(i),4}= 'selection';
        events{e(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{e(i),10}=stimuli.stimuli_randomized{1, 2}{i, 1}  ;  %stimulus name
        events{e(i),11}= 0; %type of retrieval
        events{e(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{e(i),7}=  answer.response_time  (i,1); %attach correspondent answer
        events{e(i),8}=  answer.all_selection_answers(i,1); %attach correspondent answer
        if i>1 == 1
            events{e(i),13}= timing.selection_onset(i,1) + timing.selection_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{e(i),13}= timing.selection_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{e(i),14}=(events{e(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
    end
    
    events_retrieval0=events;
    clearvars -except  participantsID_behavioural events_retrieval0 events_encoding path_data path_res IDs
    
    
    %% RETRIEVAL 1 (long delay)
    load([path_data num2str(participantsID_behavioural) '_6.mat']);
    events={};
    
    % Create eventlist
    a= [1:5:400];
    b= [2:5:400];
    c= [3:5:400];
    d= [4:5:400];
    e= [5:5:400];
    
    
    % %Are reported in columns or in rows? If column, then transform to rows
    if size(timing.classification_onset)==[1,80] %get the numbers of columns, if 80,1 means that it is in vertical
        timing.fixation1_onset=timing.fixation1_onset.';
        timing.fixation1_offset=timing.fixation1_offset.';
        timing.cue_onset=timing.cue_onset.';
        timing.cue_offset=timing.cue_offset.';
        timing.classification_onset=timing.classification_onset.';
        timing.classification_offset=timing.classification_offset.';
        timing.fixation2_onset=timing.fixation2_onset.';
        timing.fixation2_offset=timing.fixation2_offset.';
        timing.selection_onset=timing.selection_onset.';
        timing.selection_offset=timing.selection_offset.';
    end
    
    % calculate duration
    duration.fixation1        = timing.fixation1_offset   - timing.fixation1_onset ;
    duration.cue              = timing.cue_offset - timing.cue_onset ;
    duration.classification   = timing.classification_offset - timing.classification_onset ;
    duration.fixation2        = timing.fixation2_offset   - timing.fixation2_onset ;
    duration.selection        = timing.selection_offset - timing.selection_onset;
    
    % for those IDs with missing timing.fixation1_onset and _offset, upload ISI
    % file and use that one as reference
    if length(duration.fixation1)==40
        ISI=load([path_data num2str(participantsID_behavioural) '_6_randinfo.mat'],'ISI_1');
        duration.fixation1(41:80)=ISI.ISI_1(41:80);
        timing.fixation1_onset(41:80)=timing.fixation2_onset(41:80)-duration.fixation1(41:80);
        timing.fixation1_offset(41:80)=timing.fixation1_onset(41:80)+duration.fixation1(41:80);
    end
    
    % record type of retrieval (0=short,1=long)
    
    for i=1:80
        ii=i-1;
        
        %fixation 1
        events{a(i),1}=timing.fixation1_onset(i,1);
        events{a(i),2}=timing.fixation1_offset(i,1);
        events{a(i),3}=duration.fixation1(i,1);
        events{a(i),4}= 'fixation_1';
        events{a(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{a(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{a(i),11}= 1; %type of retrieval
        events{a(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 == 1
            events{a(i),13}= timing.fixation1_onset(i,1) + timing.fixation1_onset(ii,1); % Onsets as cumulative events, from second stimulus on
        else
            events{a(i),13}= timing.fixation1_onset(i,1);                                % Onset of the first stimulus doesnt need to be cumulative
        end
        events{a(i),14}=(events{a(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %room
        events{b(i),1}=timing.cue_onset(i,1);
        events{b(i),2}=timing.cue_offset(i,1);
        events{b(i),3}=duration.cue (i,1);
        events{b(i),4}= 'cue';
        events{b(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{b(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{b(i),11}= 1; %type of retrieval
        events{b(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 == 1
            events{b(i),13}= timing.cue_onset(i,1) + timing.cue_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{b(i),13}= timing.cue_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{b(i),14}=(events{b(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %classification
        events{c(i),1}=timing.classification_onset (i,1);
        events{c(i),2}=timing.classification_offset(i,1);
        events{c(i),3}=duration.classification(i,1);
        events{c(i),4}= 'categorization';
        events{c(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{c(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{c(i),11}= 1; %type of retrieval
        events{c(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{c(i),5}=      answer.response_time_question  (i,1); %attach correspondent answer
        events{c(i),6}=      answer.all_classification_answer(i,1); %attach correspondent answer
        if i>1 == 1
            events{c(i),13}= timing.classification_onset(i,1) + timing.classification_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{c(i),13}= timing.classification_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{c(i),14}=(events{c(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %fixation 2
        events{d(i),1}=timing.fixation2_onset(i,1);
        events{d(i),2}=timing.fixation2_offset(i,1);
        events{d(i),3}=duration.fixation2(i,1);
        events{d(i),4}= 'fixation_2';
        events{d(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{d(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{d(i),11}= 1; %type of retrieval
        events{d(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 == 1
            events{d(i),13}= timing.fixation2_onset(i,1) + timing.fixation2_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{d(i),13}= timing.fixation2_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{d(i),14}=(events{d(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
        %selection
        events{e(i),1}=timing.selection_onset(i,1);
        events{e(i),2}=timing.selection_offset(i,1);
        events{e(i),3}=duration.selection (i,1);
        events{e(i),4}= 'selection';
        events{e(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{e(i),10}=stimuli.stimuli_randomized{1, 2}{i, 1}  ;  %stimulus name
        events{e(i),11}= 1; %type of retrieval
        events{e(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{e(i),7}=  answer.response_time  (i,1); %attach correspondent answer
        events{e(i),8}=  answer.all_selection_answers(i,1); %attach correspondent answer
        if i>1 == 1
            events{e(i),13}= timing.selection_onset(i,1) + timing.selection_onset(ii,1);% Onsets as cumulative events, from second stimulus on
        else
            events{e(i),13}= timing.selection_onset(i,1); % Onset of the first stimulus doesnt need to be cumulative
        end
        events{e(i),14}=(events{e(i),13}-timing.triggers_startingpoints(1,1)); %enstablish trigger as 0
        
    end
    
    events_retrieval = vertcat(events_retrieval0,events);
    events_retrieval=  array2table(events_retrieval);
    events_retrieval.Properties.VariableNames = {'onset' 'offset' 'duration' 'event' 'RT_classif' 'answer_classif' 'RT_answer' 'answer' 'type_of_trial' 'stimulus_name' 'retrieval_number' 'row' 'onset_cumulative' 'onsets_cumulative_trigger_adj' };
    
    clearvars -except  participantsID_behavioural events_retrieval events_encoding path_res IDs path_data
    
    cd(path_res)
    filename = ([num2str(participantsID_behavioural) '_behavioural_data.mat']);
    save(filename)
end
