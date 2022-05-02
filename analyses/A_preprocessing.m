%% PREPROCESSING PIPELINE ELISA-STUDIE 2021
% last update 30.09.2021

% 1. Slice timing (output has "a" as prefix)

% 2. Calculate VDM ((voxel displacement map) to undistort a single epi image.
     % Use Magnitude image wiht short TR (Suggested by Claus)
% To apply the fieldmap correction (i.e. the resulting vdm file) to an EPI time series, one would typically use Realign&Unwarp. 

% 3. Realign and unwarp (output has "u" as prefix)
% The undistorted image (prefix='u') can be used as a visual check of the fieldmap correction.

% 4. Smooth (output has "s" as prefix, in this case "s3" as 3mm smoothing )

% oj69_4212 done

%% GENERAL VARIABLES (outside loop)

addpath('/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/data analysis');

% Environmental variables
clear; clc
warning('off','all');
log= [0,0,0,0,0];

% Fixed Paths
paths = [];
paths.parent  = '/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/data/pilot data ELISA/';

paths.anatom = 'series_5_t1_mpr_sag_1iso_p2';
paths.phase ='series_15_gre_field_mapping_2iso_74sl_acpc';
paths.magnitude ='series_14_gre_field_mapping_2iso_74sl_acpc';

% Fixed Variables
info.volumes = 325; %spm_vol('series_7_fMRI_SMS2_2iso_74sl_TR2.4_vol325_encoding_run1_fMRI_SMS2_2iso_74sl_TR2.4_vol325_encoding_run1_20210603083252_7.nii');V(1).dim % find volumes
info.smoothKernel = 3; % smoothing
info.TR=2.4;

% IDs and dates
participantsID_MRT = ["oj69_4212"]; % !!Is now strings but then transformed into char to work in the loop!!
participantsID_behavioural = "90";
participants_testing_date = "20210603";

%% ID-SPECIFIC PART

for ii=1:length(participantsID_MRT)
    
    % ------------------------------- VARIABLES -------------------------------
    % ID-specific variables
    ID= char(participantsID_MRT(ii)); % !!Has to be char to work!!
    IDbeh= char(participantsID_behavioural(ii));
    date= char(participants_testing_date(ii));
    
    % ID-specific path
    paths.func = [paths.parent ID '/study_1_' date];
    
    % number of slices
    V = spm_vol('/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/data/pilot data ELISA/oj69_4212/study_1_20210603/series_7_fMRI_SMS2_2iso_74sl_TR2.4_vol325_encoding_run1/series_7_fMRI_SMS2_2iso_74sl_TR2.4_vol325_encoding_run1_fMRI_SMS2_2iso_74sl_TR2.4_vol325_encoding_run1_20210603083252_7.nii');
    info.number_of_slices = V(1).dim(3);
    
    % Load info
    %results.encoding = load([paths.behav num2str(IDbeh) '_2.mat']); % behavioural
    %results.retrieval = load([paths.behav num2str(IDbeh) '_4.mat']);
    
    % FUNCTIONAL FILES list
    runsreference=[7,9,11,13];
    for ses=1:4
        run=runsreference(ses);
        [tmp1,tmp2,FileList{ses}]=dirr([paths.func,filesep,'series_',sprintf('%01i',run),'_','fMRI_SMS2_2iso_74sl_TR2.4_vol325_encoding_run',sprintf('%01i',ses) ],'^series.*\.nii$','name'); % extract nii file name per each session
    end
    for i=1:info.volumes
        FileListFunction{1, 1}{i, 1}= [FileList{1, 1}{1, 1},',',num2str(i)]; % add to that nii file a comma and numbers from 1 to 325, meaning that we select all volumes.
        FileListFunction{1, 2}{i, 1}= [FileList{1, 1}{1, 1},',',num2str(i)];
        FileListFunction{1, 3}{i, 1}= [FileList{1, 1}{1, 1},',',num2str(i)];
        FileListFunction{1, 4}{i, 1}= [FileList{1, 1}{1, 1},',',num2str(i)];
    end
    clear i tmp1 tmp2 FileList
    
    % ANATOMICAL FILES variables
    [tmp1,tmp2,FileList{1}]=dirr([paths.func,filesep,paths.anatom], '^.*\.nii$','name'); % extract nii file name per each session
    FileListStruct{1, 1}{1, 1}= [FileList{1, 1}{1, 1},',1'];
    
    % PHASE (one file: difference between the two echoes) and MAGNITUDE files (two fiels: 1st echo and 2nd echo) variables. 
        % Phase
        files=dir(fullfile(paths.func,filesep,paths.phase,'series*e2_ph.nii'));
        FileListPhase{1, 1}{1, 1}=[files.folder '/' files.name ',1'  ]  ;      clear tmp1 tmp2 files % extract nii file name per each session
        % Magnitude (In this case we only use magnitude data from the first echo (Jörn Kaufmann and Claus´ suggestion, email from 20/09/2021))
        files=dir(fullfile(paths.func,filesep,paths.magnitude,'series*e1.nii'));
        FileListMagnitude{1, 1}{1, 1}=[files.folder '/' files.name ',1'  ]  ;  clear tmp1 tmp2 files % extract nii file name per each session
    
    % ANATOMICAL FILE for comparison (for the VDM calculation)
    StructFileList{1, 1}{1, 1} = [ paths.func '/' 'series_15_gre_field_mapping_2iso_74sl_acpc/series_5_t1_mpr_sag_1iso_p2_t1_mpr_sag_1iso_p2_' date '_5.nii,1'];
    
    % ------------------------------- START PREPROCESSING -------------------------------
    spm('Defaults','fmri')
    
    % 1. Slice timing (output has "a" as prefix)
    spm_jobman('initcfg')
    matlabbatch{1}.spm.temporal.st.scans =FileListFunction;
    matlabbatch{1}.spm.temporal.st.nslices = 74;
    matlabbatch{1}.spm.temporal.st.tr = 2.4;
    matlabbatch{1}.spm.temporal.st.ta = 2.4-(2.4/info.TR);
    matlabbatch{1}.spm.temporal.st.so = [1:2:info.number_of_slices   2:2:info.number_of_slices  ]; %assuming it is interleaved (bottom -> up)
    matlabbatch{1}.spm.temporal.st.refslice = 1;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    log(ii,1)=1; % to keep track 
    spm_jobman('run',matlabbatch)
    clear matlabbatch

    
    % ------------------------------- 2. Calculate VDM
    
    % Explanation:   Generate unwrapped field maps which are converted to voxel displacement maps (VDM) that can be used to unwarp geometrically distorted EPI images.
    % Output:        VDM  files  are  saved  with  the  prefix  vdm  in the folder "series_15_gre_field_mapping_2iso_74sl_acpc"
    
    % The  resulting  VDM  files  can  be  applied  to  images  using  Apply  VDM  or  in combination with Realign & Unwarp to calculate and correct for the combined 
    % effects of static and movement-related susceptibility induced distortion
    spm_jobman('initcfg')
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase = {FileListPhase}  ;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude = {FileListMagnitude}  ;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsfile = {'/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/data analysis/pm_defaults.m'};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session(1).epi = FileListFunction{1, 1}{1, 1}  ;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session(2).epi = FileListFunction{1, 2}{1, 1}  ;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session(3).epi = FileListFunction{1, 3}{1, 1}  ;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session(4).epi = FileListFunction{1, 4}{1, 1}  ;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 0; %do not match VDM to EPI 
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 1;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = StructFileList{1, 1}{1, 1};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 1;
    log(ii,2)=1; % to keep track 
    spm_jobman('run',matlabbatch)
    clear matlabbatch

    % ------------------------------- 3. Realign and unwarp (output has "u" as prefix)
    
    % Explanation:      Within-subject registration and unwarping of time series.
    %                   The  realignment part of this routine realigns a time-series of images acquired from the same subject using a least squares approach and a 6 parameter (rigid body) spatial transformation.  The first image in the list specified by the user is used as a reference to
    %                   which all subsequent scans are realigned. The reference scan does not have to the the first chronologically and it may be wise to chose a "representative scan" in this role.
    %                   The  aim  is  primarily  to  remove  movement  artefact  in  fMRI  and  PET  time-series  (or  more  generally  longitudinal  studies).  This  affects  the header of each of the input images which contains details about the voxel-to-world mapping. The details of the
    %                   transformation are displayed in the results window as plots of translation and rotation. A set of realignment parameters are saved for each session, named rp_*.txt.
    % Output:           files  are  saved  with  the  prefix  "u"  in the folders "series_7_" , "series_9_", "series_11_", "series_13_"
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.realignunwarp.data(1).scans = FileListFunction{1, 1} ;
    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{1}));
    
    % Depend (?)
    %/Users/lancini/Dropbox/PhD/SynAge/project ELISA study/data/pilot data ELISA/oj69_4212/study_1_20210603/series_15_gre_field_mapping_2iso_74sl_acpc/vdm5_scseries_15_gre_field_mapping_2iso_74sl_acpc_gre_field_mapping_2iso_74sl_acpc_20210603083252_15_e2_ph_session1.nii
   
    matlabbatch{1, 3}.spm.spatial.realignunwarp.data(2).scans  =FileListFunction{1, 2}  ;
    matlabbatch{1}.spm.spatial.realignunwarp.data(2).pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 2)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{2}));
    matlabbatch{1, 3}.spm.spatial.realignunwarp.data(3).scans  = FileListFunction{1, 3} ;
    matlabbatch{1}.spm.spatial.realignunwarp.data(3).pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 3)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{3}));
    matlabbatch{1, 3}.spm.spatial.realignunwarp.data(4).scans  = FileListFunction{1, 4}  ;
    matlabbatch{1}.spm.spatial.realignunwarp.data(4).pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 4)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{4}));
    
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 3;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    log(ii,3)=1; % to keep track 
    spm_jobman('run',matlabbatch)
    clear matlabbatch

    % ------------------------------- 4. Smooth (output has "s" as prefix, in this case "s3" as 3mm
    % smoothing ) - Results can be found in "series 7 / 9 / 11 / 13" 
    spm_jobman('initcfg')
    matlabbatch{1}.spm.spatial.smooth.data = [FileListFunction{1, 1} ;FileListFunction{1, 2};  FileListFunction{1, 3}; FileListFunction{1, 4} ];
    matlabbatch{1}.spm.spatial.smooth.fwhm = [3 3 3];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's3';
    log(ii,4)=1; % to keep track 
    spm_jobman('run',matlabbatch)
    clear matlabbatch
    
    clear matlabbatch
    log_file(1,ii) = participantsID_MRT(ii);
end








