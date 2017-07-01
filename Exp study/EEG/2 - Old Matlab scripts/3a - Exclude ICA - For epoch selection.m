clear all;

% type in subject numbers

subjects = {'H1', 'H2', 'H3', 'H4', 'H5', 'H6', 'H7', 'H8', 'H9', 'H10', 'H11', 'H12', 'H13' 'H14', 'H15', 'H16', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'OA1', 'OA2', 'OA4', 'OA5', 'OA6', 'OA7', 'OA8', 'OA9', 'OA10', 'OA11', 'OA12', 'OA13','OA14', 'OA15', 'OA16', 'OA17'};

for x=5

subject = subjects(x);
subject = char(subject);



    load ([subject '_data_epochs_500Hz.mat']);

    load (['b' subject]);

    excludes = {
        '[1,2,3,4,8,9,10;]' %H1
        '[1,2,3,7,11,12,15,17,18,20,25,27,28,30;]' % poss 24
        '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,23,24,25,27,28,29,30;]'
        '[1,2,3,5,8,12,16,20,23,24,25,26,27,29,30;]'
        '[1,2,3,4,5,6,7,12,18,19,27,29;]'
        '[1,5,15,19,22,29;]'
        '[1,2,4,7,9,18,19,21,23,29,30;]'
        '[1,2,3,4,5,6,10,20,21,26,28;]'
        '[1,2,3,4,7,8,11,13,14,16,18,20,27,28,29;]'
        '[1,2,3,4,5,6,9,16,18,19,24,27,28,30;]'
        '[1,2,3,4,5,6,7,8,9,10,11,13,14,16,20,22,27,29;]'
        '[1,4,6,7,8,13,19,21,23,24,27,28,29;]'
        '[1,2,3,4,8,9,10,13,19,20,21,22,25,26,29;]'
        '[1,2,3,4,7,9,17,18,19,23,24,26,28;]'
        '[1,6,10,13,14,22,26,27,28,29;]'
        '[1,2,25,26;]' %H16
        '[1,2,3,4,5,6,7,8,9,11,12,14,15,16,20,21,22,23,25,26,27,28,29;]' %F1
        '[1,2,3,5,10,12,16,20,21,22,27,29,30;]'
        '[1,2,7,10,11,13,19,20,21,22,24,27,29,30;]'
        '[1,2,3,4,6,8,10,11,18,29,30;]'
        '[1,2,3,5,7,8,9,14,15,20,21,24,28,29,30;]'
        '[1,2,4,5,6,11,24,29;]'
        '[1,2,3,4,5,8,11,18,19;]'
        '[1,5,7,10,15,17,21,22,27,28,30;]'
        '[1,2,3,4,5,8,10,15,19,27,30;]'
        '[1,2,3,4,7,8,16,17,24,26;]'
        '[1,2,4,12,13,17,19,22,25,26,27,28,29;]'
        '[1,3,4,5,8,27,30;]'
        '[1,2,14,18,27,29,30;]'
        '[1,2,4,5,6,7,8,9,10,11,12,13,16,17,18,19,21,23,25,27,30;]'
        '[1,2,3,4,5,6,7,10,11,13,15,16,17,21,22,26,27,29,30;]'
        '[1,2,11,12,16,21,22,24,25,26,28,29,30;]' %F16
        '[1,2,19,26,28,29;]' %OA1
        '[1,2,3,4,6,7,8,9,11,16,17,20,21,22,23,30;]'
        '[1,2,3,4,5,7,9,12,15,21,23,28,29,30;]'
        '[1,2,3,4,5,6,7,8,12,13,17,24,25,26,29;]'
        '[1,2,3,8,12,14,16,20,21,25,26,27,28,29,30;]'
        '[1,2,5,10,13,15,16,20,24,26,27,30;]'
        '[1,2,3,4,5,7,8,17,18,20,21,30;]'
        '[1,2,3,4,5,8,12,14,15,16,18,24,25,28,29,30;]'
        '[1,2,3,6,9,11,12,13,18,20,22,24,28,29,30;]'
        '[1,2,12,15,18,20,24,25,26,27,29,30;]'
        '[1,2,3,4,14,19,22,23,24,27,29,30;]'
        '[1,2,4,7,9,15,16,18,20,21,24,26,28,30;]'
        '[1,2,4,6,9,12,15,21,22,23,24,25,27,28,30;]'
        '[1,2,3,4,5,6,11,12,17,21,30;]'
        '[1,2,3,4,5,6,7,8,10,12,13,15,16,18,19,21,22,29;]'
        '[1,2,3,5,6,10,11,12,13,14,15,21,23,24,25,27,28;]' %OA17
};

%excludes = {'1 2 3' %H1
%    '1 2 3 11 12'
%    '1 2'
%    '1 2 3'
%    '1 3 4 5'
%    '1 2 5 8 15 19'
%    '1 2 7'
%    '1 2 3'
%    '1 2 3 4'
%    '1 2 3 4 5 9 24'
%    '1 2 3 4 11 14'
%    '1 2 8'
%    '1 2 3 4'
%    '1 2 7'
%    '1'
%    '1 2'
%    '1 2 3 23 26' %F1
%    '2'
%    '1 2 3 7'
%    '1 2 3'
%    '1 2'
%    '1 5'
%    '1 2'
%    '1 2'
%    '1 3 4 15'
%    '2 8'
%    '1 2'
%    '1'
%    '1 2'
%    '1 2 3 7'
%    '1 2 3'
%    '1'
%    '1 2' % OA1
%    '1 2 4 7'
%    '1 2 3 4 5 7 9'
%    '1 3 5'
%    '1 2 3'
%    '1'
%    '1 2 3 4 5'
%    '1 2 3'
%    '1 2'
%    '1 2 3'
%    '1 2 3'
%    '1 2'
%    '1 2 3 4 6 24'
%    '1 5 6 17'
%    '1 2 3 4 10 17'
%    '1 2 3 10 21'
%};


exclude=excludes(x);
exclude=[exclude{:}];

exclude=str2num(exclude);

include = [1:30];
include(exclude) = [];


act = b * total_data;
ib = pinv(b);

iact= ib(:, include) * act(include,:);  

if strcmp(subject, 'H8')
     iact(14,:) = mean(iact([15 4 39 48 49 50 35 37],:));
     iact(20,:) = mean(iact([15 21 51 54 49 50 55 58],:));
     iact(51,:) = mean(iact([20 16 50 55 15 21 8 22],:));
end


load ([subject '_data_matrix_dim']);

Nelectrodes = x(1);
Nsamples = x(2);
Nevents = x(3);

total_data_ICA=reshape(iact, Nelectrodes, Nsamples, Nevents); % re-froms the epochs

eval(['save ' subject '_total_data_ica.mat'  ' total_data_ICA']);


clear exclude include total_data total_data_ICA x

end