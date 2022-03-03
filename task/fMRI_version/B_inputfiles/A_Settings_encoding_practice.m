%% Settings for experiment
% Change these to modify main characteristics

% 30.09.2021 - Aggiunt negli input files il waiting pic
% 03.03.2022 - Modified "selection_timeout" from 3 to 5

%%
%Inizialize variables
response_key = {};
response_time = {};

% Synchronization (2 if in Mac environment, 1 in widonws to disable it. 0 if you want the synchro) 
Screen('Preference','SkipSyncTests', 0);


% Keyboard setting
KbName('UnifyKeyNames');



%Pictures dimensions
gap=0; %gap between top of the screen and room
%picHeight=600; %measure of room picutures
%picWidth=800;
%gapHeight= 0; %gap between main room image and choice options (alternative 1, 2 and lure)
%objpicHeight=250; %measure of objects
%objpicWidth=250;
picHeight=500; %measure of room picutures
picWidth=700;
gapHeight= 0; %gap between main room image and choice options (alternative 1, 2 and lure)
objpicHeight=230; %measure of objects
objpicWidth=230;

%Fixation cross dimensions
crossLenght = 10;
crossWidth= 3;

% Number of trials
numTrials=7;

% Pictures for breaks and end screen 
load_checker = 'D:\Elisa\PlaceObjectTask\Stimuli\checker';
load_fixation='D:\Elisa\PlaceObjectTask\Stimuli\fix';
load_pause='D:\Elisa\PlaceObjectTask\Stimuli\Pause';
load_endscreen= 'D:\Elisa\PlaceObjectTask\Stimuli\End_practice';

% Number of trials to show before a break (for no breaks, choose a number
% greater than the number of trials in your experiment)
breakAfterTrials_encoding = numTrials;
breakAfterTrials_retrieval = numTrials/2;

% Background color: choose a number from 0 (black) to 255 (white)
backgroundColor = 0;
crossColor = 255;

% Text color: choose a number from 0 (black) to 255 (white)
textColor = 255;

% How long (in seconds) each image in the ENCODING task will stay on screen
room_duration = 7; %seconds
selection_timeout = 5; 
feedback_duration = 3; %7000 msec stessa immagine dell inizio
emptyscreen_duration = 0.80; %seconds 
fixation1_duration = 2.5; %seconds 
fixation2_duration = 2.5; %seconds 

% Response keys
key1=50;
key2=51;
key3=52;

% Timeout settings
%RestrictKeysForKbCheck(activeKeys);
ListenChar(2); % suppress echo to the command line for keypresses (https://de.mathworks.com/matlabcentral/answers/310311-how-to-get-psychtoolbox-to-wait-for-keypress-but-move-on-if-it-hasn-t-recieved-one-in-a-set-time)

