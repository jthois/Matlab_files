% extract, tabulate and save parameters and summary stats of trajectories

close all
clear all
dbstop if error
restoredefaultpath

% add toolbox paths
run('C:\Data\Matlab\Matlab_files\CORE\CORE_addpaths')

% file info
S.path.hgf = 'C:\Data\CORE\behaviour\hgf\fitted'; 
%fname='CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20180821T134505.mat'; % FITTED %alpha prior = 0.5
%fname='CORE_fittedparameters_percmodel12_respmodel20_fractrain0_20181021T093241.mat';
%fname = 'CORE_fittedparameters_percmodel12_bayesopt_20181019T083824.mat'; % BAYESOPT
%fname= 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181023T212308.mat'; %alpha prior = 1
%fname= 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181023T202826.mat'; %alpha prior = 0.2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181024T222027.mat'; %fitted with bayesopt priors

% comparison of prior variances: bayesopt omegas
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181026T171952.mat'; %fitted with bayesopt priors, var025 
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181026T171959.mat'; %fitted with bayesopt priors, var05
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181026T171938.mat'; %fitted with bayesopt priors, var1
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181026T172007.mat'; %fitted with bayesopt priors, var2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181026T172024.mat'; %fitted with bayesopt priors, var4

% prior on expected uncertainty = -2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181028T082701.mat'; %fitted with bayesopt priors, var05
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181028T082725.mat'; %fitted with bayesopt priors, var1
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181028T082749.mat'; %fitted with bayesopt priors, var2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181028T082828.mat'; %fitted with bayesopt priors, var4
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181028T082859.mat'; %fitted with bayesopt priors, var8

% alpha prior = 0.01
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181101T211928.mat'; %fitted with bayesopt priors, var05
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181101T211935.mat'; %fitted with bayesopt priors, var1
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181101T211950.mat'; %fitted with bayesopt priors, var2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181101T211959.mat'; %fitted with bayesopt priors, var4
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181101T212006.mat'; %fitted with bayesopt priors, var8
% alpha prior = 1
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181102T192113.mat'; %fitted with bayesopt priors, var05
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181102T192126.mat'; %fitted with bayesopt priors, var1
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181102T192137.mat'; %fitted with bayesopt priors, var2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181102T192151.mat'; %fitted with bayesopt priors, var4
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181102T192201.mat'; %fitted with bayesopt priors, var8
% alpha prior = 0.5
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181104T172839.mat'; %fitted with bayesopt priors, var05
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181104T172830.mat'; %fitted with bayesopt priors, var1
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181104T172850.mat'; %fitted with bayesopt priors, var2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181104T172900.mat'; %fitted with bayesopt priors, var4
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181104T172909.mat'; %fitted with bayesopt priors, var8
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181106T212138.mat'; %fitted with bayesopt priors, var10
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181106T211643.mat'; %fitted with bayesopt priors, var100

% ommu2 = -2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181107T214827.mat'; % ommu3=-3
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181107T214552.mat'; % ommu3=-4
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181107T214842.mat'; % ommu3=-5
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181107T214441.mat'; % ommu3=-6
% ommu2 = -6
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181110T095244.mat'; % ommu3=-3
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181109T200448.mat'; % ommu3=-4
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181109T200514.mat'; % ommu3=-5
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181109T200546.mat'; % ommu3=-6

% alphas
fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181114T173639.mat'; % alpha 0.1
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181114T173746.mat'; % alpha 0.2
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181114T173907.mat'; % alpha 0.4
%fname = 'CORE_fittedparameters_percmodel12_respmodel2_fractrain0_20181114T173922.mat'; % alpha 0.8

