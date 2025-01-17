%% (A) Encoding - fMRI Practice session

% 30.09 : 
% - messa la possibilita di mantenere la schermata finale fino a che non premo la e. 
% - Variable "run" is not necessary as it is a 1 run code

% 8.10 : Schermata finale che dice "practice test finito" invece di "test finito"

% 14.10 : Testrun con i=3 : positivo
% 22.02.2022 : In the dialog box 
 %- "Participant number" is replaced with "Randonummer"
 % - "Append an R" is replaced with "Add "2" to the Randonummer"
 % And code changed, not an R but a 2 in case of repetition
e
clearvars
clear KbCheck;
clc
%cd('C:\Users\lancini\Documents\MATLAB\Psychtoolbox')
%SetupPsychtoolbox
%% 1. Set paths
path.root    = 'D:\Elisa\ELISA-Studie\';
path.task    = [ path.root 'A_scripts']; %Stimlist is here
path.sti     = 'D:\Elisa\PlaceObjectTask\Stimuli\Place_object\A_All_stimuli\';
path.res     = [ path.root 'D_results\'];
path.input   = [ path.root 'B_inputfiles\'];
path.config  = [ path.root 'C_ISIfiles\'];
%path.ptb   =  'C:/Users/lancini/Documents/MATLAB/Psychttoolbox/';% Path PTB
%path.gstreamer= 'C:\gstreamer\1.0\x86_64\bin';
addpath(genpath(path.task));

%% 2. Subject infos

% Subject informations
input_prompt = {'Randonummer';'Session (1=A, 2=B, 3=C, 4=D, 5=E, 6=F)'};
input_defaults     = {'01','99'}; % Mostra input default per non guidare l'inserimento
input_answer = inputdlg(input_prompt, 'Informations', 1, input_defaults);
clear input_defaults input_prompt
%Modifiy class of variables
ID          = str2num(input_answer{1,1});
Session     = str2num(input_answer{2,1});
%Modifiy class of variables
if Session ~= 1
    errordlg('You are running the wrong script','Session error');
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
%% 2. Load settings
cd(path.input)
A_Settings_encoding_practice;
% Create variables
idx=[];

%% 4. Pre allocate variables

response_key=zeros(numTrials*2,1); %Key pressed
response_time=zeros(numTrials*2,1); %Time of key press
response_kbNum=zeros(numTrials*2,1); %Number of key pressed
idx=[]; %Index of cue of the first block (cue 1 or cue 2?)
time_pause=zeros(1,numTrials*2);
time_end=999;
events=cell(1,2);


global time_escape_mr;
time_escape_mr = 0;

global time_trigger_mr;
time_trigger_mr=zeros(numTrials*2,5);

global counter;

global i;

%% 3. Load stimuli list (inputfile)
fid=fopen('inputfile_practice.txt','r');
inputfile=textscan(fid,'%s%s%s%s%s%s%s%f', 'HeaderLines', 1);
fclose(fid);
clear fid

%% 6. Randomization

% ---------- Randomize cue 1 or 2 presentation in block 1 or 2 ! -------- %

%Create the variable stimuli_list
stimuli_list= cell(1,6);
% Randomize cue, alternative and lure pic for every row (1:140)
% randomize trial type (1 or 2 ? )
idx= randi(2,8,1);
% randomize rows number
rows1=(1:numTrials); %From 1 to 8
rows_rand1=rows1(randperm(length(rows1)))'; % Randomize the order
rows2=(numTrials+1:numTrials*2); % From 8 to 16
rows_rand2=rows2(randperm(length(rows2)))'; %Randomize the order
clear rows1 rows2
% Extract type of stimulus for each stimuli
type=inputfile{1, 8};
% Re-order every row depending on the new row list
for n=1:numTrials
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
        stimuli_list{1, 5}{x, 1} = inputfile{1, 6}{n, 1};  %external lure 1
    else
        stimuli_list{1, 2}{x, 1} = inputfile{1, 3}{n, 1}; %cue 2
        stimuli_list{1, 3}{x, 1} = inputfile{1, 5}{n, 1}; %object 2
        stimuli_list{1, 4}{x, 1} = inputfile{1, 4}{n, 1}; %internal lure (alternative 1)
        stimuli_list{1, 5}{x, 1} = inputfile{1, 7}{n, 1}; %external lure 2
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
        stimuli_list{1, 5}{y, 1} = inputfile{1, 7}{n, 1}; %external lure 2
        idx(y,1)=2; % ...save as 2
    else %if before was 2...now is 1
        stimuli_list{1, 2}{y, 1} = inputfile{1, 2}{n, 1};  %cue 1
        stimuli_list{1, 3}{y, 1} = inputfile{1, 4}{n, 1};  %dependeing on cue, this is the right object
        stimuli_list{1, 4}{y, 1} = inputfile{1, 5}{n, 1};  %internal lure (alternative 2)
        stimuli_list{1, 5}{y, 1} = inputfile{1, 6}{n, 1};  %external lure 1
        idx(y,1)=1; %...save as 1
    end
end
% Add concatenated indexes in the 7th column (cue 1 or 2?)
stimuli_list{:, 7}=idx;
clear type x y n



% --------------  Randomize stimuli position on the screen -------------- %
%[windowPtr,rect]=Screen('OpenWindow',0,backgroundColor,[0 0 800 600])
%smaller

%normal size
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

for x=1:(numTrials*2)
    stimuli_choice_pos(x,:)=Shuffle(where);
end

%% 7. Save randomization information
save([path.res num2str(ID) '_' num2str(Session) '_randinfo.mat']);
%% TASK

%% ------ Empty screen - waiting for trigger ------ %

while 1
    activeKeys = [KbName('t')];
    RestrictKeysForKbCheck(activeKeys);
    [keyIsDown,secs,keyCode] = KbCheck;
    disp(find(keyCode))
    if keyCode(KbName('t'))==1
        break
    end
end
t_last_onset(1)=secs;
trigger_time(1,1) =secs;

%% Clear KB
clear KbCheck;
FlushEvents('keyDown')

%% ------ Stimuli presentation ------ %
startscript=tic; %start couting the time for completing the entire task

 for i = 1:numTrials*2
            counter = 1;
trigger
breakpoint
     
             % ---------- Fixation 1 1---------- %
             fixation_pic=imread(load_fixation, 'png');
             fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
             Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
             t_fixation1_onset(i)=Screen('Flip',windowPtr, t_last_onset(i)-slack);
             t_fixation1_offset(i)=Screen('Flip',windowPtr,t_fixation1_onset(i)+fixation1_duration-slack);
trigger
breakpoint
     
         % ---------------- Room ---------------- %
            pic_room=imread([path.sti stimuli_list{1, 1}{i, 1}],'jpg'); 
            pic_room_texture=Screen('MakeTexture', windowPtr, pic_room);
            Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
            t_room_onset(i)= Screen('Flip', windowPtr, t_fixation1_offset(i)-slack); % show image
            t_room_offset(i)= Screen('Flip', windowPtr, t_room_onset(i)+room_duration-slack); % show image

trigger
breakpoint
            % ---------------- Checker screen ---------------- %
            pic_checker=imread(load_checker, 'bmp');
            pic_checker_texture=Screen('MakeTexture', windowPtr, pic_checker);
            Screen('DrawTexture', windowPtr, pic_checker_texture, [], topcentral);
            t_empty_onset(i)= Screen('Flip', windowPtr, t_room_offset(i)-slack); % show image
            t_empty_offset(i)= Screen('Flip', windowPtr, t_empty_onset(i)+emptyscreen_duration-slack); % show image
trigger
breakpoint
            % ---------------- Fixation 2 ---------------- %
            fixation_pic=imread(load_fixation, 'png');
            fixation_texture=Screen('MakeTexture', windowPtr, fixation_pic);
            Screen('DrawTexture', windowPtr, fixation_texture, [], topcentral);
            t_fixation2_onset(i)= Screen('Flip', windowPtr, t_empty_offset(i)-slack); % show image
            t_fixation2_offset(i)= Screen('Flip', windowPtr, t_fixation2_onset(i)+fixation2_duration-slack); % show image
trigger
breakpoint  
        
        % ---------------- Selection ---------------- %
        % Select which picture to read
        pic_cue=imread([path.sti stimuli_list{1, 2}{i, 1}], 'png');  %load cue
        pic_alt1=imread([path.sti stimuli_list{1, 3}{i, 1}], 'jpg'); % object
        pic_alt2=imread([path.sti stimuli_list{1, 4}{i, 1}], 'jpg'); % internal lure
        pic_lure=imread([path.sti stimuli_list{1, 5}{i, 1}], 'jpg'); % external lure
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
        t_selection_onset(i)= Screen('Flip', windowPtr,  t_fixation2_offset(i)-slack);
        %Record response
        clear KbCheck;  % from kb to buttonbox
%         FlushEvents('keyDown')
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
                disp(key);
                type= class(key);
                if type ~= 'double' %If two keys pressed simultaneously, then 0
                    response_key(i,1)= 99;
                    response_kbNum(i,1)= 99;
                    response_time(i,1)= 99;
                elseif key== 50
                    response_key(i,1)= 1; %if a was pressed, 1
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 2;
                elseif key== 51
                    response_key(i,1)= 2; %if space was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 3;
                elseif key== 52
                    response_key(i,1) =3; %if l was pressed, 2
                    response_time(i,1) =time;
                    response_kbNum(i,1)= 4;
                end
            end
        end
        clear KbCheck;  % from buttonbox to kb
        t_selection_offset(i)= Screen('Flip', windowPtr, t_selection_onset(i)+selection_timeout-slack);
        time_lastbackup(i)=toc(startscript);
        % Backup of answers after every keypressed
        save([path.res num2str(ID) '_' num2str(Session) '_backup.mat']);
trigger
breakpoint
        % ---------------- Feedback ------ %
        Screen('DrawTexture', windowPtr, pic_room_texture, [], topcentral);
        t_feedback_onset(i)= Screen('Flip', windowPtr, t_selection_offset(i)-slack); % show image
        t_feedback_offset(i)= Screen('Flip', windowPtr, t_feedback_onset(i)+feedback_duration-slack); % show image
        t_last_onset(i+1)=t_feedback_offset(i);
trigger
breakpoint
         % --------- Half stimuli pause --------- %

      if i == breakAfterTrials_encoding
        pause_pic=imread(load_pause, 'png');
        pause_texture=Screen('MakeTexture', windowPtr, pause_pic);
        Screen('DrawTexture', windowPtr, pause_texture, [], topcentral);
        t_pause_onset(i)= Screen('Flip', windowPtr); % show image
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
        time_pause(i)=toc(startpause); % how many seconds of pause did the participant take?
        clear tic % so it doesn't interfere with the main tic
        t_pause_offset(i)=t_pause_onset(i)+secs-slack; %variable that in the loop becames the fixation timestamp
      end
trigger
breakpoint
    end
    time_end=toc(startscript); %calculate time for completing entire task
    
    %%  -------- End screen -------- %
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
    time_wait=toc(startwait); % how many seconds of pause did the participant take?
    clear tic
    t_end_offset=t_end_onset(end)+secs-slack; %variable that in the loop becames the fixation timestamp
    sca %Close all
    
        %% 8. Re enable keyboard
        RestrictKeysForKbCheck;
        ListenChar(0);

        %% 9. Save before analysis
         save([path.res num2str(ID) '_' num2str(Session) '_raw.mat']);

        %% 10. Analyze answers

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

        %% 11. Resume

        % Total results
        results.hints=sum(answers=="T");
        results.falseallarm=sum(answers=="IL");
        results.errors=sum(answers=="EL");
        results.missed=sum(answers=="no response");
        results.multiple=sum(answers=="multiple response");
        results.totalresponse=sum(results.hints+results.falseallarm+results.errors); %T+IL+E

        % Trial related results (task trial (1) /control trial (0))
        for i = 1:numTrials*2

            if stimuli_list{1, 6}{i, 1} == 1
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

        %% 12. Save
        stimuli.stimuli_randomized= stimuli_list;
        stimuli.row_randomization= [rows_rand1 ; rows_rand2];
        stimuli.choice_position = stimuli_choice_pos;
        stimuli.choice_position_coded = stimuli_choice_pos_coded;

        answer.response_kbNum=response_kbNum;
        answer.response_key  =response_key;
        answer.response_time =response_time;
        answer.all_answers   = answers; 
        answer.task_answers = taskanswers;
        answer.control_answers = controlanswers;

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
        timing.end_onset=t_end_onset;
        timing.end_offset=t_end_offset;
        timing.slack=slack;


        participant_info.ID=ID;

        %% 13. Save results
         save([path.res num2str(ID) '_' num2str(Session) '.mat']...
            , 'participant_info' ...
            , 'stimuli' ...
            , 'results' ... 
            , 'answer' ...
            , 'timing' );

        %% Show results 
        
        
        errornum=results.falseallarm+results.errors+results.missed;
        message = sprintf('Mistakes: %d out of 16 trials ', errornum );
        msgbox(message);
      
