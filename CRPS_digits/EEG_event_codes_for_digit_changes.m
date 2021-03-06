clear all
filepath = 'C:\Data\CRPS-DP\CRPS_Digit_Perception_exp1\correcttrials';
run('M:\Matlab\Matlab_files\CRPS_digits\loadsubj.m')
cd(filepath)
files = dir('*t.set');

lastfnum=[];
allchgdata = cell(length(files),1);
for f = 1:length(files)
    if any(strfind(files(f).name,'flip')) || any(strfind(files(f).name,'ICA')) || any(strfind(files(f).name,'orig'))
        continue;
    end;
    EEG = pop_loadset(files(f).name,filepath);
    chgdata=[];
    chgdata_epoch=[];
    for e = 1:length(EEG.urevent)
        if strcmp(EEG.urevent(e).type,'STIM')
            thisfnum = EEG.urevent(e).codes{strcmp('FNUM',EEG.urevent(e).codes(:,1)),2};
            if ~isempty(lastfnum) 
                chg = min(abs(thisfnum-lastfnum),4);
            else
                chg = 4;
            end
            if sum(strcmp('CNUM',EEG.urevent(e).codes(:,1))) == 0
                EEG.urevent(e).codes = cat(1,EEG.urevent(e).codes,{'CNUM' chg});
            else
                EEG.urevent(e).codes{strcmp('CNUM',EEG.urevent(e).codes(:,1)),2} = chg;
            end
            chgdata = cat(1,chgdata,[thisfnum chg]);
            lastfnum = thisfnum;
        end
    end
    allchgdata{f,1} = chgdata;
    chgdata_epoch=nan(length(EEG.event),1);
    for e = 1:length(EEG.event)
        if strcmp(EEG.event(e).type,'STIM')
            %EEG.event(e).codes = EEG.urevent(EEG.event(e).urevent).codes;
            if sum(strcmp('CNUM',EEG.event(e).codes(:,1))) == 0
                EEG.event(e).codes = cat(1,EEG.event(e).codes,{'CNUM' EEG.urevent(EEG.event(e).urevent).codes{strcmp('CNUM',EEG.urevent(EEG.event(e).urevent).codes(:,1)),2}});
            else
                EEG.event(e).codes{strcmp('CNUM',EEG.event(e).codes(:,1)),2} = EEG.urevent(EEG.event(e).urevent).codes{strcmp('CNUM',EEG.urevent(EEG.event(e).urevent).codes(:,1)),2};
            end
        chgdata_epoch(e,1)=EEG.event(e).codes{strcmp('CNUM',EEG.event(e).codes(:,1)),2};
        end
    end
    for e = 1:length(EEG.epoch)
        if sum(strcmp(EEG.epoch(e).eventtype(1,:),'STIM'))>0
            ind = find(strcmp(EEG.epoch(e).eventtype(1,:),'STIM'));
            %EEG.event(e).codes = EEG.urevent(EEG.event(e).urevent).codes;
            findcnum=[];
            if iscell(EEG.epoch(e).eventinit_index)
                for inds = 1:length(ind)
                    findcnum = strcmp('CNUM',EEG.epoch(e).eventcodes{1,ind(inds)}(:,1));
                    if sum(findcnum) > 0
                        EEG.epoch(e).eventcodes{1,ind(inds)}(find(findcnum),:) = [];
                    end
                    EEG.epoch(e).eventcodes{1,ind(inds)} = cat(1,EEG.epoch(e).eventcodes{1,ind(inds)},{'CNUM' EEG.urevent(EEG.epoch(e).eventinit_index{1,ind(inds)}).codes{strcmp('CNUM',EEG.urevent(EEG.epoch(e).eventinit_index{1,ind(inds)}).codes(:,1)),2}});
                end
            else 
                findcnum = strcmp('CNUM',EEG.epoch(e).eventcodes(:,ind));
                if sum(findcnum) > 0
                    EEG.epoch(e).eventcodes(find(findcnum),:) = [];
                end
                EEG.epoch(e).eventcodes = cat(1,EEG.epoch(e).eventcodes,{'CNUM' EEG.urevent(EEG.epoch(e).eventinit_index).codes{strcmp('CNUM',EEG.urevent(EEG.epoch(e).eventinit_index).codes(:,1)),2}});
               
            end
        end
    end
    EEG = eeg_checkset(EEG);
    EEG = pop_saveset(EEG,'filename',EEG.filename,'filepath',filepath); 
    allchgdata{f,2} = chgdata_epoch;
end

typecount = [];
typecount_epoch = [];
for f = 1:length(files)
    chgdata = allchgdata{f,1};
    chgdata_epoch = allchgdata{f,2};
    types = unique(chgdata(:,2));
    for t = 1:length(types)
        typecount(t,f) = sum(chgdata(:,2)==types(t));
        typecount_epoch(t,f) = sum(chgdata_epoch(:,1)==types(t));
    end
end

save allchgdata allchgdata typecount typecount_epoch
