clear all
close all
dname = pwd;

cd(dname);
%grplist = [39 40 41 42];  %Affected vs unaffected exp1
%grplist = [35 36 37 38]; 
grplist = [1 2 29 30]; %sublist_side = {'L','R','L','R'}; %Affected vs %unaffected exp2

no_cond = 1; % no of conditions per data file (arm)

Rdir = '/scratch/cb802/Data/CRPS_Digit_Perception_exp1/SPM image files/Sensorspace_masks';
%Rdata = 'W:\Brain_atlas_Hammers2003\Hammers_mith_atlas_n30r83_SPM5.img';

regions = {'40ms_cluster_mask.nii';
    '88ms_cluster_mask.nii';
	'pain_corr_exp1_mask.nii';
    };
Nreg = size(regions,1);

if isunix
    filepath = '/scratch/cb802/Data/CRPS_Digit_Perception/SPM image files/Sensorspace_images';
    run('/scratch/cb802/Matlab_files/CRPS_digits/loadsubj.m');
else
    filepath = 'W:\Data\CRPS_Digit_Perception\SPM image files\Sensorspace_images';
    run('W:\Matlab_files\CRPS_digits\loadsubj.m');
end

subjects = subjlists(grplist);

results = cell(1,length(subjects));

for s = 1:length(subjects)
    results{1,s} = cell(1,length(subjects{s,1}));
    for s2 = 1:length(subjects{s,1}) 
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
        
        tmp_nme = ['maspm8_' tmp_nme];
        
        if strfind(tmp_nme, 'left')
            trials = [1:5];
        elseif strfind(tmp_nme, 'right')
            trials = [6:10];
        end
        
        fnames = [];
        for i = 1:no_cond
            ind = (s2-1)*no_cond + i;
            nme = dir(fullfile(filepath,tmp_nme,'smean.img'));
            for n = 1:length(nme)
                if strfind(nme(n).name,'flip'); continue; end;
                fnames{length(fnames)+1,1} = fullfile(filepath,tmp_nme,nme(n).name);
            end
        end
        
        for r = 1:Nreg
            for f = 1:length(fnames)
                Pdata = fnames{f,1};
                Rdata = fullfile(Rdir,regions{r});
                input{1,1} = Pdata;
                input{2,1} = Rdata;
                expres = 'i1.*i2';
                [pth nm ext] = fileparts(fnames{f,1});
                Pfname_out = fullfile(pth, [nm '_' regions{r}]);
                if ~exist(Pfname_out,'file') Output = spm_imcalc_ui(input,Pfname_out,expres);
                end
            end
        end

        
        results{1,s}{1,s2} = cell(length(fnames)+1,Nreg+1);
        for f = 1:length(fnames)
            results{1,s}{1,s2}{f+1,1} = str2num(fnames{f,1}(end-7:end-4));
        end
        results{1,s}{1,s2}(1,2:end) = regions';
        results{1,s}{1,s2}(2:end,2:end) = num2cell(NaN(size(results{1,s}{1,s2}(2:end,2:end))));

        Rnii = load_nii(Rdata);
        for r = 1:Nreg
            region = regions{r};
            Rsize = length(find(Rnii.img==1)); 
            for f = 1:length(fnames)
                [pth nm ext] = fileparts(fnames{f,1});
                Pdata = fullfile(pth, [nm '_' regions{r}]);
                nii = load_nii(Pdata);
                nii_all = nii.img(nii.img~=0);
                nii_mean = sum(nii_all)/Rsize;
                results{1,s}{1,s2}{f+1,(1+r)} = nii_mean;
            end
        end
        %[sorted si] = sort([results{1,s}{1,s2}{2:end,1}]);
        %for col = 1:length(results{1,s}{1,s2}(1,:))
        %    results{1,s}{1,s2}(2:end,col) = results{1,s}{1,s2}(si+1,col);
        %end
        
    end
end



save clustersERP.mat results;

% generate correlation coefficients
slopes = [];
for s = 1:length(subjects)
    for s2 = 1:length(subjects{s,1}) 
        for r = 1:Nreg
            rho = corr(single([results{1,s}{1,s2}{2:end,1}]'), single([results{1,s}{1,s2}{2:end,r+1}]'),'type','Spearman');
            slopes(r,s,s2) = rho;
        end
    end
end

close all
for r = 1:Nreg
    figure
    X = 1:4;
    Y = squeeze(mean(slopes(r,:,:),3));
    E = std(squeeze(slopes(r,:,:))')/sqrt(size(slopes(r,:,:),3));
    errorbar(X,Y,E);
    p = anova1(squeeze(slopes(r,:,:))');
end
