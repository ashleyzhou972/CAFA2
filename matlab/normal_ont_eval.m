function [fmax,smin] = normal_ont_eval(gofile, prediction_file)
%output fmax for evaluating a CAFA2 submission using a normal ontology
%structure (with "isa" and "partof" edges)
%   [input] gofile
%           prediction_file: output of cafa_import
%   [output] fmax value and smin value
ont=pfp_ontbuild('GO',gofile);
%benchmarks
config.bm_mfo   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/mfo_all_typex.txt', 'char');
config.bm_cco   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/cco_all_typex.txt', 'char');
config.bm_bpo   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/bpo_all_typex.txt', 'char');
% OA build
config.mfoa     = pfp_oabuild(ont.MFO,'/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/propagated_MFO.txt');
config.bpoa     = pfp_oabuild(ont.BPO,'/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/propagated_BPO.txt');
config.ccoa     = pfp_oabuild(ont.CCO,'/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/propagated_CCO.txt');

%construc confusion matrix
cm1.CCO=pfp_seqcm(config.bm_cco,prediction_file.CCO,config.ccoa,'toi','noroot');
cm1.MFO=pfp_seqcm(config.bm_mfo,prediction_file.MFO,config.mfoa,'toi','noroot');
cm1.BPO=pfp_seqcm(config.bm_bpo,prediction_file.BPO,config.bpoa,'toi','noroot');

%precision and recall
pr.CCO = pfp_convcmstruct(cm1.CCO, 'pr','beta',1);
pr.MFO = pfp_convcmstruct(cm1.MFO, 'pr','beta',1);
pr.BPO = pfp_convcmstruct(cm1.BPO, 'pr','beta',1);
%pr curve
prcurve.CCO = cafa_eval_seq_curve('temp4', config.bm_cco, pr.CCO, 'full');
prcurve.MFO = cafa_eval_seq_curve('temp5', config.bm_mfo, pr.MFO, 'full');
prcurve.BPO = cafa_eval_seq_curve('temp6', config.bm_bpo, pr.BPO, 'full');
%fmax
[fmax.CCO.fmax, fmax.CCO.point, fmax.CCO.tau] = pfp_fmaxc(prcurve.CCO.curve, prcurve.CCO.tau, 1);
[fmax.MFO.fmax, fmax.MFO.point, fmax.MFO.tau] = pfp_fmaxc(prcurve.MFO.curve, prcurve.MFO.tau, 1);
[fmax.BPO.fmax, fmax.BPO.point, fmax.BPO.tau] = pfp_fmaxc(prcurve.BPO.curve, prcurve.BPO.tau, 1);
%rm
rm.CCO = pfp_convcmstruct(cm1.CCO, 'rm','beta',1);
rm.BPO = pfp_convcmstruct(cm1.BPO, 'rm','beta',1);
rm.MFO = pfp_convcmstruct(cm1.MFO, 'rm','beta',1);
%rmcurve
rmcurve.CCO = cafa_eval_seq_curve('temp1', config.bm_cco, rm.CCO, 'full');
rmcurve.MFO = cafa_eval_seq_curve('temp2', config.bm_mfo, rm.MFO, 'full');
rmcurve.BPO = cafa_eval_seq_curve('temp3', config.bm_bpo, rm.BPO, 'full');
%smin (not bootstrapped)
[smin.CCO.smin, smin.CCO.point, smin.CCO.tau] = pfp_sminc(rmcurve.CCO.curve, rmcurve.CCO.tau);
[smin.BPO.smin, smin.BPO.point, smin.BPO.tau] = pfp_sminc(rmcurve.BPO.curve, rmcurve.BPO.tau);
[smin.MFO.smin, smin.MFO.point, smin.MFO.tau] = pfp_sminc(rmcurve.MFO.curve, rmcurve.MFO.tau);
return

