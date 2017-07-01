%clear all;
%grplist = [1 3 10 12]; %flipped

%grplist = [33 34 31 32]; %unflipped Exp2
%grplist = [35 37 36 38]; %unflipped
grplist = [43 44 45 46 47 48 49 50];
%grplist = [39 40 41 42]; %unflipped Exp1
%grplist = [41]; %unflipped
no_cond = 5;
epeaks = [1];
no_peaks = length(epeaks);

cdir = pwd;

%if isunix
%    filepath = '/scratch/cb802/Data/CRPS_Digit_Perception_exp1/SPM image files/Sensorspace_images';
%    run('/scratch/cb802/Matlab_files/CRPS_digits/loadsubj.m');
%else
%    filepath = 'W:\Data\CRPS_Digit_Perception_exp1\SPM image files\Sensorspace_images';
%    run('W:\Matlab_files\CRPS_digits\loadsubj.m');
%end

if isunix
    filepath = '/scratch/cb802/Data/CRPS_raw/SPM image files/Sensorspace_images';
    run('/scratch/cb802/Matlab_files/CRPS_digits/loadsubj.m');
else
    filepath = 'W:\Data\CRPS_raw\SPM image files\Sensorspace_images';
    run('W:\Matlab_files\CRPS_digits\loadsubj.m');
end

subjects = subjlists(grplist);

cd(filepath)
%grplist = [33 34 31 32]; %unflipped

Ns=0;
for s = 1:length(subjects)
    for s2 = 1:length(subjects{s,1}) 
        Ns=Ns+1;
        tmp_nme = subjects{s,1}{s2,1};
        tmp_nme = strrep(tmp_nme, '.left', '_left');
        tmp_nme = strrep(tmp_nme, '.Left', '_left');
        tmp_nme = strrep(tmp_nme, '.right', '_right');
        tmp_nme = strrep(tmp_nme, '.Right', '_right');
        tmp_nme = strrep(tmp_nme, '.flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '.aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '.Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '_Left', '_left');
        tmp_nme = strrep(tmp_nme, '_Right', '_right');
        tmp_nme = strrep(tmp_nme, '_Flip', '_flip');
        tmp_nme = strrep(tmp_nme, '_Aff', '_aff');
        tmp_nme = strrep(tmp_nme, '_Unaff', '_unaff');
        tmp_nme = strrep(tmp_nme, '.Exp1', '_Exp1');
        
        %tmp_nme = strrep(tmp_nme, 'left', 'left_meansub');
        %tmp_nme = strrep(tmp_nme, 'right', 'right_meansub');
        
        tmp_nme = ['maspm8_' tmp_nme];
        
        %if strfind(tmp_nme, 'left')
        %    trials = [1:5];
        %elseif strfind(tmp_nme, 'right')
        %    trials = [6:10];
        %end
            
        %for i = 1:no_cond
        %    for j = 1:no_peaks
        %        ind = (j-1)*no_cond + i;
        %        nme = dir(fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],'strial*.img'));
        %        fnames{ind,1} = fullfile(filepath,tmp_nme,['type_' num2str(trials(i))],nme.name);
        %    end
        %end
        clear fnames fnme
        fnames = dir(fullfile(filepath,tmp_nme,'scondition*.nii'));
        for f = 1:length(fnames)
            fnme{f,1} = fullfile(filepath,tmp_nme,fnames(f).name);
        end
        Output = spm_imcalc_ui(fnme,fullfile(filepath,tmp_nme,'smean.nii'),'mean(X)',{1,[],[],[]})
        
        %load('/scratch/cb802/Data/CRPS_raw/batch_smooth');
        %matlabbatch{1,1}.spm.spatial.smooth.fwhm = [12 12 0]; % space space time
        %matlabbatch{1,1}.spm.spatial.smooth.dtype = 0;
        %matlabbatch{1,1}.spm.spatial.smooth.im = 1; % implicit mask
        %imfile = 'mean.nii';
        %matlabbatch{1,1}.spm.spatial.smooth.data = {fullfile(filepath,tmp_nme,[imfile ',1'])};
        %spm_jobman('initcfg')
        %spm_jobman('run_nogui',matlabbatch);
    end
end


    