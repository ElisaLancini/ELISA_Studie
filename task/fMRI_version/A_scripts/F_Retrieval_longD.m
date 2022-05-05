%%%%%%%%%%%%%%%%%%%%% (D1) Retrieval - Long delay
%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%4ttttttttttttttttttttttttt4tttttttttttttttte
%% LOG
%
% 08.10.2021 : 
% - Ho aggiunt negli input files il waiting pic
%- messa la possibilita di mantenere la schermata finale fino a che non premo la e. 
% - All inizio di ogni sezione c e la variabile run , che viene usata per trigger_time
% - Ho aggiunto timing.wait_onset and offest alla lista di variabili da
% memorizzare

% - c e una pausa, ma non viene letta perche ho messo un numero di trials
% maggiore di quelli usati in questo script (i=40) quindi non avviene

% 14.10.2021 : Re-check: positivo
% 22.02.2022 : In the dialog box 
 %- "Participant number" is replaced with "Randonummer"
 % - "Append an R" is replaced with "Add "2" to the Randonummer"
 % And code changed, not an R but a 2 in case of repetition

% 03.03.2021: Error fixed
% fix1 and fix2 for condition A==2 were wrong. Fixed

%% Inizialising + Part 1
clc
clear KbCheck;
clearvars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1. Set paths
path.root    = 'D:\Elisa\ELISA-Studie\';
path.task    = [ path.root 'A_scripts']; %Stimlist is here
path.sti     = 'D:\Elisa\PlaceObjectTask\Stimuli\Place_object\A_All_stimuli\';
path.res     = [ path.root 'D_results\'];
path.input   = [ path.root 'B_inputfiles\'];
path.config  = [ path.root 'C_ISIfiles\'];
%path.ptb   =  'C:/Users/lancini/Documents/MATLAB/Psychtoolbox/';% Path PTB
%path.gstreamer= 'C:\gstreamer\1.0\x86_64\bin';
%addpath(genpath(path.ptb));
addpath(genpath(path.task));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2. Subject infos

% Subject informations
input_prompt = {'Randonummer'; 'Condition A';'Condition B';'Condition C'; 'Session (1=A, 2=B, 3=C, 4=D, 5=E, 6=F)'};
input_defaults     = {'01','1','1','1','99'}; % Mostra input default per non guidare l'inserimento
input_answer = inputdlg(input_prompt, 'Informations', 1, input_defaults);
clear input_defaults input_prompt
%Modifiy class of variables
ID          = str2num(input_answer{1,1});
ConditionA  = str2num(input_answer{2,1}); % ISI randomization
ConditionB  = str2num(input_answer{3,1}); % Yes no counterbalancing
ConditionC  = str2num(input_answer{4,1}); % Stimuli to present from encoding session
Session     = str2num(input_answer{5,1});

% Check if is the experimenter is using the right script
if Session ~= 6
    errordlg('You are running the wrong script','Session error');
    return
end

% Check if Conditions are >1 and <2 , otherwise error will occur

if ConditionA > 2 || ConditionB > 2 || ConditionC > 2 || ConditionA == 0 || ConditionB == 0||ConditionC == 0
    errordlg('Condition does not eist, check','Condition error');
    return
end

% Check if data already exist
cd(path.res)
if exist([num2str(ID) '_' num2str(Session) '_randinfo.mat']) == 2
    check_prompt = {'(1) Add "2" to the Randonummer / (2) Overwrite /(3) Break'};
    check_defaults     = {'1'}; % default input
    check_answer = inputdlg(check_prompt, 'Data already exist!', 1, check_defaults);
    check_decision= str2double(check_answer); % Depending on the decision..
    if check_decision == 1
        ID= [num2str(ID) '2']; %add 2 to filename
    elseif check_decision == 3  %break
        return;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3. Load settings
cd(path.input)
F_Settings_retrieval;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4. Pre allocate

stimuli_list_ordered= cell(1,7); %Stimuli sorted by ITI order

response_key=zeros(numTrials,1);
response_key_question=zeros(numTrials,1);
response_time=zeros(numTrials,1);
response_time_question=zeros(numTrials,1);
response_kbNum=zeros(numTrials,1);
response_kbNum_question=zeros(numTrials,1);

idx=[]; %Index of cue
time_pause=zeros(1,70);
time_end=999;
events=cell(1,2);


global time_escape_mr;
time_escape_mr = 0;

global time_trigger_mr;
time_trigger_mr=zeros(numTrials*2,5);

global counter;

global i;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 5. Load stimuli list from encoding session
%load stimuli_list_ordered in the encoding session
cd(path.res)
load([num2str(ID) '_2_' 'randinfo'],'rows_rand1');
load([num2str(ID) '_2_' 'randinfo'],'rows_rand2');
load([num2str(ID) '_2_' 'randinfo'],'stimuli_list');
stimuli_list_encoding=stimuli_list;
rows_rand1_encoding=num2cell(rows_rand1);
rows_rand2_encoding=num2cell(rows_rand2);

clear rows_ordered stimuli_list_ordered stimuli_list rows_rand1 rows_rand2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cerca in rows rand gli 1 e gli 0

% trova la riga in cui gli stimoli del primo blocco sono andate a finire
A1_ones_rows=(1:40);  %Prima parte
A1_zeros_rows=(1:40);

A2_ones_rows=(1:40);  %Seconda parte (altra met?)
A2_zeros_rows=(1:40);

for x=1:40
%     A1_ones_rows(x)=find([rows_rand1_encoding{:,1}] == x);
    A1_ones_rows(x)=(rows_rand1_encoding{x,1});
    A2_ones_rows(x)=(rows_rand2_encoding{x,1});
end
 
for x=1:40
%     A1_zeros_rows(x)=find([rows_rand1_encoding{:,1}] == (x+50));
    A1_zeros_rows(x)=(rows_rand1_encoding{x+40,1});
    A2_zeros_rows(x)=(rows_rand2_encoding{x+40,1});
end

% Crea parte A , divisa in due e parte B (altra met?) divisa in due
A1_1= [A1_ones_rows(1:20) A1_zeros_rows(1:20)];
A1_2= [A1_ones_rows(21:40) A1_zeros_rows(21:40)];

B1_1= [A2_ones_rows(1:20) A2_zeros_rows(1:20)];
B1_2= [A2_ones_rows(21:40) A2_zeros_rows(21:40)];


% Unifica
    if ConditionC==1
         list=[A1_2 B1_1];
%        list=[A1_1 B1_2];
    elseif ConditionC==2
         list=[A1_1 B1_2];
%        list=[A1_2 B1_1];
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Build up the stimuli list based on the indices
% and randomize it at the same time

stimuli_list= cell(1,7);

rows=(1:numTrials); %From1 to 70
rows_rand=rows(randperm(length(rows)))'; % Randomize the order

for n= 1:numTrials
    x=list(n); %from the encoding list, pick up the element selcted...
    y=rows_rand(n); %and put it in this randomized position
 stimuli_list{1, 1}{y, 1} = stimuli_list_encoding{1, 1}{x, 1};
 stimuli_list{1, 2}{y, 1} = stimuli_list_encoding{1, 2}{x, 1};  
 stimuli_list{1, 3}{y, 1} = stimuli_list_encoding{1, 3}{x, 1};  
 stimuli_list{1, 4}{y, 1} = stimuli_list_encoding{1, 4}{x, 1};  
 stimuli_list{1, 5}{y, 1} = stimuli_list_encoding{1, 5}{x, 1};  
 stimuli_list{1, 6}{y, 1} = stimuli_list_encoding{1, 6}{x, 1}; % trialt ype
 stimuli_list{1, 7}{y, 1} = stimuli_list_encoding{1, 7}{x, 1}; % cue type
end

clear rows_num rows_ordered_encoding_* first_part* second_part* pos_1 pos_2 n x y type x n

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ---------- Create matrix of stimuli depending on ISI trialtype ------- %

%  Load ITI
cd(path.config);

if ConditionA ==1
    fix1=load('Retr_Fix1_1_repl.mat');
    fix2=load('Retr_Fix2_1_repl_sorted.mat');
elseif ConditionA ==2
    fix1=load('Retr_Fix1_2_repl.mat');
    fix2=load('Retr_Fix2_2_repl_sorted.mat');
elseif exist(ConditionA,'var')== 0
    check_conditionA = {'Please specify condition A'};
    check_defaults     = {'1'}; % default input
    check_answer = inputdlg(check_conditionA, 'No condition specified !', 1, check_defaults);
    ConditionA= str2double(check_answer); % Depending on the decision..
    if ConditionA ==1
        fix1=load('Retr_Fix1_1_repl.mat');
        fix2=load('Retr_Fix2_1_repl_sorted.mat');
    elseif ConditionA ==2
    fix1=load('Retr_Fix1_2_repl.mat');
    fix2=load('Retr_Fix2_2_repl_sorted.mat');
    end
end


ISI_1= fix1.design_struct.eventlist(:, 4); %PTB uses seconds
ISI_2= fix2.design_struct.eventlist(:, 4);

trial_type_ISI = fix1.design_struct.eventlist(:, 3);
trial_type=stimuli_list{1,6};

%find where are trial stimuli and control stimuli
indexones = find([trial_type{:}] == 1)';
indexzeros = find([trial_type{:}] == 0)';
% recreate a stimuli list based in ITI.
indexones_ITI= find(trial_type_ISI==1);
indexzeros_ITI= find(trial_type_ISI==0);
clear indexones_ITI_1 indexones_ITI_2 indexzeros_ITI_1 indexzeros_ITI_2

% create llist of stimuli


% replace rows

for i = 1:40 % first block
    m = indexzeros_ITI(i); %new position of the '0' stimuli (position ITI)
    n = indexzeros(i);% old position of the '0' stimuli
    stimuli_list_ordered{1,1}(m,1)=stimuli_list {1,1}(n,1);
    stimuli_list_ordered{1,2}(m,1)=stimuli_list{1,2}(n,1);
    stimuli_list_ordered{1,3}(m,1)=stimuli_list{1,3}(n,1);
    stimuli_list_ordered{1,4}(m,1)=stimuli_list{1,4}(n,1);
    stimuli_list_ordered{1,5}(m,1)=stimuli_list{1,5}(n,1);
    stimuli_list_ordered{1,6}(m,1)=stimuli_list{1,6}(n,1);
    stimuli_list_ordered{1,7}(m,1)=stimuli_list{1,7}(n,1);
end

for ii = 1:40 %first block
    m = indexones_ITI(ii); %new position of the '1' stimuli (position ITI)
    n = indexones(ii); %old position of the '1' stimuli
    stimuli_list_ordered{1,1}(m,1)=stimuli_list {1,1}(n,1);
    stimuli_list_ordered{1,2}(m,1)=stimuli_list{1,2}(n,1);
    stimuli_list_ordered{1,3}(m,1)=stimuli_list{1,3}(n,1);
    stimuli_list_ordered{1,4}(m,1)=stimuli_list{1,4}(n,1);
    stimuli_list_ordered{1,5}(m,1)=stimuli_list{1,5}(n,1);
    stimuli_list_ordered{1,6}(m,1)=stimuli_list{1,6}(n,1);
    stimuli_list_ordered{1,7}(m,1)=stimuli_list{1,7}(n,1);
end

% ---------- Randomize stimuli position on the screen ------- %

% Monitor
[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor);
slack = Screen('GetFlipInterval', windowPtr)/2; %Calcola quanto tempo ci sta a flippare lo schermo (serve poi per il calcolo del tempo di present)
% rect=Screen('Rect', 0,0); %Comment this if you want to refer to small size monitor, let it code if you want to refer to full monitor
% Display variables
xMax=rect(1,3);
yMax=rect(1,4);
xCenter= xMax/2;
yCenter= yMax/2;
% Coordinates
topcentral=[xCenter-(picWidth/2), gap, xCenter+(picWidth/2), gap+picHeight];
pos_central= [ xCenter-(objpicWidth/2), gap+picHeight+gapHeight, xCenter+(objpicWidth/2), gap+picHeight+gapHeight+objpicHeight];
pos_left= [topcentral(1,1),  gap+picHeight+gapHeight, topcentral(1,1)+objpicWidth , gap+picHeight+gapHeight+objpicHeight];
pos_right= [topcentral(1,3)-objpicWidth,  gap+picHeight+gapHeight, topcentral(1,3) , gap+picHeight+gapHeight+objpicHeight];
% Randomize coordinates of choices on the screen
stimuli_choice_pos= cell(1,3);
where={pos_left,pos_central, pos_right};
for x=1:(numTrials)
    stimuli_choice_pos(x,:)=Shuffle(where);
end

clear x

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 7. Save randomization information
 save([path.res num2str(ID) '_' num2str(Session) '_randinfo.mat']);
 startscreen=tic;
% WAIT FOR TRIGGER (1)
run=1;
 while 1
     activeKeys = [KbName('t')];
     RestrictKeysForKbCheck(activeKeys);
     [keyIsDown,secs,keyCode] = KbCheck;
     disp(find(keyCode))
     if keyCode(KbName('t'))==1
         trigger_break=toc(startscreen)
         break
     end
 end
 t_last_onset(1)=secs;      trigger_toc(1,1)=toc(startscreen)
 trigger_time(1,1) =secs;
 
% Clear KB
clear KbCheck;
FlushEvents('keyDown')

% Part 1        
    startscript=tic; %start couting the time for completing the entire task 
    for i = 1:numTrialsPart1
        fixation1_duration=ISI_1(i);
        fixation2_duration=ISI_2(i);
            counter = 1;
trigger
breakpoint     
        % ---------- Fixation cross ---------- %
        fixation_pic=imread(load_fixation, 'png');
        fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
        Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
        t_fixation1_onset(i)=Screen('Flip',windowPtr,  t_last_onset(i)-slack);                          trigger_toc(i,2)=toc(startscreen)
        t_fixation1_offset(i)=Screen('Flip',windowPtr,t_fixation1_onset(i)+fixation1_duration-slack);   trigger_toc(i,3)=toc(startscreen)

trigger
breakpoint
        % ---------------- Cue ---------------- %
        pic_cue=imread([path.sti stimuli_list_ordered{1, 2}{i, 1}], 'png');
        pic_cue_texture=Screen('MakeTexture', windowPtr, pic_cue);
        Screen('DrawTexture', windowPtr, pic_cue_texture, [], topcentral);        
        t_cue_onset(i)= Screen('Flip', windowPtr, t_fixation1_offset(i)-slack);        trigger_toc(i,4)=toc(startscreen)
        t_cue_offset(i)=Screen('Flip', windowPtr, t_cue_onset(i)+ cue_duration-slack); trigger_toc(i,5)=toc(startscreen)       
trigger
breakpoint
        % ---------------- Question "Were there objects?" ---------------- %
        if ConditionB==1
            categorization_pic=imread(load_categorization1, 'png');
            categorization_texture=Screen('MakeTexture', windowPtr, categorization_pic);    
            Screen('DrawTexture', windowPtr, categorization_texture, [], topcentral);       
        elseif ConditionB==2
            categorization_pic=imread(load_categorization2, 'png');
            categorization_texture=Screen('MakeTexture', windowPtr, categorization_pic);   
            Screen('DrawTexture', windowPtr, categorization_texture, [], topcentral);        
        end
        t_classification_onset(i)= Screen('Flip', windowPtr, t_cue_offset(i)-slack); trigger_toc(i,6)=toc(startscreen)  
        %Record response
        clear KbCheck;  % from kb to buttonbox
        t1 = GetSecs;
        time = 0;
        while time < classification_timeout
            % Response keys (optional; for no subject response use empty list)
            activeKeys = [50 ,51];
            RestrictKeysForKbCheck(activeKeys);
            [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
            time = t2-t1 ;
            if (keyIsDown) %has a key been pressed?
                key = (find(keyCode));
            type= class(key);
                if  type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key_question(i,1)= 99;
                    response_kbNum_question(i,1)= 99;
                    response_time_question(i,1)=99;
                elseif key== 50
                    response_key_question(i,1)= 1; %if a was pressed, 1
                    response_time_question(i,1) =time;
                    response_kbNum_question(i,1)=  2;
                elseif key == 51
                    response_key_question(i,1) =2; %if l was pressed, 2
                    response_time_question(i,1) =time;
                    response_kbNum_question(i,1)=  3;
                end
            end
        end
        t_classification_offset(i)= Screen('Flip', windowPtr, t_classification_onset(i)+classification_timeout-slack); trigger_toc(i,7)=toc(startscreen)  
trigger
breakpoint      
        % ---------------- Fixation 2 ---------------- %
        fixation_pic=imread(load_fixation, 'png');
        fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
        Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
        t_fixation2_onset(i)= Screen('Flip', windowPtr, t_classification_offset(i)-slack);              trigger_toc(i,8)=toc(startscreen)  
        t_fixation2_offset(i)= Screen('Flip', windowPtr, t_fixation2_onset(i)+fixation2_duration-slack); trigger_toc(i,9)=toc(startscreen)  
trigger
breakpoint     
        % ---------------- Selection ---------------- %
        % Select which picture to read
        pic_alt1=imread([path.sti stimuli_list_ordered{1, 3}{i, 1}], 'jpg'); % object
        pic_alt2=imread([path.sti stimuli_list_ordered{1, 4}{i, 1}], 'jpg'); % internal lure
        pic_lure=imread([path.sti stimuli_list_ordered{1, 5}{i, 1}], 'jpg'); % external lure
        %Make textures of them
        pic_alt1_texture=Screen('MakeTexture', windowPtr, pic_alt1);
        pic_alt2_texture=Screen('MakeTexture', windowPtr, pic_alt2);
        pic_lure_texture=Screen('MakeTexture', windowPtr, pic_lure);
        % Put them toghtether (....if you want to present them in the same screen)
        pics=[pic_cue_texture pic_alt1_texture pic_alt2_texture pic_lure_texture]';
        % Concatenate position of the pics
        positions=[topcentral' , stimuli_choice_pos{i, 1}' , stimuli_choice_pos{i, 2}' , stimuli_choice_pos{i, 3}'];
        % Flip (draw all toghether)
        Screen('DrawTextures', windowPtr, pics, [], positions);
        t_selection_onset(i)= Screen('Flip', windowPtr,  t_fixation2_offset(i)-slack);   trigger_toc(i,10)=toc(startscreen)  
        %Record response
        clear KbCheck;  % from kb to buttonbox
        t1 = GetSecs;
        time = 0;
        while time < selection_timeout
            % Response keys (optional; for no subject response use empty list)
            activeKeys = [50 ,51 ,52];
            RestrictKeysForKbCheck(activeKeys);
            [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
            time = t2-t1 ;
        if (keyIsDown) %has a key been pressed?
            key =(find(keyCode));
            type= class(key);
                 if  type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key(i,1)= 99;
                    response_kbNum(i,1)= 99;
                    response_time(i,1)=99;
                elseif key== 50
                    response_key(i,1)= 1; %if a was pressed, 1
                    response_time(i,1) =time;
                    response_kbNum(i,1)=  2;
                elseif key == 51
                    response_key(i,1) =2; %if l was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)=  3;
                elseif key == 52
                    response_key(i,1)= 3; %if space was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 4;
                end
        end
    end
    clear KbCheck;  % from buttonbox to kb
        t_selection_offset(i)= Screen('Flip', windowPtr, t_selection_onset(i)+selection_timeout-slack); trigger_toc(i,11)=toc(startscreen)  
        time_lastbackup=toc(startscript);
        t_last_onset(i+1)=t_selection_offset(i);
        
        % Backup of answers after every keypressed
        save([path.res num2str(ID) '_' num2str(Session) '_backup.mat']);
trigger
breakpoint        
        % ------------- ???? Pause ??? -------------%
        if i == numTrialsPart1
            pause_pic=imread(load_pause, 'png');
            pause_texture=Screen('MakeTexture', windowPtr, pause_pic);
            Screen('DrawTexture', windowPtr, pause_texture, [], topcentral); 
            t_pause_onset(run)= Screen('Flip', windowPtr); trigger_toc(i,12)=toc(startscreen)  
            startpause=tic; % start counting the seconds of pause
            %Wait untile spacebar is pressed
            while 1
                % Response keys (optional; for no subject response use empty list)
                activeKeys = [50 ,51 ,52];
                RestrictKeysForKbCheck(activeKeys);
                [keyIsDown,secs,keyCode] = KbCheck;
                disp(find(keyCode))
                if keyCode(50)==1 || keyCode(51)==1 || keyCode(52)==1
                    break
                end
            end
        clear KbCheck; % from buttonbox to kb
            time_pause(run)=toc(startpause); % how many seconds of pause did the participant take?
            clear tic % so it doesn't interfere with the main tic
            t_pause_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc(i,13)=toc(startscreen)  
trigger
breakpoint               % --------- Waiting for experimenter input --------- %
                   wait_pic=imread(load_wait, 'png');
                   wait_texture=Screen('MakeTexture', windowPtr, wait_pic);
                   Screen('DrawTexture', windowPtr, wait_texture, [], topcentral);
                   t_wait_onset(run)= Screen('Flip', windowPtr); trigger_toc(i,14)=toc(startscreen)  
                   startwait=tic; % start counting the seconds of pause
                   %Wait untile spacebar is pressed
                   clear KbCheck; % from kb to buttonbox
                   while 1
                       % Response keys (optional; for no subject response use empty list)
                       activeKeys = [KbName('e')];
                       RestrictKeysForKbCheck(activeKeys);
                       [keyIsDown,secs,keyCode] = KbCheck;
                       disp(find(keyCode))
                       if keyCode(KbName('e'))==1
                           break
                       end
                   end
                    clear KbCheck; % from buttonbox to kb
                    time_wait(run)=toc(startwait); % how many seconds of pause did the participant take?
                    clear tic % so it doesn't interfere with the main tic
                    t_wait_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc(i,15)=toc(startscreen)  
                end
trigger
breakpoint
    end
time_end_first_part=toc(startscript)
sca %Close all

%% Part 2
[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor);
slack = Screen('GetFlipInterval', windowPtr)/2; %Calcola quanto tempo ci sta a flippare lo schermo (serve poi per il calcolo del tempo di present)
startscreen2=tic;
% WAIT FOR TRIGGER (2)
run=2;
while 1
    activeKeys = [KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    [keyIsDown,secs,keyCode] = KbCheck;
    disp(find(keyCode))
    if keyCode(KbName('t'))==1
        trigger_break2=toc(startscreen2)
        break
    end    
end
t_last_onset(numTrialsPart1+1)=secs; trigger_toc2(i,1)=toc(startscreen2) 
trigger_time(2,1) =secs;

% Clear KB
clear KbCheck;
FlushEvents('keyDown')

% PART 2
    startscript2=tic; %start couting the time for completing the entire task 
    for i = numTrialsPart1+1:numTrialsPart2
        fixation1_duration=ISI_1(i);
        fixation2_duration=ISI_2(i);
            counter = 1;
trigger
breakpoint      
        % ---------- Fixation cross ---------- %
        fixation_pic=imread(load_fixation, 'png');
        fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
        Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
        t_fixation1_onset(i)=Screen('Flip',windowPtr,  t_last_onset(i)-slack); trigger_toc2(i,2)=toc(startscreen2)
        t_fixation1_offset(i)=Screen('Flip',windowPtr,t_fixation1_onset(i)+fixation1_duration-slack); trigger_toc2(i,3)=toc(startscreen2)
trigger
breakpoint  
       % ---------------- Cue ---------------- %
        pic_cue=imread([path.sti stimuli_list_ordered{1, 2}{i, 1}], 'png');
        pic_cue_texture=Screen('MakeTexture', windowPtr, pic_cue);
        Screen('DrawTexture', windowPtr, pic_cue_texture, [], topcentral);
        t_cue_onset(i)= Screen('Flip', windowPtr, t_fixation1_offset(i)-slack); trigger_toc2(i,4)=toc(startscreen2)
        t_cue_offset(i)=Screen('Flip', windowPtr, t_cue_onset(i)+ cue_duration-slack); trigger_toc2(i,5)=toc(startscreen2)
trigger
breakpoint  
        % ---------------- Question "Were there objects?" ---------------- %
        if ConditionB==1
            categorization_pic=imread(load_categorization1, 'png');
            categorization_texture=Screen('MakeTexture', windowPtr, categorization_pic); 
            Screen('DrawTexture', windowPtr, categorization_texture, [], topcentral);
        elseif ConditionB==2
            categorization_pic=imread(load_categorization2, 'png');
            categorization_texture=Screen('MakeTexture', windowPtr, categorization_pic);
            Screen('DrawTexture', windowPtr, categorization_texture, [], topcentral);
        end
        t_classification_onset(i)= Screen('Flip', windowPtr, t_cue_offset(i)-slack); trigger_toc2(i,6)=toc(startscreen2)
        %Record response
    clear KbCheck;  % from kb to buttonbox
        t1 = GetSecs;
        time = 0;
        while time < classification_timeout
            % Response keys (optional; for no subject response use empty list)
            activeKeys = [50 ,51];
            RestrictKeysForKbCheck(activeKeys);
            [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
            time = t2-t1 ;
            if (keyIsDown) %has a key been pressed?
                key = (find(keyCode));
                type= class(key);
                if  type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key_question(i,1)= 99;
                    response_kbNum_question(i,1)= 99;
                    response_time_question(i,1)=99;
                elseif key== 50
                    response_key_question(i,1)= 1; %if a was pressed, 1
                    response_time_question(i,1) =time;
                    response_kbNum_question(i,1)=  2;
                elseif key == 51
                    response_key_question(i,1) =2; %if l was pressed, 2
                    response_time_question(i,1) =time;
                    response_kbNum_question(i,1)=  3;
                end
            end
        end
        clear KbCheck;  % from buttonbox to kb
        t_classification_offset(i)= Screen('Flip', windowPtr, t_classification_onset(i)+classification_timeout-slack); trigger_toc2(i,7)=toc(startscreen2)
trigger
breakpoint       
        % ---------------- Fixation 2 ---------------- %
        fixation_pic=imread(load_fixation, 'png');
        fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
        Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
        t_fixation2_onset(i)= Screen('Flip', windowPtr, t_classification_offset(i)-slack); trigger_toc2(i,8)=toc(startscreen2)
        t_fixation2_offset(i)= Screen('Flip', windowPtr, t_fixation2_onset(i)+fixation2_duration-slack); trigger_toc2(i,9)=toc(startscreen2)
trigger
breakpoint     
        % ---------------- Selection ---------------- %
        % Select which picture to read
        pic_alt1=imread([path.sti stimuli_list_ordered{1, 3}{i, 1}], 'jpg'); % object
        pic_alt2=imread([path.sti stimuli_list_ordered{1, 4}{i, 1}], 'jpg'); % internal lure
        pic_lure=imread([path.sti stimuli_list_ordered{1, 5}{i, 1}], 'jpg'); % external lure
        %Make textures of them
        pic_alt1_texture=Screen('MakeTexture', windowPtr, pic_alt1);
        pic_alt2_texture=Screen('MakeTexture', windowPtr, pic_alt2);
        pic_lure_texture=Screen('MakeTexture', windowPtr, pic_lure);
        % Put them toghtether (....if you want to present them in the same screen)
        pics=[pic_cue_texture pic_alt1_texture pic_alt2_texture pic_lure_texture]';
        % Concatenate position of the pics
        positions=[topcentral' , stimuli_choice_pos{i, 1}' , stimuli_choice_pos{i, 2}' , stimuli_choice_pos{i, 3}'];
        % Flip (draw all toghether)
        Screen('DrawTextures', windowPtr, pics, [], positions);
        t_selection_onset(i)= Screen('Flip', windowPtr,  t_fixation2_offset(i)-slack); trigger_toc2(i,10)=toc(startscreen2)
        %Record response
        clear KbCheck;  % from kb to buttonbox
        t1 = GetSecs;
        time = 0;
        while time < selection_timeout
            % Response keys (optional; for no subject response use empty list)
            activeKeys = [50 ,51 ,52];
            RestrictKeysForKbCheck(activeKeys);
            [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
            time = t2-t1 ;
            if (keyIsDown) %has a key been pressed?
            key =(find(keyCode));
            type= class(key);
                 if  type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key(i,1)= 99;
                    response_kbNum(i,1)= 99;
                    response_time(i,1)=99;
                elseif key== 50
                    response_key(i,1)= 1; %if a was pressed, 1
                    response_time(i,1) =time;
                    response_kbNum(i,1)=  2;
                elseif key == 51
                    response_key(i,1) =2; %if l was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)=  3;
                elseif key == 52
                    response_key(i,1)= 3; %if space was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 4;
                end
        end
    end
    clear KbCheck;  % from buttonbox to kb
      t_selection_offset(i)= Screen('Flip', windowPtr, t_selection_onset(i)+selection_timeout-slack); trigger_toc2(i,11)=toc(startscreen2)
        time_lastbackup=toc(startscript);
        t_last_onset(i+1)=t_selection_offset(i);         
        % Backup of answers after every keypressed
        save([path.res num2str(ID) '_' num2str(Session) '_backup.mat']);
trigger
breakpoint       
        % ------------- ???? Pause ??? -------------%
        if i == numTrialsPart1
            pause_pic=imread(load_pause, 'png');
            pause_texture=Screen('MakeTexture', windowPtr, pause_pic);
            Screen('DrawTexture', windowPtr, pause_texture, [], topcentral);
            t_pause_onset(i)= Screen('Flip', windowPtr); trigger_toc2(i,12)=toc(startscreen2)
            startpause=tic; % start counting the seconds of pause
            %Wait untile spacebar is pressed
            clear KbCheck;  % from kb to buttonbox
            while 1
                % Response keys (optional; for no subject response use empty list)
                activeKeys = [50 ,51 ,52];
                RestrictKeysForKbCheck(activeKeys);
                [keyIsDown,secs,keyCode] = KbCheck;
                disp(find(keyCode))
                if keyCode(50)==1 || keyCode(51)==1 || keyCode(52)==1
                    break
                end
            end
            clear KbCheck; % from buttonbox to kb
            time_pause(i)=toc(startpause); % how many seconds of pause did the participant take?
            clear tic % so it doesn't interfere with the main tic
            t_pause_offset(i)=t_pause_onset(i)+secs-slack; trigger_toc2(i,13)=toc(startscreen2)
        end
trigger
breakpoint    
    end


% Time 
time_end=toc(startscript); %calculate time for completing entire task
time_end_second_part=toc(startscript2)

%  -------- End screen -------- %
end_pic=imread(load_endscreen, 'png');
end_texture=Screen('MakeTexture', windowPtr, end_pic);
Screen('DrawTexture', windowPtr, end_texture, [], topcentral);   
t_end_onset=Screen('Flip', windowPtr);     %Show the results on the screen
startwait=tic; % start counting the seconds of pause

 %Wait untile spacebar is press
 clear KbCheck; % from kb to buttonbox
 while 1
     % Response keys (optional; for no subject response use empty list)
     activeKeys = [KbName('e')];
     RestrictKeysForKbCheck(activeKeys);
     [keyIsDown,secs,keyCode] = KbCheck;
     disp(find(keyCode))
     if keyCode(KbName('e'))==1
         break
     end
 end
 clear KbCheck; % from buttonbox to kb
 time_wait(run)=toc(startwait); % how many seconds of pause did the participant take?
 clear tic 
t_end_offset=t_end_onset(end)+secs-slack; %variable that in the loop becames the fixation timestamp
 trigger
 breakpoint
 
 sca %Close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 8. Re enable keyboard
    RestrictKeysForKbCheck;
    ListenChar(0);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 9. Save before analysis
    
     save([path.res num2str(ID) '_' num2str(Session) '_raw.mat']);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 10. Analyze answers
    
    % Find pictures real position
    % cue, alternative, external lure
    % 1=left, 2=center, 3= right
    stimuli_choice_pos_coded=[1,1];
    for c=1:3
        for r = 1:numTrials
            position=stimuli_choice_pos{r,c};
            if position(1) == pos_left(1,1)
                stimuli_choice_pos_coded(r,c)= 1;
            elseif position(1) == pos_central(1,1)
                stimuli_choice_pos_coded(r,c)= 2;
            elseif position(1) == pos_right(1,1)
                stimuli_choice_pos_coded(r,c)= 3;
            end
        end
    end
    
    % Find correct answers and errors for choices
    answers=strings(numTrials,1);
    for r=1:length(response_key)
        if ismember(response_key(r),stimuli_choice_pos_coded(r,1)) == 1 %cue column
            answers(r,1)= "T"; %Correct answers
        elseif ismember(response_key(r),stimuli_choice_pos_coded(r,2)) == 1 %internal lure colums
            answers(r,1)= "IL"; %Internal lure
        elseif ismember(response_key(r),stimuli_choice_pos_coded(r,3)) == 1 %external lure column
            answers(r,1)= "EL"; %External lure
        elseif response_key(r) == 0
            answers(r,1)= "no response"; %no response was made
        elseif response_key(r) == 99
            answers(r,1)= "multiple response"; % multiple response were made
        end
    end
    
    % Find correct answer to room classification
    answers_classification=strings(numTrials,1);
    for r=1:length(response_key)
        
        if ConditionB ==1
            ja = 1;
            nein = 2;
        elseif ConditionB ==2
            ja= 2;
            nein=1;
        end
        % response_key_question 1 = Ja, 2 = Nein
        % stimuli_list{1, 6}(r, 1), 1 = Task, 0= Control
        
        if response_key_question(r) == ja && stimuli_list_ordered{1, 6}{r, 1} == 1
            answers_classification(r,1)= "tT"; %Correct answer for task trial
        elseif response_key_question(r) == nein && stimuli_list_ordered{1, 6}{r, 1} == 1
            answers_classification(r,1)= "tF"; %Wrong answer for task trial
        elseif response_key_question(r) == nein && stimuli_list_ordered{1, 6}{r, 1} == 0
            answers_classification(r,1)= "cT"; %Correct answer for task trial
        elseif response_key_question(r) == ja && stimuli_list_ordered{1, 6}{r, 1} == 0
            answers_classification(r,1)= "cF"; %Wrong answer for control trial
            
        elseif response_key_question(r) == 99 && stimuli_list_ordered{1, 6}{r, 1} == 1
            answers_classification(r,1)= "multiple response T"; %Wrong answer for control trial
        elseif response_key_question(r) == 99 && stimuli_list_ordered{1, 6}{r, 1} == 0
            answers_classification(r,1)= "multiple response C"; %Wrong answer for control trial
            
        elseif response_key_question(r) == 0 && stimuli_list_ordered{1, 6}{r, 1} == 1
            answers_classification(r,1)= "no response T"; %Wrong answer for control trial
        elseif response_key_question(r) == 0 && stimuli_list_ordered{1, 6}{r, 1} == 0
            answers_classification(r,1)= "no response C"; %Wrong answer for control trial
        end
        
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 11. Resume
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Total results
    resultsClass.hintsTrial=sum(answers_classification=="tT");
    resultsClass.hintsControl=sum(answers_classification=="cT");
    
    resultsClass.errorsTrial=sum(answers_classification=="tF");
    resultsClass.errorsControl=sum(answers_classification=="cF");
    
    resultsClass.missedTrial=sum(answers_classification=="no response T");
    resultsClass.missedControl=sum(answers_classification=="no response C");
    
    resultsClass.multipleTrial=sum(answers_classification=="multiple response T");
    resultsClass.multipleControl=sum(answers_classification=="multiple response C");
    
    resultsClass.totalresponseTrial=sum(resultsClass.hintsTrial+resultsClass.errorsTrial); %T+IL+E
    resultsClass.totalresponseControl=sum(resultsClass.hintsControl+resultsClass.errorsControl); %T+IL+E
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Selection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Total results
    results.hints=sum(answers=="T");
    results.falseallarm=sum(answers=="IL");
    results.errors=sum(answers=="EL");
    results.missed=sum(answers=="no response");
    results.multiple=sum(answers=="multiple response");
    results.totalresponse=sum(results.hints+results.falseallarm+results.errors); %T+IL+E
    
    % Trial related results (task trial (1) /control trial (0))
    for i = 1:numTrials
        
        if stimuli_list_ordered{1, 6}{i, 1} == 1
            taskanswers(i,1)= answers(i,1)   ;
             controlanswers(i,1) = "control trial"   ; %if it is not 
        else
            controlanswers(i,1) = answers(i,1)   ;
             taskanswers(i,1)= "task trial"    ;           
        end
    end
    
    % Total results
    results.hints_1=sum(taskanswers=="T");
    results.falseallarm_1=sum(taskanswers=="IL");
    results.errors_1=sum(taskanswers=="EL");
    results.missed_1=sum(taskanswers=="no response");
    results.multiple_1=sum(taskanswers=="multiple response");
    results.totalresponse_1=sum(results.hints_1+results.falseallarm_1+results.errors_1);
    
    results.hints_0=sum(controlanswers=="T");
    results.falseallarm_0=sum(controlanswers=="IL");
    results.errors_0=sum(controlanswers=="EL");
    results.missed_0=sum(controlanswers=="no response");
    results.multiple_0=sum(controlanswers=="multiple response");
    results.totalresponse_0=sum(results.hints_0+results.falseallarm_0+results.errors_0);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 12. Save
    inputfile_creation.encoding_stimuli_list =stimuli_list_encoding;
    inputfile_creation.rows_randomization_encoding1 =rows_rand1_encoding;
    inputfile_creation.rows_randomization_encoding2 =rows_rand2_encoding;
    inputfile_creation.positions_stimuli_to_use= list; 
    
    stimuli.stimuli_randomized= stimuli_list;
    stimuli.row_randomization=rows_rand;  
    stimuli.stimuli_ordered_per_ISI_trialtype= stimuli_list_ordered;  
    stimuli.ISI_trial_type= trial_type_ISI;
    stimuli.choice_position = stimuli_choice_pos;
    stimuli.choice_position_coded = stimuli_choice_pos_coded;

    answer.response_kbNum=response_kbNum;
    answer.response_kbNum_question=response_kbNum_question;    
    answer.response_key  =response_key;
    answer.response_key_question  =response_key_question;
    answer.response_time =response_time;
    answer.response_time_question =response_time_question;
    answer.all_selection_answers   = answers; 
    answer.task_answers = taskanswers;
    answer.control_answers = controlanswers;
    answer.all_classification_answer= answers_classification;

 
    timing.end=(time_end/60); %from seconds to minutes (are now in msec because calculated by Matlab)
    timing.pause=time_pause/60;
    timing.last_backup=time_lastbackup/60;
    timing.ISI1=ISI_1; % Already in seconds        
    timing.ISI1=ISI_2; % Already in seconds        
    timing.fixation1_onset=t_fixation1_onset; % Already in seconds because calculated by PTB
    timing.fixation1_offset=t_fixation1_offset;
    timing.fixation2_onset=t_fixation2_onset; % Already in seconds because calculated by PTB
    timing.fixation2_offset=t_fixation2_offset;
    timing.cue_onset=t_cue_onset;
    timing.cue_offset=t_cue_offset;
    timing.classification_onset=t_classification_onset;
    timing.classification_offset=t_classification_offset;
    timing.selection_onset=t_selection_onset;
    timing.selection_offset=t_selection_offset;
    timing.wait_onset=t_wait_onset;
    timing.wait_offset=t_wait_offset;
    timing.end_onset=t_end_onset;
    timing.end_offset=t_end_offset;
    timing.slack=slack;
    timing.triggers=time_trigger_mr;
    timing.triggers_startingpoints=trigger_time;
    
    participant_info.ID=ID;
    participant_info.group_ISI=ConditionA;
    participant_info.group_Ja_Nein=ConditionB;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 13. Save results
     save([path.res num2str(ID) '_' num2str(Session) '.mat']...
        , 'participant_info' ...
        , 'stimuli' ...
        , 'results' ... 
        , 'resultsClass'...
        , 'answer' ...
        , 'timing' );
