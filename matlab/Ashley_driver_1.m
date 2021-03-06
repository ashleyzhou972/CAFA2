gofile='/home/nzhou/Documents/CAFA2/go.obo';

%calculate number of edges in both ontologies(normal and nopartof)
%percent = card(part_of)/(card(part_of)+card(is_a))
ont=pfp_ontbuild('GO',gofile);
ont0=pfp_ontbuild_nopartof(gofile);
countMatrix=cell2mat({nnz(ont.BPO.DAG),nnz(ont.MFO.DAG),nnz(ont.CCO.DAG);nnz(ont0.BPO.DAG),nnz(ont0.MFO.DAG),nnz(ont0.CCO.DAG)});
percent = [0,0,0];
percent(1) = (countMatrix(1,1)-countMatrix(2,1))/countMatrix(1,1);
percent(2) = (countMatrix(1,2)-countMatrix(2,2))/countMatrix(1,2);
percent(3) = (countMatrix(1,3)-countMatrix(2,3))/countMatrix(1,3); 


%temp assigning submission file
submit1='/home/nzhou/Documents/CAFA2/CAFA2_submissions/101/GO2Proto_1_7227';
submit2='/home/nzhou/Documents/CAFA2/CAFA2_submissions/79/M3SP.79.orengo_funfhmmer_3_284812_0.txt';

%calculate fmax and smin for a single submission
tic;
[ans1,ans2]=normal_ont_eval(gofile,submit1);
[ans3,ans4]=nopartof_ont_eval(gofile,submit1);
toc;

tic;
[ans5,ans6]=normal_ont_eval(gofile,submit2);
[ans7,ans8]=nopartof_ont_eval(gofile,submit2);
toc;

%calculate fmax and smin for top10 submissions per ontology
%BPO
subid=[117,85,129,79,132,94,83,75,119]; %could not find team ID for "Jones-UCL";
subdir = cell(numel(subid),1);
submission_dir='/home/nzhou/Documents/CAFA2/CAFA2_submissions/';
for i = 1:9
    subdir{i}=strcat(submission_dir,num2str(subid(i)));
    fmax_BPO.norm = normal_ont_eval(gofile,subfiles(i));
    fmax_BPO.nopartof = 
end
