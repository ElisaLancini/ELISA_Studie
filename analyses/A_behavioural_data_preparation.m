%% DataPreparation for GLM - Elisa-Sttudie 2021
%Log
% last update 24.10.2021
% Add trial definition so you alreaedy know which to extract
% Check row number position
clear
IDs = [1051 2027 3001 4052 5 6002 8004];
% IDs with problems
IDs_with_problems = [9005 7003];

path_data='/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/results/raw/behavioural/';
path_res='/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/results/behavioural_data_prepared/';

%% IDs [1051 2027 3001 4052 5 6002 8004];
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
        if i<=40
            trigger_time=timing.triggers_startingpoints(1,1);
        elseif i>=41 && i<=80
            trigger_time=timing.triggers_startingpoints(2,1);
        elseif i>=81 && i<=120
            trigger_time=timing.triggers_startingpoints(3,1);
        elseif i>=121 && i<=160
            trigger_time=timing.triggers_startingpoints(4,1);
        end
        
        %fixation 1
        events{a(i),1}=timing.fixation1_onset(1,i)-trigger_time;
        events{a(i),2}=timing.fixation1_offset(1,i)-trigger_time;
        events{a(i),3}=duration.fixation1(1,i);
        events{a(i),4}= 'fixation_1';
        events{a(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; % type of stimulus
        events{a(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  % stimulus name
        events{a(i),9}=stimuli.row_randomization(i,1);            % row reference
        if i>1 || i>41 || i>81 || i>121 
            events{a(i),10}= (events{a(i),1} + events{(a(i))-1,1}); % Onsets as cumulative events, from second stimulus on
        else
            events{a(i),10}= events{a(i),1};                                % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %room
        events{b(i),1}=timing.room_onset  (1,i)-trigger_time;
        events{b(i),2}=timing.room_offset(1,i)-trigger_time;
        events{b(i),3}=duration.room (1,i);
        events{b(i),4}= 'room';
        events{b(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; % type of stimulus
        events{b(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  % stimulus name
        events{b(i),9}=stimuli.row_randomization(i,1);            % row reference
        if i>1 || i>41 || i>81 || i>121 
            events{b(i),10}= (events{b(i),1} + events{(b(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{b(i),10}= events{b(i),1};  % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %empty
        events{c(i),1}=timing.empty_onset (1,i)-trigger_time;
        events{c(i),2}=timing.empty_offset(1,i)-trigger_time;
        events{c(i),3}=duration.empty (1,i);
        events{c(i),4}= 'empty';
        events{c(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{c(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{c(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1 || i>41 || i>81 || i>121 
            events{c(i),10}= (events{c(i),1} + events{(c(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{c(i),10}= events{c(i),1};  % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %fixation 2
        events{d(i),1}=timing.fixation2_onset(1,i)-trigger_time;
        events{d(i),2}=timing.fixation2_offset(1,i)-trigger_time;
        events{d(i),3}=duration.fixation2 (1,i);
        events{d(i),4}= 'fixation_2';
        events{d(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{d(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{d(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1 || i>41 || i>81 || i>121 
            events{d(i),10}= (events{d(i),1} + events{(d(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{d(i),10}= events{d(i),1};  % Onset of the first stimulus doesnt need to be cumulative
        end
        
        % selection
        events{e(i),1}=timing.selection_onset  (1,i)-trigger_time;
        events{e(i),2}=timing.selection_offset(1,i)-trigger_time;
        events{e(i),3}=duration.selection (1,i);
        events{e(i),4}= 'selection';
        events{e(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{e(i),8}=stimuli.stimuli_randomized{1, 2}{i, 1}  ;  %stimulus name
        events{e(i),6}=  answer.all_answers  (i,1); %attach correspondent answer
        events{e(i),5}=answer.response_time  (i,1); %reaction time
        events{e(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1 || i>41 || i>81 || i>121 
            events{e(i),10}= (events{e(i),1} + events{(e(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{e(i),10}= events{e(i),1};  % Onset of the first stimulus doesnt need to be cumulative
        end
        
        % feedback
        events{f(i),1}=timing.feedback_onset  (1,i)-trigger_time;
        events{f(i),2}=timing.feedback_offset(1,i)-trigger_time;
        events{f(i),3}=duration.feedback (1,i);
        events{f(i),4}= 'feedback';
        events{f(i),7}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{f(i),8}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{f(i),9}=stimuli.row_randomization(i,1);% row reference
        if i>1 || i>41 || i>81 || i>121 
            events{f(i),10}= (events{f(i),1} + events{(f(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{f(i),10}= events{f(i),1};  % Onset of the first stimulus doesnt need to be cumulative
        end
        
    end
    
    events_encoding = array2table(events);
    events_encoding.Properties.VariableNames = {'onset_adj' 'offset_adj' 'duration' 'event' 'RT' 'answer' 'type_of_trial' 'stimulus_name' 'row' 'onsets_cumulative_trigger_adj' };
    clearvars -except participantsID_behavioural events_encoding path_data path_res IDs
    
    %% RETRIEVAL 0 (short delay)

    load([path_data num2str(participantsID_behavioural) '_4.mat']);
    events={};
    
    format short g %format the numbers so that they are not expressed as log 
    
    % fix fixation1 timing, if any (data acquired before 02.05.2022)
    if length(timing.fixation1_onset)==40 || timing.fixation1_onset(41,1)==0 
        fixation_missing1_onset=load([path_data num2str(participantsID_behavioural) '_4_raw.mat'],'t_fixation_onset');
        fixation_missing1_offset=load([path_data num2str(participantsID_behavioural) '_4_raw.mat'],'t_fixation_offset');
        
        timing.fixation1_onset(41:80)=fixation_missing1_onset.t_fixation_onset(41:80);
        timing.fixation1_offset(41:80)=fixation_missing1_offset.t_fixation_offset(41:80);
    end
    
           
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
    
    
    % record type of retrieval (0=short,1=long)
    for i=1:80
        if i<=40
            trigger_time=timing.triggers_startingpoints(1,1);
        elseif i>=41 
            trigger_time=timing.triggers_startingpoints(2,1);
        end
        %fixation 1
        events{a(i),1}=timing.fixation1_onset(i,1)-trigger_time;
        events{a(i),2}=timing.fixation1_offset(i,1)-trigger_time;
        events{a(i),3}=duration.fixation1(i,1);
        events{a(i),4}= 'fixation_1';
        events{a(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{a(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{a(i),11}= 0; %type of retrieval
        events{a(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 || i>41 
            events{a(i),13}= (events{a(i),1} + events{(a(i))-1,1}); % Onsets as cumulative events, from second stimulus on
        else
            events{a(i),13}= events{a(i),1};                              % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %room
        events{b(i),1}=timing.cue_onset(i,1)-trigger_time;
        events{b(i),2}=timing.cue_offset(i,1)-trigger_time;
        events{b(i),3}=duration.cue (i,1);
        events{b(i),4}= 'cue';
        events{b(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{b(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{b(i),11}= 0; %type of retrieval
        events{b(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 || i>41  
            events{b(i),13}= (events{b(i),1} + events{(b(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{b(i),13}= events{b(i),1};    % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %classification
        events{c(i),1}=timing.classification_onset (i,1)-trigger_time;
        events{c(i),2}=timing.classification_offset(i,1)-trigger_time;
        events{c(i),3}=duration.classification(i,1);
        events{c(i),4}= 'categorization';
        events{c(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{c(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{c(i),11}= 0; %type of retrieval
        events{c(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{c(i),5}=      answer.response_time_question  (i,1); %attach correspondent answer
        events{c(i),6}=      answer.all_classification_answer(i,1); %attach correspondent answer
        if i>1 || i>41 
            events{c(i),13}= (events{c(i),1} + events{(c(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{c(i),13}= events{c(i),1};    % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %fixation 2
        events{d(i),1}=timing.fixation2_onset(i,1)-trigger_time;
        events{d(i),2}=timing.fixation2_offset(i,1)-trigger_time;
        events{d(i),3}=duration.fixation2(i,1);
        events{d(i),4}= 'fixation_2';
        events{d(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{d(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{d(i),11}= 0; %type of retrieval
        events{d(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 || i>41 
            events{d(i),13}= (events{d(i),1} + events{(d(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{d(i),13}= events{d(i),1};  % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %selection
        events{e(i),1}=timing.selection_onset(i,1)-trigger_time;
        events{e(i),2}=timing.selection_offset(i,1)-trigger_time;
        events{e(i),3}=duration.selection (i,1);
        events{e(i),4}= 'selection';
        events{e(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{e(i),10}=stimuli.stimuli_randomized{1, 2}{i, 1}  ;  %stimulus name
        events{e(i),11}= 0; %type of retrieval
        events{e(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{e(i),7}=  answer.response_time  (i,1); %attach correspondent answer
        events{e(i),8}=  answer.all_selection_answers(i,1); %attach correspondent answer
        if i>1 || i>41 
            events{e(i),13}= (events{e(i),1} + events{(e(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{e(i),13}= events{e(i),1};    % Onset of the first stimulus doesnt need to be cumulative
        end
        
    end
    
    events_retrieval0=events;
    clearvars -except  participantsID_behavioural events_retrieval0 events_encoding path_data path_res IDs
    
    
    %% RETRIEVAL 1 (long delay)
    load([path_data num2str(participantsID_behavioural) '_6.mat']);
    events={};
    format short g %format the numbers so that they are not expressed as log 
    
    % fix fixation1 timing, if any (data acquired before 02.05.2022)
    if  length(timing.fixation1_onset)==40 || timing.fixation1_onset(41,1)==0 
        fixation_missing1_onset=load([path_data num2str(participantsID_behavioural) '_6_raw.mat'],'t_fixation_onset');
        fixation_missing1_offset=load([path_data num2str(participantsID_behavioural) '_6_raw.mat'],'t_fixation_offset');
        
        timing.fixation1_onset(41:80)=fixation_missing1_onset.t_fixation_onset(41:80);
        timing.fixation1_offset(41:80)=fixation_missing1_offset.t_fixation_offset(41:80);
    end
    
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
   
    
    % record type of retrieval (0=short,1=long)
    
    for i=1:80
         if i<=40
            trigger_time=timing.triggers_startingpoints(1,1);
        elseif i>=41 
            trigger_time=timing.triggers_startingpoints(2,1);
        end       
        %fixation 1
        events{a(i),1}=timing.fixation1_onset(i,1)-trigger_time;
        events{a(i),2}=timing.fixation1_offset(i,1)-trigger_time;
        events{a(i),3}=duration.fixation1(i,1);
        events{a(i),4}= 'fixation_1';
        events{a(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{a(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{a(i),11}= 1; %type of retrieval
        events{a(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 || i>41 
            events{a(i),13}= (events{a(i),1} + events{(a(i))-1,1}); % Onsets as cumulative events, from second stimulus on
        else
            events{a(i),13}= events{a(i),1};                                % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %room
        events{b(i),1}=timing.cue_onset(i,1)-trigger_time;
        events{b(i),2}=timing.cue_offset(i,1)-trigger_time;
        events{b(i),3}=duration.cue (i,1);
        events{b(i),4}= 'cue';
        events{b(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{b(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{b(i),11}= 1; %type of retrieval
        events{b(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 || i>41 
            events{b(i),13}= (events{b(i),1} + events{(b(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{b(i),13}= events{b(i),1};     % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %classification
        events{c(i),1}=timing.classification_onset (i,1)-trigger_time;
        events{c(i),2}=timing.classification_offset(i,1)-trigger_time;
        events{c(i),3}=duration.classification(i,1);
        events{c(i),4}= 'categorization';
        events{c(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{c(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{c(i),11}= 1; %type of retrieval
        events{c(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{c(i),5}=      answer.response_time_question  (i,1); %attach correspondent answer
        events{c(i),6}=      answer.all_classification_answer(i,1); %attach correspondent answer
        if i>1 || i>41 
            events{c(i),13}= (events{c(i),1} + events{(c(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{c(i),13}= events{c(i),1} ;    % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %fixation 2
        events{d(i),1}=timing.fixation2_onset(i,1)-trigger_time;
        events{d(i),2}=timing.fixation2_offset(i,1)-trigger_time;
        events{d(i),3}=duration.fixation2(i,1);
        events{d(i),4}= 'fixation_2';
        events{d(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{d(i),10}=stimuli.stimuli_randomized{1, 1}{i, 1}  ;  %stimulus name
        events{d(i),11}= 1; %type of retrieval
        events{d(i),12}= stimuli.row_randomization(i,1); % row reference
        if i>1 || i>41 
            events{d(i),13}= (events{d(i),1} + events{(d(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{d(i),13}= events{d(i),1} ;     % Onset of the first stimulus doesnt need to be cumulative
        end
        
        %selection
        events{e(i),1}=timing.selection_onset(i,1)-trigger_time;
        events{e(i),2}=timing.selection_offset(i,1)-trigger_time;
        events{e(i),3}=duration.selection (i,1);
        events{e(i),4}= 'selection';
        events{e(i),9}=stimuli.stimuli_randomized{1, 6}{i, 1}   ; %type of stimulus
        events{e(i),10}=stimuli.stimuli_randomized{1, 2}{i, 1}  ;  %stimulus name
        events{e(i),11}= 1; %type of retrieval
        events{e(i),12}= stimuli.row_randomization(i,1); % row reference
        
        events{e(i),7}=  answer.response_time  (i,1); %attach correspondent answer
        events{e(i),8}=  answer.all_selection_answers(i,1); %attach correspondent answer
        if i>1 || i>41 
            events{e(i),13}= (events{e(i),1} + events{(e(i))-1,1});% Onsets as cumulative events, from second stimulus on
        else
            events{e(i),13}= events{e(i),1} ;     % Onset of the first stimulus doesnt need to be cumulative
        end
        
    end
    
    events_retrieval = vertcat(events_retrieval0,events);
    events_retrieval=  array2table(events_retrieval);
    events_retrieval.Properties.VariableNames = {'onset_adj' 'offset_adj' 'duration' 'event' 'RT_classif' 'answer_classif' 'RT_answer' 'answer' 'type_of_trial' 'stimulus_name' 'retrieval_number' 'row' 'onsets_cumulative_trigger_adj' };
    
    clearvars -except  participantsID_behavioural events_retrieval events_encoding path_res IDs path_data
    
    cd(path_res)
    filename = ([num2str(participantsID_behavioural) '_behavioural_data.mat']);
    save(filename)
end

%% IDs with problems


%% IDs From 3.05.2022

% ENCODING
% trigger break       seconds when trigger started from the beginning of the first fMRI sequence
% trigger break 2     seconds when trigger started from the beginning of the 2ns fMRI sequence
% trigger break 3     seconds when trigger started from the beginning of the 3rd fMRI sequence
% trigger break 4     seconds when trigger started from the beginning of the 4th fMRI sequence

onsets_part1=trigger_toc(:,2:11)-trigger_break;
onsets_part2=trigger_toc2(41:80,2:11)-trigger_break2;
onsets_part3=trigger_toc3(81:120,2:11)-trigger_break3;
onsets_part4=trigger_toc4(121:160,2:11)-trigger_break4;

% RETRIEVAL 
% trigger break:     seconds when trigger started from the beginning of the first fMRI sequence
% trigger break 2:   seconds when trigger started from the beginning of the second fMRI sequence

% trigger_toc - trigger break (set trigger time to 0 and everything else
% elapse based on that

onsets_part1=trigger_toc(:,2:11)-trigger_break; onsets_part1(:,11)=1;
onsets_part2=trigger_toc2(41:80,2:11)-trigger_break2; onsets_part2(:,11)=2;
onsets=vertcat(onsets_part1,onsets_part2)

events_retrieval=  array2table(onsets);
events_retrieval.Properties.VariableNames = {'onset_fixation1' 'offset_fixation1' 'onset_cue' 'offset_cue' 'onset_categorization' 'offset_categorization' 'onset_fixation2' 'offset_fixation2' 'sonet_selection' 'offset_selection' 'part' };
    

