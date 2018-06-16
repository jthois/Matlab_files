function y = logrt_softmax_binary_sim(r, infStates, pvec)
% Calculates the log-probability of log-reaction times y (in units of log-ms) according to the
% linear log-RT model developed with Louise Marshall and Sven Bestmann
% http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002575
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2014-2016 Christoph Mathys, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% CAB: Number of levels
try
    l = r.c_prc.(r.c_obs.model).n_priorlevels;
catch
    l=1;
end

% Initialize returned log-probabilities, predictions,
% and residuals as NaNs so that NaN is returned for all
% irregualar trials
n = size(r.traj.(r.c_obs.model).(r.c_obs.rep),1);
y = nan(n,1);

% Create param struct
nme=r.c_obs.pnames;
nme_gen=r.c_obs.pnames_gen;
idx=r.c_obs.priormusi;

% Transform parameters to their native space
%pvec = logrt_softmax_binary_transp(r, pvec);

% Initialize random number generator
rng('shuffle');

%% SOFTMAX
if strcmp(r.c_obs.response.model, 'RT-soft') || strcmp(r.c_obs.response.model,'soft')
    
    % Create param struct
    type='soft';
    for pn=1:length(nme)
        if strcmp(nme{pn,1}(1:length(type)),type)
            eval([nme_gen{pn} ' = pvec(idx{pn})'';']);
        end
    end
    
%     % Predictions or posteriors?
%     pop = 1; % Default: predictions
%     if r.c_obs.predorpost == 2
%         pop = 3; % Alternative: posteriors
%     end
% 
%     % Softmax parameter
%     be = p(8);

    % Softmax: Weed irregular trials out from inferred states, responses, and inputs
    x = r.traj.(r.c_obs.model).(r.c_obs.rep)(:,1);

    % Calculate log-probabilities for non-irregular trials
    % If input matrix has only one column, assume the weight (reward value)
    % of both options is equal to 1
    %if size(x,2) == 1
        if ~any(x<0) && ~any(x>1)
            % Apply the logistic sigmoid to the inferred states
            prob = tapas_sgm(be.*(2.*x-1),1);
        else
            error('tapas:hgf:SoftMaxBinary:InfStatesIncompatible', 'infStates incompatible with tapas_softmax_binary observation model.')
        end
    %end
    % If input matrix has three columns, the second contains the weights of
    % outcome 0 and the third contains the weights of outcome 1
%     if size(x,2) == 2 
%         % Apply the logistic sigmoid to the inferred states
%         prob = tapas_sgm(be.*(x(:,1)-x(:,2)),1);
%     end
    
    % Simulate
    y(:,1) = binornd(1, prob);
end
if strcmp(r.c_obs.response.model,'RT-soft') || strcmp(r.c_obs.response.model,'RT')

    %% RT
    % Create param struct
    type='rt';
    for pn=1:length(nme)
        if strcmp(nme{pn,1}(1:length(type)),type)
            eval([nme_gen{pn} ' = pvec(idx{pn})'';']);
        end
    end

    % Transform parameters to their native space
%     be0  = p(1);
%     be1  = p(2);
%     be2  = p(3);
%     be3  = p(4);
%     be4  = p(5);
%     be5  = p(6);
%     ze   = p(7);

    u = r.u(:,1);

    % logRT: Extract trajectories of interest from infStates
    mu1hat = r.traj.(r.c_obs.model).muhat(:,1);
    sa1hat = r.traj.(r.c_obs.model).sahat(:,1);
    da1 = r.traj.(r.c_obs.model).da(:,1);
    da2 = r.traj.(r.c_obs.model).da(:,2);
    ep2 = r.traj.(r.c_obs.model).epsi(:,2);
    ep3 = r.traj.(r.c_obs.model).epsi(:,3);
    if l>1
        mu2    = r.traj.(r.c_obs.model).(mu)(:,2);
        sa2    = r.traj.(r.c_obs.model).(sa)(:,2);
    end
    if l>2
        mu3    = r.traj.(r.c_obs.model).(mu)(:,3);
    end
    
    % prediction error
    % ~~~~~~~~
    da1reg = abs(da1);
    da1reg(r.irr) = [];
    ep2reg = abs(ep2);
    ep2reg(r.irr) = [];
    da2reg = da2;
    da2reg(r.irr) = [];
    ep3reg = ep3;
    ep3reg(r.irr) = [];

    % Surprise: informational
    % ~~~~~~~~
    m1hreg = mu1hat;
    m1hreg(r.irr) = [];
    poo = m1hreg.^u.*(1-m1hreg).^(1-u); % probability of observed outcome
    surp = -log2(poo);

    % Bernoulli variance (aka irreducible uncertainty, risk) 
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    bernv = sa1hat;
    bernv(r.irr) = [];

    if l>1 % CAB
        % Inferential variance (aka informational or estimation uncertainty, ambiguity)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %inferv = tapas_sgm(mu2, 1).*(1 -tapas_sgm(mu2, 1)).*sa2; % transform down to 1st level
        %sigmoid_mu2 = 1/(1+exp(-mu2)); % transform down to 1st level
        %inferv = sigmoid_mu2.*(1 -sigmoid_mu2).*sa2; 
        inferv = sa2; 
        inferv(r.irr) = [];
    end

    if l>2 % CAB
        % Phasic volatility (aka environmental or unexpected uncertainty)
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %pv = sigmoid_mu2.*(1-sigmoid_mu2).*exp(mu3); % transform down to 1st level
        pv = exp(mu3); % transform down to 1st level
        pv(r.irr) = [];
    end

    % Calculate predicted log-reaction time
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if l>2
        logrt = be0 +be1.*surp +be2.*bernv +be3.*inferv +be4.*pv +be5.*da1reg +be6.*ep2reg +be7.*da2reg +be8.*ep3reg;
    elseif l>1
        logrt = be0 +be1.*surp +be2.*bernv +be3.*inferv +be5.*da1reg +be6.*ep2reg;
    else
        logrt = be0 +be1.*surp +be2.*bernv +be5.*da1reg +be6.*ep2reg;
    end
    
    % Simulate
    y(:,end) = logrt +sqrt(ze)*randn(n, 1); % response time plus Gaussian noise
end


return;
