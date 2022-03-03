% Optimization fMRI task design


%% Retrieval for Fixation cross 1  (80 Stimuli, 40 trial, 40 control = 80 total trials) % Run ISI for 80 

% create and reconfigure design matrix

close all;
clear;
warning off

addpath(genpath('/Users/lancini/Dropbox/PhD/Toolbox/ISI/')) % path to the GA toolbox
addpath(genpath('/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/'))

 i=4; %list number 


            cd('/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/') % where would you like to save your models and figures?
            
            [meanrecipvif, vifs, design_struct] = generate_jittered_er_design_MainTask_Fmri_Retrieval_fix1;  % Script with parameters of Retrieval session !!!!!!!!
            
            % save diagnostics figure
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            print(['SynAge_pilot_' num2str(i) '_Diagnostics_Retr_Fix1'],'-dpng','-r0');
            close figure 1
            
            % save predicted HRF function figure
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            print(['SynAge_pilot_' num2str(i) '_PredictedActivity_Retr_Fix1'],'-dpng','-r0');
            close figure 2
            
            % tailor the design matrix to your task
            tmp = design_struct.eventlist(:,3); %The tryal types from 1 to 10 are now 1, and from 11 to 14 are now 0 (control)
            
            %tmp2(find(tmp==1),1)= 1;
            %tmp2(find(tmp==2),1)= 1;
            %tmp2(find(tmp==3),1)= 1;
            %tmp2(find(tmp==4),1)= 1; 
            %tmp2(find(tmp==5),1)= 1;
            %tmp2(find(tmp==6),1)= 1;
            %tmp2(find(tmp==7),1)= 1;
            %tmp2(find(tmp==8),1)= 0;
            %tmp2(find(tmp==9),1)= 0;

            
           
          % assign the new regime
          %  design_struct.eventlist(:,3) = tmp2; 
          design_struct.eventlist(:,3) = tmp; 
            
            % save the design matrix and efficiRetry infos
            save(['/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/Retr_Fix1_' num2str(i) '.mat' ],...
                'design_struct','meanrecipvif','vifs')

          

%% Retrieval for 2nd ISI (80 Stimuli, 40 trial, 40 control = 80 total trials) % Run ISI for 80 

% create and reconfigure design matrix

close all;
clear;
warning off

addpath(genpath('/Users/lancini/Dropbox/PhD/Toolbox/ISI/')) % path to the GA toolbox
addpath(genpath('/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/'))

i=4; %list number 


            cd('/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/') % where would you like to save your models and figures?
            
            [meanrecipvif, vifs, design_struct] = generate_jittered_er_design_MainTask_Fmri_Retrieval_fix2;  % Script with parameters of Retrieval session !!!!!!!!
            
            % save diagnostics figure
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            print(['SynAge_pilot_' num2str(i) '_Diagnostics_Retr_Fix2'],'-dpng','-r0');
            close figure 1
            
            % save predicted HRF function figure
            fig = gcf;
            fig.PaperPositionMode = 'auto';
            print(['SynAge_pilot_' num2str(i) '_PredictedActivity_Retr_Fix2'],'-dpng','-r0');
            close figure 2
            
            % tailor the design matrix to your task
            tmp = design_struct.eventlist(:,3); %The tryal types from 1 to 10 are now 1, and from 11 to 14 are now 0 (control)
            
           % tmp2(find(tmp==1),1)= 1;
           % tmp2(find(tmp==2),1)= 1;
           % tmp2(find(tmp==3),1)= 1;
           % tmp2(find(tmp==4),1)= 1; 
           % tmp2(find(tmp==5),1)= 1;
           % tmp2(find(tmp==6),1)= 1;
           % tmp2(find(tmp==7),1)= 1;
           % tmp2(find(tmp==8),1)= 0;
           % tmp2(find(tmp==9),1)= 0;

            
           
          % assign the new regime
            %design_struct.eventlist(:,3) = tmp2; 
            design_struct.eventlist(:,3) = tmp;
            
            % save the design matrix and efficiency infos
            save(['/Users/lancini/Dropbox/PhD/SynAge/place_object_task/Vmri/C_ISIfiles/Retr_Fix2_' num2str(i) '.mat' ],...
                'design_struct','meanrecipvif','vifs')

    