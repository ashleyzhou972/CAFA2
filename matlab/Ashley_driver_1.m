gofile='/home/nzhou/Documents/CAFA2/go.obo';

%dependencies:
% Ashley_import.m
% normal_ont_eval.m
% nopartof_ont_eval.m


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
subid=[117,85,129,132,94,83,119]; %could not find team ID for "Jones-UCL";
% excluded team 75 and team 79 becasue their files are not named correctly;
submission_dir='/home/nzhou/Documents/CAFA2/CAFA2_submissions/';
filename = cell(1,7);
pred = cell(1,7);
for i = 1:7
    pred{i} = Ashley_import(subid(i));
    subdir = strcat(submission_dir,num2str(subid(i)));
    filename{i} = strcat(subdir,'/unzipped/merge.tab');
end
system('cd /home/nzhou/Documents/CAFA2/CAFA2_submissions/; sh /home/nzhou/Documents/CAFA2/CAFA2_submissions/run_merge.sh');

fmax_normal=cell(1,7);
smin_normal=cell(1,7);
fmax_nopartof=cell(1,7);
smin_nopartof=cell(1,7);
ont=pfp_ontbuild('GO',gofile);
ont0=pfp_ontbuild_nopartof(gofile);
submission1=cell(1,7);     %stores normal prediction files
submission2 = cell(1,7);   %stores nopartof prediction files
for k=2:7
    tic;
    mergefile = filename{k};
    submission1{k}.CCO=cafa_import(mergefile,ont.CCO);
    submission1{k}.MFO=cafa_import(mergefile,ont.MFO);
    submission1{k}.BPO=cafa_import(mergefile,ont.BPO);
    submission2{k}.CCO=cafa_import(mergefile,ont0.CCO);
    submission2{k}.MFO=cafa_import(mergefile,ont0.MFO);
    submission2{k}.BPO=cafa_import(mergefile,ont0.BPO);
    toc;
end;

pfp_savevar('submission_normal',submission1);
pfp_savevar('submission_nopartof',submission2);
for l=2:7
    tic;
    [fmax_normal{l},smin_normal{l}]=normal_ont_eval(gofile,submission1{l});
    [fmax_nopartof{l},smin_nopartof{l}]=nopartof_ont_eval(gofile,submission2{l});
    toc;
end;
pfp_savevar('fmax_normal',fmax_normal);
pfp_savevar('smin_normal',smin_normal);
pfp_savevar('fmax_nopartof',fmax_nopartof);
pfp_savevar('smin_nopartof',smin_nopartof);




