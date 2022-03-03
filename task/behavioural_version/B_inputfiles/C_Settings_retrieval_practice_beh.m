%% Settings for experiment
% Change these to modify main characteristics

% LOG
%   03.03.2022 Modified "selection_timeout" from 5 to 7; 

%Inizialize variables
response_key = {};
response_time = {};

% Synchronization (2 if in Mac environment, 1 in widonws to disable it. 0 if you want the synchro) 
Screen('Preference','SkipSyncTests', 0);


% Keyboard setting
KbName('UnifyKeyNames');

%Pictures dimensions
% measures for presenting stimuli in the middle of the screen 
gap=100; %gap between top of the screen and room
picHeight=500; %measure of room picutures
picWidth=700;
gapHeight= 20; %gap between main room image and choice options (alternative 1, 2 and lure)
objpicHeight=230; %measure of objects
gapHeight= 20; %gap between main room image and choice options (alternative 1, 2 and lure)
objpicWidth=230;

%Fixation cross dimensions
crossLenght = 10;
crossWidth= 3;

% Number of trials
numTrials=7;

% Pictures for breaks and end screen 
load_checker = 'C:\Users\lancini\Documents\MATLAB\ELISA-Studie\E_stimuli\checker';
load_fixation='C:\Users\lancini\Documents\MATLAB\ELISA-Studie\E_stimuli\fix';
load_pause='C:\Users\lancini\Documents\MATLAB\ELISA-Studie\E_stimuli\Pause';
load_endscreen= 'C:\Users\lancini\Documents\MATLAB\ELISA-Studie\E_stimuli\End';
load_categorization1='C:\Users\lancini\Documents\MATLAB\ELISA-Studie\E_stimuli\Categorization1';
load_categorization2='C:\Users\lancini\Documents\MATLAB\ELISA-Studie\E_stimuli\Categorization2';

% Number of trials to show before a break (for no breaks, choose a number
% greater than the number of trials in your experiment)
breakAfterTrials_encoding = numTrials;
breakAfterTrials_retrieval = numTrials/2;

% Background color: choose a number from 0 (black) to 255 (white)
backgroundColor = 0;

% Text color: choose a number from 0 (black) to 255 (white)
textColor = 255;
crossColor = 255;

% How long (in seconds) each image in the RETRIEVAL task will stay on screen
cue_duration = 4.5; %3500 in young, 4500 msec in old
classification_timeout= 3; 
selection_timeout = 7; %3000 msec = meno di 4500
fixation_duration = 2.5; 

% Timeout settings
ListenChar(2); % suppress echo to the command line for keypresses (https://de.mathworks.com/matlabcentral/answers/310311-how-to-get-psychtoolbox-to-wait-for-keypress-but-move-on-if-it-hasn-t-recieved-one-in-a-set-time)