%S.path.hgf = 'C:\Data\CORE\behaviour\hgf\sim';
%fname = 'CORE_sim_percmodel12_20181019T101036.mat'; % Al*2, om2+2, om3-2
%fname = 'CORE_sim_percmodel12_20181019T102209.mat'; % Al*2
%fname = 'CORE_sim_percmodel12_20181019T102418.mat'; % om2+2
%fname = 'CORE_sim_percmodel12_20181019T102607.mat'; % om3-2
%fname = 'CORE_sim_percmodel12_20181019T102839.mat'; % om2+2, om3-2
%fname = 'CORE_sim_percmodel12_20181019T103111.mat'; % Al*2, om2+2
%fname = 'CORE_sim_percmodel12_20181019T103323.mat'; % Al*2, om3-2

load(fullfile(S.path.hgf,fname));

% which stats to output for traj?
S.summary_stats = {'mean'};%{'mean','std','absmean','absstd'}; % for all traj

% which traj to outputs means for each condition?
%S.condmean = {'PL_muhat_1','PL_dau','PL_sahat_1','PL_muhat_2','PL_sahat_2','PL_muhat_3','PL_sahat_3'};
S.condmean = {'PL_dau','PL_da_1','PL_da_2','PL_epsi_1','PL_epsi_2','PL_epsi_3','PL_mu_1'};

% event numbers for each condition (1st = change, 2nd = no change)
S.cond.CP10_Sideaff_DC1 = [1 3]; %0.1 prob, 1 digit change, left hand
S.cond.CP10_Sideaff_DC3 = [2 4]; %0.1 prob, 3 digit change, left hand
S.cond.CP10_Sideunaff_DC1 = [5 7]; %0.1 prob, 1 digit change, right hand
S.cond.CP10_Sideunaff_DC3 = [6 8]; %0.1 prob, 3 digit change, right hand
S.cond.CP30_Sideaff_DC1 = [9 11]; %0.3 prob, 1 digit change, left hand
S.cond.CP30_Sideaff_DC3 = [10 12]; %0.3 prob, 3 digit change, left hand
S.cond.CP30_Sideunaff_DC1 = [13 15]; %0.3 prob, 1 digit change, right hand
S.cond.CP30_Sideunaff_DC3 = [14 16]; %0.3 prob, 3 digit change, right hand
S.cond.CP50_Sideaff_DC1 = [17 19]; %0.5 prob, 1 digit change, left hand
S.cond.CP50_Sideaff_DC3 = [18 20]; %0.5 prob, 3 digit change, left hand
S.cond.CP50_Sideunaff_DC1 = [21 23]; %0.5 prob, 1 digit change, right hand
S.cond.CP50_Sideunaff_DC3 = [22 24]; %0.5 prob, 3 digit change, right hand
S.cond.condmean = [1:24]; %0.5 prob, 3 digit change, right hand
S.cond.DC1 = [1:2:23]; %0.5 prob, 3 digit change, right hand
S.cond.DC3 = [2:2:24]; %0.5 prob, 3 digit change, right hand
S.cond.CP10 = [1:8]; %0.5 prob, 3 digit change, right hand
S.cond.CP30 = [9:16]; %0.5 prob, 3 digit change, right hand
S.cond.CP50 = [17:24]; %0.5 prob, 3 digit change, right hand
S.cond.sideaff = [1:4 9:12 17:20]; %0.5 prob, 3 digit change, right hand
S.cond.sideunaff = [5:8 13:16 21:24]; %0.5 prob, 3 digit change, right hand
% 
% S.cond.CP10_Sideaff_DC1_ch = [1]; %0.1 prob, 1 digit change, left hand
% S.cond.CP10_Sideaff_DC3_ch = [2]; %0.1 prob, 3 digit change, left hand
% S.cond.CP10_Sideunaff_DC1_ch = [5]; %0.1 prob, 1 digit change, right hand
% S.cond.CP10_Sideunaff_DC3_ch = [6]; %0.1 prob, 3 digit change, right hand
% S.cond.CP30_Sideaff_DC1_ch = [9]; %0.3 prob, 1 digit change, left hand
% S.cond.CP30_Sideaff_DC3_ch = [10]; %0.3 prob, 3 digit change, left hand
% S.cond.CP30_Sideunaff_DC1_ch = [13]; %0.3 prob, 1 digit change, right hand
% S.cond.CP30_Sideunaff_DC3_ch = [14]; %0.3 prob, 3 digit change, right hand
% S.cond.CP50_Sideaff_DC1_ch = [17]; %0.5 prob, 1 digit change, left hand
% S.cond.CP50_Sideaff_DC3_ch = [18]; %0.5 prob, 3 digit change, left hand
% S.cond.CP50_Sideunaff_DC1_ch = [21]; %0.5 prob, 1 digit change, right hand
% S.cond.CP50_Sideunaff_DC3_ch = [22]; %0.5 prob, 3 digit change, right hand
% 
% S.cond.CP10_Sideaff_DC1_noch = [3]; %0.1 prob, 1 digit change, left hand
% S.cond.CP10_Sideaff_DC3_noch = [4]; %0.1 prob, 3 digit change, left hand
% S.cond.CP10_Sideunaff_DC1_noch = [7]; %0.1 prob, 1 digit change, right hand
% S.cond.CP10_Sideunaff_DC3_noch = [8]; %0.1 prob, 3 digit change, right hand
% S.cond.CP30_Sideaff_DC1_noch = [11]; %0.3 prob, 1 digit change, left hand
% S.cond.CP30_Sideaff_DC3_noch = [12]; %0.3 prob, 3 digit change, left hand
% S.cond.CP30_Sideunaff_DC1_noch = [15]; %0.3 prob, 1 digit change, right hand
% S.cond.CP30_Sideunaff_DC3_noch = [16]; %0.3 prob, 3 digit change, right hand
% S.cond.CP50_Sideaff_DC1_noch = [19]; %0.5 prob, 1 digit change, left hand
% S.cond.CP50_Sideaff_DC3_noch = [20]; %0.5 prob, 3 digit change, left hand
% S.cond.CP50_Sideunaff_DC1_noch = [23]; %0.5 prob, 1 digit change, right hand
% S.cond.CP50_Sideunaff_DC3_noch = [24]; %0.5 prob, 3 digit change, right hand

