clear all
if isunix
    filepath = '/scratch/cb802/Data';
    run('/scratch/cb802/Matlab_files/CRPS_digits/loadsubj.m');
else
    filepath = 'W:\Data';
    run('W:\Matlab_files\CRPS_digits\loadsubj.m');
end
ana_path1 = fullfile(filepath,'CRPS_Digit_Perception_exp1');
ana_path2 = fullfile(filepath,'CRPS_Digit_Perception');
raw_path = fullfile(filepath,'CRPS_raw');
cd(raw_path);
files = dir('*orig.set');

for f = 1:length(files)
    orig_file = files(f).name;
    [pth nme ext] = fileparts(orig_file);
    C = strsplit(nme,'_');
    fname = [C{1} '_cICA.set'];
    EEG = pop_loadset('filename',fname,'filepath',raw_path);
    load([C{1} '_trials.mat']);
    EEG = pop_subcomp( EEG, [], 0);
    EEG = pop_reref( EEG, []);
    %split into exp1 and exp2
    EEG1 = pop_select(EEG,'trial',1:trials(1));
    EEG2 = pop_select(EEG,'trial',trials(1)+1:trials(1)+trials(2));
    %split into left and right - exp1
    EEG=EEG1;
    selectfnum =1:5;
    part1analysis;
    EEG1l=EEG;
    EEG=EEG1;
    selectfnum =6:10;
    part1analysis;
    EEG1r=EEG;
    %split into left and right - exp2
    EEG=EEG2;
    selectfnum =1:5;
    part2analysis;
    EEG2l=EEG;
    EEG=EEG2;
    selectfnum =6:10;
    part2analysis;
    EEG2r=EEG;
    EEG=EEG1l;
    sname = [C{1} '_Exp1_left.set'];
    EEG = pop_saveset(EEG,'filename',sname,'filepath',raw_path);
    EEG=EEG1r;
    sname = [C{1} '_Exp1_right.set'];
    EEG = pop_saveset(EEG,'filename',sname,'filepath',raw_path);
    EEG=EEG2l;
    sname = [C{1} '_Exp2_left.set'];
    EEG = pop_saveset(EEG,'filename',sname,'filepath',raw_path);
    EEG=EEG2r;
    sname = [C{1} '_Exp2_right.set'];
    EEG = pop_saveset(EEG,'filename',sname,'filepath',raw_path);
end