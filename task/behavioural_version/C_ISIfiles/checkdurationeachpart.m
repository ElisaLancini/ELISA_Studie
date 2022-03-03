%% Calculate time of each session (Encoding)
clear
% !!!!!!!!!!! Specify !!!!!!!!!!! 
ConditionA= 2; % which condition?

% Paths
path.root    = '/Users/elisalancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';

% Load ITI
cd(path.root);

if ConditionA ==1
    fix1=load('Enc_Fix1_1_merged.mat');
    fix2=load('Enc_Fix2_1_merged_sorted.mat');
elseif ConditionA ==2
    fix1=load('Enc_Fix1_2_merged.mat');
    fix2=load('Enc_Fix2_2_merged_sorted.mat');
end

ISI(:,1)= fix1.design_struct.eventlist(:, 4); ISI(:,2)= fix2.design_struct.eventlist(:, 4); ISI(:,3) = ISI(:,1)+ISI(:,2);
% Check sum of fixations

fix1_tot=sum(ISI(:,1));
fix2_tot=sum(ISI(:,2));
fix_tot=fix1_tot+fix2_tot;
% Calculate timing
add= (13080/1000)*40; %1308 millisecons to seconds * n of trials in a part (n=40)

% Parts
part1 = (sum(ISI(1:40,3))+add)/60;   % Part 1
part2 = (sum(ISI(41:80,3))+add)/60;  % Part 2
part3 = (sum(ISI(81:120,3))+add)/60; % Part 3
part4 = (sum(ISI(121:160,3))+add)/60;% Part 4

% Total duration of the Encoding session with this condition (condition A)
total=part1 + part2 + part3 +part4;

% Display
disp(ConditionA);disp(part1);disp(part2); disp(part3); disp(part4);disp(total);

%% Calculate time of each session (Retrieval)

clc
clear 

% !!!!!!!!!!! Specify !!!!!!!!!!! 
ConditionA= 2; %specify; 


% Paths
path.root    = '/Users/elisalancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/';

% Load ITI
cd(path.root);

if ConditionA ==1
    fix1=load('Retr_Fix1_1_repl.mat');
    fix2=load('Retr_Fix2_1_repl_sorted.mat');
elseif ConditionA ==2
    fix1=load('Retr_Fix1_2_repl.mat');
    fix2=load('Retr_Fix2_2_repl_sorted.mat');
end

ISI(:,1)= fix1.design_struct.eventlist(:, 4); ISI(:,2)= fix2.design_struct.eventlist(:, 4); ISI(:,3) = ISI(:,1)+ISI(:,2);
% Check sum of fixations

fix1_tot=sum(ISI(:,1));
fix2_tot=sum(ISI(:,2));
fix_tot=fix1_tot+fix2_tot;
% Calculate timing
add= (12500/1000)*40; %1308 millisecons to seconds * n of trials in a part (n=40)

% Parts
part1 = (sum(ISI(1:40,3))+add)/60;   % Part 1
part2 = (sum(ISI(41:80,3))+add)/60;  % Part 2

% Total duration of the Encoding session with this condition (condition A)
total=part1 + part2;

% Display
disp(ConditionA);disp(part1);disp(part2);disp(total);
