function [] = Ashley_import( teamID)
%Ashley_import imports submission files into a prediction structure with
%three substructures: BPO, MFO and CCO
%import only model1 ;
%   [input] teamID;ontology
%   [output] pred structure
submission_dir='/home/nzhou/Documents/CAFA2/CAFA2_submissions/';
subdir = strcat(submission_dir,num2str(teamID));
files = dir(subdir);   
mkdir(subdir,'unzipped');
outputdir = strcat(subdir,'/','unzipped');

%unzip all model 1 files and put them into another folder
for i=1 : numel(files)
    pos=regexp(files(i).name,'_');
    if (~isempty(pos) && files(i).name(pos(1)+1)=='1') %all model 1 files
        if (isempty(strfind(files(i).name,'archaea')) && isempty(strfind(files(i).name,'archea')) ...
                && isempty(strfind(files(i).name,'bacteria')) && isempty(strfind(files(i).name,'hpo')) ...
                && isempty(strfind(files(i).name,'other')) && isempty(strfind(files(i).name,'EFI')))
            %only eukaryotes;no HPO; no other;no EFI
            filename = strcat(subdir,'/',files(i).name); 
            l=length(filename);
            if (strcmp(filename(l-2:l),'txt'))
                copyfile(filename,outputdir);
            elseif (strcmp(filename(l-2:l),'zip'))
                unzip(filename,outputdir);
            elseif (strcmp(filename(l-2:l),'.gz'))
                gunzip(filename,outputdir);
            else
                untar(filename,outputdir);
            end;
        end;
    end;
end;
%all model 1 files are unzipped
%check if there still are zipped files in the 'unzip' folder
unzipdfiles = dir(strcat(subdir,'/unzipped/'));
for i=1:numel(unzipdfiles)
    filename = strcat(subdir,'/unzipped/',unzipdfiles(i).name);
    ll=length(filename);
    if (~(strcmp(filename,'.') || ~strcmp(filename,'..')))
        if (~strcmp(filename(ll-2:ll),'txt'))
           if (strcmp(filename(ll-2:ll),'zip'))
                unzip(filename,outputdir);
            elseif (strcmp(filename(ll-2:ll),'.gz'))
                gunzip(filename,outputdir);
            else
                untar(filename,outputdir);
            end; 
        end;
    end;
end;
%concatenate them into one file in command line instead of matlab
%each '/unzipped' folder should have a single file called merge.tab;
return

