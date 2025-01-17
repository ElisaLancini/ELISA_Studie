%%%%%%%%%%%%%%%%%%%%% (B) fMRI Encoding Session %%%%%%%%%%%%%%%%%%%%%%%%ee
Screen('Preference','SuppressAllWarnings', 1)
%% LOG
% 30.09.2021 : 
%- messa la possibilita di mantenere la schermata finale fino a che non premo la e. 
% - All inizio di ogni sezione c e la variabile run , che viene usata per trigger_time
% - Ho aggiunt negli input files il waiting pic

% 08.10.2021 :
% - Ho aggiunto timing.wait_onset and offest alla lista di variabili da
% memorizzare

% 14.10.2021 : Re-check: positivo
% 22.02.2022 : In the dialog box 
 %- "Participant number" is replaced with "Randonummer"
 % - "Append an R" is replaced with "Add "2" to the Randonummer"
 % And code changed, not an R but a 2 in case of repetition
 
%%
% Inizialising + part 1
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
addpath(genpath(path.task));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2. Subject infos

% Subject informations
input_prompt = {'Randonummer'; 'Condition A';'Session (1=A, 2=B, 3=C, 4=D, 5=E, 6=F)'};
input_defaults     = {'01','1','99'}; % Mostra input default per non guidare l'inserimento
input_answer = inputdlg(input_prompt, 'Informations', 1, input_defaults);
clear input_defaults input_prompt
%Modifiy class of variables
ID          = str2num(input_answer{1,1});
ConditionA  = str2num(input_answer{2,1});
Session     = str2num(input_answer{3,1});

% Check if is the experimenter is using the right script
if Session ~= 2
    errordlg('You are running the wrong script','Session error');
    return
end

% Check if Conditions are >1 and <2 , otherwise error will occur

if ConditionA > 2 || ConditionA == 0
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

clear input_answer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3. Load settings
cd(path.input)
B_Settings_encoding;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 4. Pre allocate variables

stimuli_list_ordered= cell(1,7); %Stimuli sorted by ITI order
response_key=zeros(numTrials*2,1); %Key pressed
response_time=zeros(numTrials*2,1); %Time of key press
response_kbNum=zeros(numTrials*2,1); %Number of key pressed
idx=[]; %Index of cue of the first block (cue 1 or cue 2?)
time_pause=zeros(1,140);
time_end=999;
events=cell(1,2);


global time_escape_mr;
time_escape_mr = 0;

global time_trigger_mr;
time_trigger_mr=zeros(numTrials*2,5);

global counter;

global i;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 5. Load stimuli list (inputfile)

% https://de.mathworks.com/help/matlab/ref/fscanf.html
fid=fopen('inputfile_main task.txt','r'); %number of fields
inputfile=textscan(fid,'%s%s%s%s%s%s%s%f', 'HeaderLines', 1);         % how to read those fields
% (%s) Returns text array containing the data up to the next delimiter, or end-of-line character.
% (%f) converts that to a number
fclose(fid);
clear fid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 6. Randomization

% ---------- Randomize cue 1 or 2 presentation in block 1 or 2 ! -------- %

% --- counterbalancing --- %
if mod(ID,2)== 0  
   first_block_external_lure= inputfile{1, 6};
   second_block_external_lure= inputfile{1, 7};
else
   first_block_external_lure= inputfile{1, 7};
   second_block_external_lure= inputfile{1, 6};  
end

%Create the variable stimuli_list
stimuli_list= cell(1,6);
% Randomize cue, alternative and lure pic for every row (1:140)
% randomize trial type (1 or 2 ? )
idx= randi(2,numTrials,1);
% randomize rows number
rows1=(1:numTrials); %From1 to 80
rows_rand1=rows1(randperm(length(rows1)))'; % Randomize the order
rows2=(numTrials+1:numTrials*2); % From 71 to 160
rows_rand2=rows2(randperm(length(rows2)))'; %Randomize the order
rows_rand=[rows_rand1;rows_rand2];
clear rows1 rows2
% Extract type of stimulus for each stimuli
type=inputfile{1, 8};
% Re-order every row depending on the new row list
for n=1:numTrials %
    x= rows_rand1(n);
    % Re-order first column (Rooms)
    stimuli_list{1, 1}{x, 1} = inputfile{1, 1}{n, 1};
    % Re-order sixth column (Type of stimulus)
    stimuli_list{1, 6}{x, 1} = type(n);
    %Randomize other columns (Objects, type of trial)
    if idx(x)==1
        stimuli_list{1, 2}{x, 1} = inputfile{1, 2}{n, 1};  %cue 1
        stimuli_list{1, 3}{x, 1} = inputfile{1, 4}{n, 1};  %dependeing on cue, this is the right object
        stimuli_list{1, 4}{x, 1} = inputfile{1, 5}{n, 1};  %internal lure (alternative 2)
        stimuli_list{1, 5}{x, 1} = first_block_external_lure{n, 1};  %external lure 1
    else
        stimuli_list{1, 2}{x, 1} = inputfile{1, 3}{n, 1}; %cue 2
        stimuli_list{1, 3}{x, 1} = inputfile{1, 5}{n, 1}; %object 2
        stimuli_list{1, 4}{x, 1} = inputfile{1, 4}{n, 1}; %internal lure (alternative 1)
        stimuli_list{1, 5}{x, 1} = first_block_external_lure{n, 1}; %external lure 2
    end
    %Create second block of stimuli(alternatives of the first block)
    y= rows_rand2(n);
    %Randomize first column (Rooms)
    stimuli_list{1, 1}{y, 1} = inputfile{1, 1}{n, 1};
    % Re-order sixth column (Type of stimulus)
    stimuli_list{1, 6}{y, 1} =  stimuli_list{1, 6}{x, 1} ;
    %Randomize other columns (Objects, type of trial)
    if  idx(x,1)==1 %If before it was 1... now is 2
        stimuli_list{1, 2}{y, 1} = inputfile{1, 3}{n, 1}; %cue 2
        stimuli_list{1, 3}{y, 1} = inputfile{1, 5}{n, 1}; %object 2
        stimuli_list{1, 4}{y, 1} = inputfile{1, 4}{n, 1}; %internal lure (alternative 1)
        stimuli_list{1, 5}{y, 1} = second_block_external_lure{n, 1}; %external lure 2
        idx(y,1)=2; % ...save as 2
    else %if before was 2...now is 1
        stimuli_list{1, 2}{y, 1} = inputfile{1, 2}{n, 1};  %cue 1
        stimuli_list{1, 3}{y, 1} = inputfile{1, 4}{n, 1};  %dependeing on cue, this is the right object
        stimuli_list{1, 4}{y, 1} = inputfile{1, 5}{n, 1};  %internal lure (alternative 2)
        stimuli_list{1, 5}{y, 1} = second_block_external_lure{n, 1};  %external lure 1
        idx(y,1)=1; %...save as 1
    end