% run stats
if ~exist('D_fit','var') && exist('D_sim','var')
    D_fit=D_sim;
    D_fit.HGF.fit = D_fit.HGF.sim;
end
[out.T,out.traj,out.param,out.rt] = CORE_extract_HGF_results(D_fit,S);
if length(D_fit)>1
    S.nperm=0;
    [out.stats] = CORE_HGF_groupstatistics(out.T,{out.traj},S);
    %[out.stats] = CORE_HGF_groupstatistics(out.T,{out.traj,S.condmean},S);
    %[out.stats] = CORE_HGF_groupstatistics(out.T,{},S);
end

% save
if 0
    save(fullfile(S.path.hgf,strrep(fname,'fittedparameters','groupstatistics')), 'out');
    sname=strrep(strrep(fname,'fittedparameters','statstable'),'.mat','.xlsx');
    writetable(out.T,fullfile(S.path.hgf,sname));
end

% plot group differences for selected variables
if 1
    close all
    vs={'like_al0_1','like_al0_2','like_al0_3','like_al0_4','PL_om_2','PL_om_3','PL_sa_2_mean','PL_ud_1_mean','PL_ud_2_mean','PL_dau_mean','PL_epsi_2_mean','PL_epsi_3_mean'};
    [grps,~,grpind] = unique(out.T.groups);
    for v=1:length(vs)
        figure
        scatter(grpind,out.T.(vs{v}))
        set(gca,'XTick',1:2)
        set(gca,'XTickLabel',grps)
        title(vs{v})
    end
end

% plot condition effects for selected variables: SIM ONLY
if 0
    close all
    vs=S.condmean;
    for v=1:length(vs)
        
        % get column indices
        colnames = out.T.Properties.VariableNames;
        vss{v} = colnames(~cellfun(@isempty,strfind(colnames,vs{v})));
        
        % get data
        dat = out.T(:,vss{v});
        xlab = categorical(dat.Properties.VariableNames);
        
        % plot
        figure
        bar(xlab,dat{1,:})
        title(vs{v})
    end
end
