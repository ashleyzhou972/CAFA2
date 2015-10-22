function [ pred ] = Ashley_import( teamID )
%Ashley_import imports submission files into a prediction structure with
%three substructures: BPO, MFO and CCO
%import only model1 ;
%   [input] teamID
%   [output] pred structure
submission_dir='/home/nzhou/Documents/CAFA2/CAFA2_submissions/';
subdir = strcat(submission_dir,num2str(teamID));
files = dir(subdir);
model1files=struct([]);
for i=1 : numel(files)
    pos=regexp(files(i).name,'_');
    if (~isempty(pos) && files(i).name(pos(1)+1)=='1')
        model1files=[model1files,files(i)];
    end;
end;
return