end
% Add concatenated indexes in the 7th column (cue 1 or 2?)
stimuli_list{:, 7}=num2cell(idx);
clear type x y n


% ----------  Create matrix of stimuli depending on ISI trialtype -------- %

% Load ITI
cd(path.config);

if ConditionA ==1
    fix1=load('Enc_Fix1_1_merged.mat');
    fix2=load('Enc_Fix2_1_merged_sorted.mat');
elseif ConditionA ==2
    fix1=load('Enc_Fix1_2_merged.mat');
    fix2=load('Enc_Fix2_2_merged_sorted.mat');
elseif exist(ConditionA,'var')== 0
    check_conditionA = {'Please specify condition A'};
    check_defaults     = {'1'}; % default input
    check_answer = inputdlg(check_conditionA, 'No condition specified !', 1, check_defaults);
    ConditionA= str2double(check_answer); % Depending on the decision..
    if ConditionA ==1
    fix1=load('Enc_Fix1_1_merged.mat');
    fix2=load('Enc_Fix2_1_merged_sorted.mat');
    elseif ConditionA ==2
    fix1=load('Enc_Fix1_2_merged.mat');
    fix2=load('Enc_Fix2_2_merged_sorted.mat');
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
    originalrow=find(rows_rand==n);
    rows_ordered(originalrow,1)=m;
end

for i = 41:80 %second block
    m = indexzeros_ITI(i); %new position of the '0' stimuli (position ITI)
    n = indexzeros(i);% old position of the '0' stimuli
    stimuli_list_ordered{1,1}(m,1)=stimuli_list {1,1}(n,1);
    stimuli_list_ordered{1,2}(m,1)=stimuli_list{1,2}(n,1);
    stimuli_list_ordered{1,3}(m,1)=stimuli_list{1,3}(n,1);
    stimuli_list_ordered{1,4}(m,1)=stimuli_list{1,4}(n,1);
    stimuli_list_ordered{1,5}(m,1)=stimuli_list{1,5}(n,1);
    stimuli_list_ordered{1,6}(m,1)=stimuli_list{1,6}(n,1);
    stimuli_list_ordered{1,7}(m,1)=stimuli_list{1,7}(n,1);
    originalrow=find(rows_rand==n);
    rows_ordered(originalrow,1)=m;

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
    originalrow=find(rows_rand==n);
    rows_ordered(originalrow,1)=m;
   
end


for ii = 41:80 %second block
    m = indexones_ITI(ii); %new position of the '1' stimuli (position ITI)
    n = indexones(ii); %old position of the '1' stimuli
    stimuli_list_ordered{1,1}(m,1)=stimuli_list {1,1}(n,1);
    stimuli_list_ordered{1,2}(m,1)=stimuli_list{1,2}(n,1);
    stimuli_list_ordered{1,3}(m,1)=stimuli_list{1,3}(n,1);
    stimuli_list_ordered{1,4}(m,1)=stimuli_list{1,4}(n,1);
    stimuli_list_ordered{1,5}(m,1)=stimuli_list{1,5}(n,1);
    stimuli_list_ordered{1,6}(m,1)=stimuli_list{1,6}(n,1);
    stimuli_list_ordered{1,7}(m,1)=stimuli_list{1,7}(n,1);
    originalrow=find(rows_rand==n);
    rows_ordered(originalrow,1)=m;
end

% --------------  Randomize stimuli position on the screen -------------- %

% Monitor
%[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor,[0 0 800 600]);
[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor);
slack = Screen('GetFlipInterval', windowPtr)/2; %Calcola quanto tempo ci sta a flippare lo schermo (serve poi per il calcolo del tempo di present)
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
for x=1:(numTrials*2)
    stimuli_choice_pos(x,:)=Shuffle(where);
end

