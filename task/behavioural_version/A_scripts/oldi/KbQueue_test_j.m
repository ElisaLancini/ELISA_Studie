clearvars  
clear KbCheck;
clc

%{
while 1
    activeKeys = [KbName('t'),KbName('l')];
    RestrictKeysForKbCheck(activeKeys);
    [keyIsDown,secs,keyCode] = KbCheck(-1);
    disp(KbName(find(keyCode)))
    if keyCode(KbName('t'))==1
        break
    end
end
%}

[window, rect]=Screen('OpenWindow',0);  % open screen
%ListenChar(-1); %makes it so characters typed don?t show up in the command window
HideCursor(); %hides the cursor

KbQueueDevice = -1; %-1 = all keyboard device
param = {'e'};


if ischar(param) || iscellstr(param) % key names
        kCode = zeros(256, 1);
        kCode(KbName(param)) = 1;
elseif length(param)==256 % full keycode
        kCode = param;
else
        kCode = zeros(256, 1);
        kCode(param) = 1;        
end


KbName('UnifyKeyNames'); %used for cross-platform compatibility of keynaming
KbQueueCreate(KbQueueDevice, kCode); %creates cue using defaults
KbQueueStart(KbQueueDevice);  %starts the cuell

for trial=1:5 %runs 5 trials
    IM1=rand(100,100,3)*255; %creates random colored image
    tex(1) = Screen('MakeTexture', window, IM1); %makes texture
    Screen('DrawTexture', window, tex(1), []); %draws to backbuffer
    WaitSecs(rand+.5) %jitters prestim interval between .5 and 1.5 seconds

    starttime=Screen('Flip',window); %swaps backbuffer to frontbuffer
    KbQueueFlush; %Flushes Buffer so only response after stimonset are recorded
    WaitSecs(.9);  %gives .5 secs for a response

    [ pressed, firstPress]=KbQueueCheck; %  check if any key was pressed.
    p = firstPress;
    disp(trial)
    disp(length(p))
    disp(p)

    if pressed %if key was pressed do the following
        firstPress(find(firstPress==0))=NaN; %little trick to get rid of 0s
        [endtime Index]=min(firstPress); % gets the RT of the first key-press and its ID
        thekeys=KbName(Index); %converts KeyID to keyname
        RTtext=sprintf('Response Time =%1.2f secs with %s-key',endtime-starttime,thekeys); %makes feedback string
    else
        RTtext=sprintf('Sorry, too slow!'); %makes feedback string
    end
    DrawFormattedText(window,RTtext,'center'  ,'center',[255 0 255]); %shows RT
    vbl=Screen('Flip',window); %swaps backbuffer to frontbuffer
    Screen('Flip',window,vbl+1); %erases feedback after 1 second
end
   

ListenChar(0); %makes it so characters typed do show up in the command window
ShowCursor(); %shows the cursor
Screen('CloseAll'); %Closes Screen