% 7. Save randomization information
save([path.res num2str(ID) '_' num2str(Session) '_randinfo.mat']);
startscreen=tic;
% Part 1 wait for trigger 
run=1;
while 1
    activeKeys = [KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    [keyIsDown,secs,keyCode] = KbCheck;
    disp(find(keyCode))
    if keyCode(KbName('t'))==1
        trigger_break=toc(startscreen);
        break
    end
end
t_last_onset(1)=secs; trigger_toc(1,1)=toc(startscreen);
trigger_time(run,1) =secs;

% Clear KB
clear KbCheck;
FlushEvents('keyDown')

%  START  
startscript=tic; %start couting the time for completing the entire task

% Part 1 (1:40)
for i = 1:numTrialsPart1
    fixation1_duration=ISI_1(i);
    fixation2_duration=ISI_2(i);
            counter = 1;
trigger
breakpoint
    % ---------- Fixation 1 1---------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation1_onset(i)=Screen('Flip',windowPtr, t_last_onset(i)-slack); trigger_toc(i,2)=toc(startscreen);
    t_fixation1_offset(i)=Screen('Flip',windowPtr,t_fixation1_onset(i)+fixation1_duration-slack); trigger_toc(i,3)=toc(startscreen);
trigger
breakpoint
    % ---------------- Room ---------------- %
    pic_room=imread([path.sti stimuli_list_ordered{1, 1}{i, 1}], 'jpg');
    pic_room_texture=Screen('MakeTexture', windowPtr, pic_room);
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_room_onset(i)= Screen('Flip', windowPtr, t_fixation1_offset(i)-slack); trigger_toc(i,4)=toc(startscreen);
    t_room_offset(i)= Screen('Flip', windowPtr, t_room_onset(i)+room_duration-slack); trigger_toc(i,5)=toc(startscreen);
trigger
breakpoint
    % ---------------- Empty screen ---------------- %
    pic_checker=imread(load_checker, 'bmp');
    pic_checker_texture=Screen('MakeTexture', windowPtr, pic_checker);
    Screen('DrawTexture', windowPtr, pic_checker_texture, [], topcentral);
    t_empty_onset(i)= Screen('Flip', windowPtr, t_room_offset(i)-slack); trigger_toc(i,6)=toc(startscreen);
    t_empty_offset(i)= Screen('Flip', windowPtr, t_empty_onset(i)+emptyscreen_duration-slack); trigger_toc(i,7)=toc(startscreen);
trigger
breakpoint
    % ---------------- Fixation 2 ---------------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation2_onset(i)= Screen('Flip', windowPtr, t_empty_offset(i)-slack); trigger_toc(i,8)=toc(startscreen);
    t_fixation2_offset(i)= Screen('Flip', windowPtr, t_fixation2_onset(i)+fixation2_duration-slack); trigger_toc(i,9)=toc(startscreen);
trigger
breakpoint  
    % ---------------- Selection ---------------- %
    % Select which picture to read
    pic_cue=imread([path.sti stimuli_list_ordered{1, 2}{i, 1}], 'png');  %load cue
    pic_alt1=imread([path.sti stimuli_list_ordered{1, 3}{i, 1}], 'jpg'); % object
    pic_alt2=imread([path.sti stimuli_list_ordered{1, 4}{i, 1}], 'jpg'); % internal lure
    pic_lure=imread([path.sti stimuli_list_ordered{1, 5}{i, 1}], 'jpg'); % external lure
    %Make textures of them
    pic_cue_texture=Screen('MakeTexture', windowPtr, pic_cue);
    pic_alt1_texture=Screen('MakeTexture', windowPtr, pic_alt1);
    pic_alt2_texture=Screen('MakeTexture', windowPtr, pic_alt2);
    pic_lure_texture=Screen('MakeTexture', windowPtr, pic_lure);
    % Put them toghtether (....if you want to present them in the same screen)
    pics=[pic_cue_texture pic_alt1_texture pic_alt2_texture pic_lure_texture]';
    % Concatenate position of the pics
    positions=[topcentral' , stimuli_choice_pos{i, 1}' , stimuli_choice_pos{i, 2}' , stimuli_choice_pos{i, 3}'];
    % Flip (draw all toghether)
    Screen('DrawTextures', windowPtr, pics, [], positions);
    t_selection_onset(i)= Screen('Flip', windowPtr,  t_fixation2_offset(i)-slack); trigger_toc(i,10)=toc(startscreen);
    %Record response
clear KbCheck;  % from kb to buttonbox
%FlushEvents('keyDown')
    t1 = GetSecs;
    time = 0;
    while time < selection_timeout
        % Response keys (optional; for no subject response use empty list)
        activeKeys = [50 ,51 ,52];
        RestrictKeysForKbCheck(activeKeys);
        [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
        time = t2-t1 ;
        disp(find(keyCode))
        if (keyIsDown) %has a key been pressed?
                key = (find(keyCode));
                type= class(key);
                if type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key(i,1)= 99;
                    response_kbNum(i,1)= 99;
                    response_time(i,1)= 99;
                elseif key== 50
                    response_key(i,1)= 1; %if a was pressed, 1
                    response_time(i,1) =time;
                    keypressed = find(keyCode);
                    response_kbNum(i,1)= 2;
                elseif key == 51
                    response_key(i,1)= 2; %if space was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 3;
                elseif key == 52
                    response_key(i,1) =3; %if l was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 4;
                end
            end
        end
    clear KbCheck;  % from buttonbox to kb
    t_selection_offset(i)= Screen('Flip', windowPtr, t_selection_onset(i)+selection_timeout-slack); trigger_toc(i,11)=toc(startscreen);
    time_lastbackup(i)=toc(startscript);
    % Backup of answers after every keypressed
    save([path.res num2str(ID) '_' num2str(Session) '_backup.mat']);
trigger
breakpoint
    % ---------------- Feedback ------ %
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_feedback_onset(i)= Screen('Flip', windowPtr, t_selection_offset(i)-slack); trigger_toc(i,12)=toc(startscreen);
    t_feedback_offset(i)= Screen('Flip', windowPtr, t_feedback_onset(i)+feedback_duration-slack); trigger_toc(i,13)=toc(startscreen);
    t_last_onset(i+1)=t_feedback_offset(i);
trigger
breakpoint
    % --------- Pause screen --------- %
                if i == numTrialsPart1
                     pause_pic=imread(load_pause1, 'png');
                    pause_texture=Screen('MakeTexture', windowPtr, pause_pic);
                    Screen('DrawTexture', windowPtr, pause_texture, [], topcentral);
                    t_pause_onset(run)= Screen('Flip', windowPtr); trigger_toc(i,14)=toc(startscreen);
                    startpause=tic; % start counting the seconds of pause
                    %Wait untile spacebar is pressed
                    clear KbCheck; % from kb to buttonbox
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
                    t_pause_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc(i,15)=toc(startscreen);
trigger
breakpoint               % --------- Waiting for experimenter input --------- %
                   wait_pic=imread(load_wait, 'png');
                   wait_texture=Screen('MakeTexture', windowPtr, wait_pic);
                   Screen('DrawTexture', windowPtr, wait_texture, [], topcentral);
                   t_wait_onset(run)= Screen('Flip', windowPtr); trigger_toc(i,16)=toc(startscreen);
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
                    t_wait_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc(i,17)=toc(startscreen);
                end
trigger
breakpoint
end
time_end_first_part=toc(startscript);
sca %Close all

%% Part 2
run=2;
[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor);
slack = Screen('GetFlipInterval', windowPtr)/2; %Calcola quanto tempo ci sta a flippare lo schermo (serve poi per il calcolo del tempo di present)
time_start_second_part=toc(startscript);
startscreen2=tic;
% WAIT FOR TRIGGER (2)
while 1
        activeKeys = [KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    [keyIsDown,secs,keyCode] = KbCheck;
    disp(find(keyCode));
    if keyCode(KbName('t'))==1
                trigger_break2=toc(startscreen2);
        break
    end
end
t_last_onset(numTrialsPart1+1)=secs; trigger_toc2(numTrialsPart1+1,1)=toc(startscreen2); 
trigger_time(run,1) =secs;

% Clear KB
clear KbCheck;
FlushEvents('keyDown')

% Part 2
    startscript2=tic; %start couting the time for completing the entire task 
for i = numTrialsPart1+1:numTrialsPart2
    fixation1_duration=ISI_1(i);
    fixation2_duration=ISI_2(i);
            counter = 1;
trigger
breakpoint
    % ---------- Fixation 1 1---------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation1_onset(i)=Screen('Flip',windowPtr, t_last_onset(i)-slack); trigger_toc2(i,2)=toc(startscreen2); 
    t_fixation1_offset(i)=Screen('Flip',windowPtr,t_fixation1_onset(i)+fixation1_duration-slack); trigger_toc2(i,3)=toc(startscreen2); 
trigger
breakpoint
    % ---------------- Room ---------------- %
    pic_room=imread([path.sti stimuli_list_ordered{1, 1}{i, 1}], 'jpg');
    pic_room_texture=Screen('MakeTexture', windowPtr, pic_room);
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_room_onset(i)= Screen('Flip', windowPtr, t_fixation1_offset(i)-slack); trigger_toc2(i,4)=toc(startscreen2); 
    t_room_offset(i)= Screen('Flip', windowPtr, t_room_onset(i)+room_duration-slack); trigger_toc2(i,5)=toc(startscreen2); 
trigger
breakpoint
    % ---------------- Empty screen ---------------- %
    pic_checker=imread(load_checker, 'bmp');
    pic_checker_texture=Screen('MakeTexture', windowPtr, pic_checker);
    Screen('DrawTexture', windowPtr, pic_checker_texture, [], topcentral);
    t_empty_onset(i)= Screen('Flip', windowPtr, t_room_offset(i)-slack); trigger_toc2(i,6)=toc(startscreen2); 
    t_empty_offset(i)= Screen('Flip', windowPtr, t_empty_onset(i)+emptyscreen_duration-slack); trigger_toc2(i,7)=toc(startscreen2); 
trigger
breakpoint
    % ---------------- Fixation 2 ---------------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation2_onset(i)= Screen('Flip', windowPtr, t_empty_offset(i)-slack); trigger_toc2(i,8)=toc(startscreen2); 
    t_fixation2_offset(i)= Screen('Flip', windowPtr, t_fixation2_onset(i)+fixation2_duration-slack); trigger_toc2(i,9)=toc(startscreen2); 
trigger
breakpoint
    % ---------------- Selection ---------------- %
    % Select which picture to read
    pic_cue=imread([path.sti stimuli_list_ordered{1, 2}{i, 1}], 'png');  %load cue
    pic_alt1=imread([path.sti stimuli_list_ordered{1, 3}{i, 1}], 'jpg'); % object
    pic_alt2=imread([path.sti stimuli_list_ordered{1, 4}{i, 1}], 'jpg'); % internal lure
    pic_lure=imread([path.sti stimuli_list_ordered{1, 5}{i, 1}], 'jpg'); % external lure
    %Make textures of them
    pic_cue_texture=Screen('MakeTexture', windowPtr, pic_cue);
    pic_alt1_texture=Screen('MakeTexture', windowPtr, pic_alt1);
    pic_alt2_texture=Screen('MakeTexture', windowPtr, pic_alt2);
    pic_lure_texture=Screen('MakeTexture', windowPtr, pic_lure);
    % Put them toghtether (....if you want to present them in the same screen)
    pics=[pic_cue_texture pic_alt1_texture pic_alt2_texture pic_lure_texture]';
    % Concatenate position of the pics
    positions=[topcentral' , stimuli_choice_pos{i, 1}' , stimuli_choice_pos{i, 2}' , stimuli_choice_pos{i, 3}'];
    % Flip (draw all toghether)
    Screen('DrawTextures', windowPtr, pics, [], positions);
    t_selection_onset(i)= Screen('Flip', windowPtr,  t_fixation2_offset(i)-slack); trigger_toc2(i,10)=toc(startscreen2); 
    %Record response
clear KbCheck;  % from kb to buttonbox
%FlushEvents('keyDown')
    t1 = GetSecs;
    time = 0;
    while time < selection_timeout
        % Response keys (optional; for no subject response use empty list)
        activeKeys = [50 ,51 ,52];
        RestrictKeysForKbCheck(activeKeys);
        [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
        time = t2-t1 ;
        disp(find(keyCode))
        if (keyIsDown) %has a key been pressed?
            key = (find(keyCode));
            type= class(key);
                if type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key(i,1)= 99;
                    response_kbNum(i,1)= 99;
                    response_time(i,1)= 99;
                elseif key== 50
                    response_key(i,1)= 1; %if a was pressed, 1
                    response_time(i,1) =time;
                    keypressed = find(keyCode);
                    response_kbNum(i,1)= 2;
                elseif key == 51
                    response_key(i,1)= 2; %if space was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 3;
                elseif key == 52
                    response_key(i,1) =3; %if l was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 4;
                end
            end
        end
    clear KbCheck;  % from buttonbox to kb
    t_selection_offset(i)= Screen('Flip', windowPtr, t_selection_onset(i)+selection_timeout-slack); trigger_toc2(i,11)=toc(startscreen2); 
    time_lastbackup(i)=toc(startscript);
    % Backup of answers after every keypressed
    save([path.res num2str(ID) '_' num2str(Session) '_backup.mat']);
trigger
breakpoint
    % ---------------- Feedback ------ %
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_feedback_onset(i)= Screen('Flip', windowPtr, t_selection_offset(i)-slack); trigger_toc2(i,12)=toc(startscreen2); 
    t_feedback_offset(i)= Screen('Flip', windowPtr, t_feedback_onset(i)+feedback_duration-slack); trigger_toc2(i,13)=toc(startscreen2); 
    t_last_onset(i+1)=t_feedback_offset(i);
trigger
breakpoint
% --------- Pause screen --------- %
        if i == numTrialsPart2
            pause_pic=imread(load_pause2, 'png');
            pause_texture=Screen('MakeTexture', windowPtr, pause_pic);
            Screen('DrawTexture', windowPtr, pause_texture, [], topcentral);
            t_pause_onset(run)= Screen('Flip', windowPtr); trigger_toc2(i,14)=toc(startscreen2); 
            startpause=tic; % start counting the seconds of pause
            %Wait untile spacebar is pressed
            clear KbCheck; % from kb to buttonbox
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
            t_pause_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc2(i,15)=toc(startscreen2); 
            trigger
            breakpoint              
            % --------- Waiting for experimenter input --------- %
            wait_pic=imread(load_wait, 'png');
            wait_texture=Screen('MakeTexture', windowPtr, wait_pic);
            Screen('DrawTexture', windowPtr, wait_texture, [], topcentral);
            t_wait_onset(run)= Screen('Flip', windowPtr); trigger_toc2(i,16)=toc(startscreen2); 
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
            t_wait_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc2(i,17)=toc(startscreen2); 
        end
            trigger
            breakpoint
        
end
time_end_second_part=toc(startscript2);
sca %Close all
%% Part 3
run=3;
[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor);
slack = Screen('GetFlipInterval', windowPtr)/2; %Calcola quanto tempo ci sta a flippare lo schermo (serve poi per il calcolo del tempo di present)
time_start_third_part=toc(startscript);
startscreen3=tic;
% Wait for trigger
while 1
        activeKeys = [KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    [keyIsDown,secs,keyCode] = KbCheck;
    disp(find(keyCode))
    if keyCode(KbName('t'))==1
        trigger_break3=toc(startscreen3);
        break
    end
end
t_last_onset(numTrialsPart2+1)=secs; trigger_toc3(numTrialsPart2+1,1)=toc(startscreen3);
trigger_time(run,1) =secs;


% Clear KB
clear KbCheck;
FlushEvents('keyDown')

% Part 3 starts
startscript3=tic; %start couting the time for completing the entire task 
for i = numTrialsPart2+1:numTrialsPart3
    fixation1_duration=ISI_1(i);
    fixation2_duration=ISI_2(i);
            counter = 1;
trigger
breakpoint
    % ---------- Fixation 1 1---------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation1_onset(i)=Screen('Flip',windowPtr, t_last_onset(i)-slack); trigger_toc3(i,2)=toc(startscreen3);
    t_fixation1_offset(i)=Screen('Flip',windowPtr,t_fixation1_onset(i)+fixation1_duration-slack); trigger_toc3(i,3)=toc(startscreen3);
trigger
breakpoint
    % ---------------- Room ---------------- %
    pic_room=imread([path.sti stimuli_list_ordered{1, 1}{i, 1}], 'jpg');
    pic_room_texture=Screen('MakeTexture', windowPtr, pic_room);
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_room_onset(i)= Screen('Flip', windowPtr, t_fixation1_offset(i)-slack); trigger_toc3(i,4)=toc(startscreen3);
    t_room_offset(i)= Screen('Flip', windowPtr, t_room_onset(i)+room_duration-slack); trigger_toc3(i,5)=toc(startscreen3);
trigger
breakpoint
    % ---------------- Empty screen ---------------- %
    pic_checker=imread(load_checker, 'bmp');
    pic_checker_texture=Screen('MakeTexture', windowPtr, pic_checker);
    Screen('DrawTexture', windowPtr, pic_checker_texture, [], topcentral);
    t_empty_onset(i)= Screen('Flip', windowPtr, t_room_offset(i)-slack); trigger_toc3(i,6)=toc(startscreen3);
    t_empty_offset(i)= Screen('Flip', windowPtr, t_empty_onset(i)+emptyscreen_duration-slack); trigger_toc3(i,7)=toc(startscreen3);
trigger
breakpoint
    % ---------------- Fixation 2 ---------------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation2_onset(i)= Screen('Flip', windowPtr, t_empty_offset(i)-slack); trigger_toc3(i,8)=toc(startscreen3);
    t_fixation2_offset(i)= Screen('Flip', windowPtr, t_fixation2_onset(i)+fixation2_duration-slack); trigger_toc3(i,9)=toc(startscreen3);
trigger
breakpoint
    
    % ---------------- Selection ---------------- %
    % Select which picture to read
    pic_cue=imread([path.sti stimuli_list_ordered{1, 2}{i, 1}], 'png');  %load cue
    pic_alt1=imread([path.sti stimuli_list_ordered{1, 3}{i, 1}], 'jpg'); % object
    pic_alt2=imread([path.sti stimuli_list_ordered{1, 4}{i, 1}], 'jpg'); % internal lure
    pic_lure=imread([path.sti stimuli_list_ordered{1, 5}{i, 1}], 'jpg'); % external lure
    %Make textures of them
    pic_cue_texture=Screen('MakeTexture', windowPtr, pic_cue);
    pic_alt1_texture=Screen('MakeTexture', windowPtr, pic_alt1);
    pic_alt2_texture=Screen('MakeTexture', windowPtr, pic_alt2);
    pic_lure_texture=Screen('MakeTexture', windowPtr, pic_lure);
    % Put them toghtether (....if you want to present them in the same screen)
    pics=[pic_cue_texture pic_alt1_texture pic_alt2_texture pic_lure_texture]';
    % Concatenate position of the pics
    positions=[topcentral' , stimuli_choice_pos{i, 1}' , stimuli_choice_pos{i, 2}' , stimuli_choice_pos{i, 3}'];
    % Flip (draw all toghether)
    Screen('DrawTextures', windowPtr, pics, [], positions);
    t_selection_onset(i)= Screen('Flip', windowPtr,  t_fixation2_offset(i)-slack); trigger_toc3(i,10)=toc(startscreen3);
    %Record response
    clear KbCheck;  % from kb to buttonbox
    %FlushEvents('keyDown')
    t1 = GetSecs;
    time = 0;
    while time < selection_timeout
        % Response keys (optional; for no subject response use empty list)
        activeKeys = [50 ,51 ,52];
        RestrictKeysForKbCheck(activeKeys);
        [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
        time = t2-t1 ;
        disp(find(keyCode))
        if (keyIsDown) %has a key been pressed?
                key = (find(keyCode));
                type= class(key);
                if type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key(i,1)= 99;
                    response_kbNum(i,1)= 99;
                    response_time(i,1)= 99;
                elseif key== 50
                    response_key(i,1)= 1; %if a was pressed, 1
                    response_time(i,1) =time;
                    keypressed = find(keyCode);
                    response_kbNum(i,1)= 2;
                elseif key == 51
                    response_key(i,1)= 2; %if space was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 3;
                elseif key == 52
                    response_key(i,1) =3; %if l was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 4;
                end
            end
        end
    clear KbCheck;  % from buttonbox to kb
    t_selection_offset(i)= Screen('Flip', windowPtr, t_selection_onset(i)+selection_timeout-slack); trigger_toc3(i,11)=toc(startscreen3);
    time_lastbackup(i)=toc(startscript);
    % Backup of answers after every keypressed
    save([path.res num2str(ID) '_' num2str(Session) '_backup.mat']);
trigger
breakpoint
    % ---------------- Feedback ------ %
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_feedback_onset(i)= Screen('Flip', windowPtr, t_selection_offset(i)-slack); trigger_toc3(i,12)=toc(startscreen3);
    t_feedback_offset(i)= Screen('Flip', windowPtr, t_feedback_onset(i)+feedback_duration-slack); trigger_toc3(i,13)=toc(startscreen3);
    t_last_onset(i+1)=t_feedback_offset(i);
trigger
breakpoint
    % --------- Pause screen --------- %
    if i == numTrialsPart3
        pause_pic=imread(load_pause3, 'png');
        pause_texture=Screen('MakeTexture', windowPtr, pause_pic);
        Screen('DrawTexture', windowPtr, pause_texture, [], topcentral);
        t_pause_onset(run)= Screen('Flip', windowPtr); trigger_toc3(i,14)=toc(startscreen3);
        startpause=tic; % start counting the seconds of pause
         %Wait untile spacebar is pressed
        clear KbCheck; % from kb to buttonbox
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
        t_pause_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc3(i,15)=toc(startscreen3);
trigger
breakpoint
            % --------- Waiting for experimenter input --------- %
            wait_pic=imread(load_wait, 'png');
            wait_texture=Screen('MakeTexture', windowPtr, wait_pic);
            Screen('DrawTexture', windowPtr, wait_texture, [], topcentral);
            t_wait_onset(run)= Screen('Flip', windowPtr); trigger_toc3(i,16)=toc(startscreen3);
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
            t_wait_offset(run)=t_pause_onset(run)+secs-slack; trigger_toc3(i,17)=toc(startscreen3);
        end
            trigger
            breakpoint
end
sca %Close all
time_end_third_part=toc(startscript3);

%% Part 4 
run=4;
[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor);
slack = Screen('GetFlipInterval', windowPtr)/2; %Calcola quanto tempo ci sta a flippare lo schermo (serve poi per il calcolo del tempo di present)
time_start_fourth_part=toc(startscript);
startscreen4=tic;
% Wait for trigger
while 1
        activeKeys = [KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    [keyIsDown,secs,keyCode] = KbCheck;
    disp(find(keyCode))
    if keyCode(KbName('t'))==1
        trigger_break4=toc(startscreen4);
        break
    end
end
t_last_onset(numTrialsPart3+1)=secs; trigger_toc4(numTrialsPart3+1,1)=toc(startscreen4);
trigger_time(run,1) =secs;

% Clear KB
clear KbCheck;
FlushEvents('keyDown')

% Part 4 starts
startscript4=tic; %start couting the time for completing the entire task 
for i = numTrialsPart3+1:numTrialsPart4
    fixation1_duration=ISI_1(i);
    fixation2_duration=ISI_2(i);
            counter = 1;
trigger
breakpoint
    % ---------- Fixation 1 1---------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation1_onset(i)=Screen('Flip',windowPtr, t_last_onset(i)-slack); trigger_toc4(i,2)=toc(startscreen4);
    t_fixation1_offset(i)=Screen('Flip',windowPtr,t_fixation1_onset(i)+fixation1_duration-slack); trigger_toc4(i,3)=toc(startscreen4);
trigger
breakpoint
    % ---------------- Room ---------------- %
    pic_room=imread([path.sti stimuli_list_ordered{1, 1}{i, 1}], 'jpg');
    pic_room_texture=Screen('MakeTexture', windowPtr, pic_room);
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_room_onset(i)= Screen('Flip', windowPtr, t_fixation1_offset(i)-slack); trigger_toc4(i,4)=toc(startscreen4);
    t_room_offset(i)= Screen('Flip', windowPtr, t_room_onset(i)+room_duration-slack); trigger_toc4(i,5)=toc(startscreen4);
trigger
breakpoint
    % ---------------- Empty screen ---------------- %
    pic_checker=imread(load_checker, 'bmp');
    pic_checker_texture=Screen('MakeTexture', windowPtr, pic_checker);
    Screen('DrawTexture', windowPtr, pic_checker_texture, [], topcentral);
    t_empty_onset(i)= Screen('Flip', windowPtr, t_room_offset(i)-slack); trigger_toc4(i,6)=toc(startscreen4);
    t_empty_offset(i)= Screen('Flip', windowPtr, t_empty_onset(i)+emptyscreen_duration-slack); trigger_toc4(i,7)=toc(startscreen4);
trigger
breakpoint
    % ---------------- Fixation 2 ---------------- %
    fixation_pic=imread(load_fixation, 'png');
    fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
    Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
    t_fixation2_onset(i)= Screen('Flip', windowPtr, t_empty_offset(i)-slack);trigger_toc4(i,8)=toc(startscreen4);
    t_fixation2_offset(i)= Screen('Flip', windowPtr, t_fixation2_onset(i)+fixation2_duration-slack); trigger_toc4(i,9)=toc(startscreen4);
trigger
breakpoint
    % ---------------- Selection ---------------- %
    % Select which picture to read
    pic_cue=imread([path.sti stimuli_list_ordered{1, 2}{i, 1}], 'png');  %load cue
    pic_alt1=imread([path.sti stimuli_list_ordered{1, 3}{i, 1}], 'jpg'); % object
    pic_alt2=imread([path.sti stimuli_list_ordered{1, 4}{i, 1}], 'jpg'); % internal lure
    pic_lure=imread([path.sti stimuli_list_ordered{1, 5}{i, 1}], 'jpg'); % external lure
    %Make textures of them
    pic_cue_texture=Screen('MakeTexture', windowPtr, pic_cue);
    pic_alt1_texture=Screen('MakeTexture', windowPtr, pic_alt1);
    pic_alt2_texture=Screen('MakeTexture', windowPtr, pic_alt2);
    pic_lure_texture=Screen('MakeTexture', windowPtr, pic_lure);
    % Put them toghtether (....if you want to present them in the same screen)
    pics=[pic_cue_texture pic_alt1_texture pic_alt2_texture pic_lure_texture]';
    % Concatenate position of the pics
    positions=[topcentral' , stimuli_choice_pos{i, 1}' , stimuli_choice_pos{i, 2}' , stimuli_choice_pos{i, 3}'];
    % Flip (draw all toghether)
    Screen('DrawTextures', windowPtr, pics, [], positions);
    t_selection_onset(i)= Screen('Flip', windowPtr,  t_fixation2_offset(i)-slack); trigger_toc4(i,10)=toc(startscreen4);
    %Record response
    clear KbCheck;  % from kb to buttonbox
    %FlushEvents('keyDown')
    t1 = GetSecs;
    time = 0;
    while time < selection_timeout
        % Response keys (optional; for no subject response use empty list)
        activeKeys = [50 ,51 ,52];
        RestrictKeysForKbCheck(activeKeys);
        [keyIsDown,t2,keyCode] = KbCheck; %determine state of keyboard
        time = t2-t1 ;
        disp(find(keyCode))
        if (keyIsDown) %has a key been pressed?
            key = (find(keyCode));
            type= class(key);
            if type ~= 'double' %If two keys pressed simultaneously, then 0
                response_key(i,1)= 99;
                response_kbNum(i,1)= 99;
                response_time(i,1)= 99;
                elseif key== 50
                    response_key(i,1)= 1; %if a was pressed, 1
                    response_time(i,1) =time;
                    keypressed = find(keyCode);
                    response_kbNum(i,1)= 2;
                elseif key == 51
                    response_key(i,1)= 2; %if space was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 3;
                elseif key == 52
                    response_key(i,1) =3; %if l was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 4;
                end
            end
        end
    clear KbCheck;  % from buttonbox to kb
    t_selection_offset(i)= Screen('Flip', windowPtr, t_selection_onset(i)+selection_timeout-slack); trigger_toc4(i,11)=toc(startscreen4);
    time_lastbackup(i)=toc(startscript);
    % Backup of answers after every keypressed
    save([path.res num2str(ID) '_' num2str(Session) '_backup.mat']);
trigger
breakpoint
    % ---------------- Feedback ------ %
    Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
    t_feedback_onset(i)= Screen('Flip', windowPtr, t_selection_offset(i)-slack); trigger_toc4(i,12)=toc(startscreen4);
    t_feedback_offset(i)= Screen('Flip', windowPtr, t_feedback_onset(i)+feedback_duration-slack); trigger_toc4(i,13)=toc(startscreen4);
    t_last_onset(i+1)=t_feedback_offset(i);
trigger
breakpoint
end
time_end_fourth_part=toc(startscript4);

% Time 
time_end=toc(startscript); %calculate time for completing entire task

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
        for r = 1:(numTrials*2)
            position=stimuli_choice_pos{r,c};
            if position(1) == pos_left(1,1)
                stimuli_choice_pos_coded(r,c)= 1;
            elseif position(1) == pos_central(1,1)
                stimuli_choice_pos_coded(r,c)= 2;
            elseif position(1) ==  pos_right(1,1)
                stimuli_choice_pos_coded(r,c)= 3;
            end
        end
    end
    
    % Find correct answers and errors
    answers=strings(numTrials*2,1);
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
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 11. Resume
    
    % Total results
    results.hints=sum(answers=="T");
    results.falseallarm=sum(answers=="IL");
    results.errors=sum(answers=="EL");
    results.missed=sum(answers=="no response");
    results.multiple=sum(answers=="multiple response");
    results.totalresponse=sum(results.hints+results.falseallarm+results.errors); %T+IL+E
    
    % Trial related results (task trial (1) /control trial (0))
    for i = 1:numTrials*2
        
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
    %Participant
    participant_info.ID=ID;
    participant_info.group_ISI=ConditionA;
    % Stimuli info
    stimuli.stimuli_randomized= stimuli_list;
    stimuli.row_randomization= rows_rand;
    stimuli.labels={'EncImg3','Cue','Right Alternative','Wrong Alternative2','ExtLure','TrialType','CueType'};
    stimuli.stimuli_ordered_per_ISI_trialtype= stimuli_list_ordered;  
    stimuli.row_ordered= rows_ordered;
    stimuli.ISI_trial_type= trial_type_ISI;
    stimuli.choice_position = stimuli_choice_pos;
    stimuli.choice_position_coded = stimuli_choice_pos_coded;
    % Answers
    answer.response_kbNum=response_kbNum;
    answer.response_key  =response_key;
    answer.response_time =response_time;
    answer.all_answers   = answers; 
    answer.task_answers = taskanswers;
    answer.control_answers = controlanswers;
    % Timing info
    timing.end=(time_end/60);                % Modify from seconds to minutes (are now in msec because calculated by Matlab)
    timing.pause=time_pause/60; 
    timing.last_backup=time_lastbackup/60; 
    timing.ISI1=ISI_1;                           % Already in seconds
    timing.ISI2=ISI_2;
    timing.fixation1_onset=t_fixation1_onset; % Already in seconds because calculated by PTB
    timing.fixation1_offset=t_fixation1_offset;
    timing.room_onset=t_room_onset;
    timing.room_offset=t_room_offset;
    timing.empty_onset=t_empty_onset;
    timing.empty_offset=t_empty_offset;
    timing.fixation2_onset=t_fixation2_onset; 
    timing.fixation2_offset=t_fixation2_offset; 
    timing.selection_onset=t_selection_onset;
    timing.selection_offset=t_selection_offset;
    timing.feedback_onset=t_feedback_onset;
    timing.feedback_offset=t_feedback_offset;
    timing.wait_onset=t_wait_onset;
    timing.wait_offset=t_wait_offset;
    timing.end_onset=t_end_onset;
    timing.end_offset=t_end_offset;
    timing.slack=slack;
    timing.triggers=time_trigger_mr;
    timing.triggers_startingpoints=trigger_time;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 13. Save results
     save([path.res num2str(ID) '_' num2str(Session) '.mat']...
        , 'participant_info' ...
        , 'stimuli' ...
        , 'results' ... 
        , 'answer' ...
        , 'timing' );