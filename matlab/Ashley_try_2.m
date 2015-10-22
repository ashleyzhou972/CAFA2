% CAFA evaluation by Ashley

% Original evaluation:
% load a newer version of GO
ont=pfp_ontbuild('GO','/home/nzhou/Documents/CAFA2/go.obo');
% load benchmarks
config.bm_mfo   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/mfo_all_typex.txt', 'char');
config.bm_cco   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/cco_all_typex.txt', 'char');
config.bm_bpo   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/bpo_all_typex.txt', 'char');
% OA build
config.mfoa     = pfp_oabuild(ont.MFO,'/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/propagated_MFO.txt');
config.bpoa     = pfp_oabuild(ont.BPO,'/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/propagated_BPO.txt');
config.ccoa     = pfp_oabuild(ont.CCO,'/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/propagated_CCO.txt');
% import a prediction result
submission1.CCO=cafa_import('/home/nzhou/Documents/CAFA2/CAFA2_submissions/101/GO2Proto_1_7227',ont.CCO);
submission1.MFO=cafa_import('/home/nzhou/Documents/CAFA2/CAFA2_submissions/101/GO2Proto_1_7227',ont.MFO);
submission1.BPO=cafa_import('/home/nzhou/Documents/CAFA2/CAFA2_submissions/101/GO2Proto_1_7227',ont.BPO);
%have to be a specific ontology, e.g. BPO, instead of geneontology;

% propogation of submission1 has been done

% construct confusion matrix
cm1.CCO=pfp_seqcm(config.bm_cco,submission1.CCO,config.ccoa,'toi','noroot');
cm1.MFO=pfp_seqcm(config.bm_mfo,submission1.MFO,config.mfoa,'toi','noroot');
cm1.BPO=pfp_seqcm(config.bm_bpo,submission1.BPO,config.bpoa,'toi','noroot');
cm_seq_ia.CCO = pfp_seqcm(config.bm_cco, submission1.CCO, config.ccoa, 'toi', 'noroot', 'w', 'eia');
% bmfield = sprintf('bm_%s', ont);
% oafield = sprintf('%sa', ont);
% config.bm    = config.(bmfield);
% config.oa    = config.(oafield).oa;
cm1=pfp_seqcm(config.bm,submission1,config.oa,'toi','noroot');
pr = pfp_convcmstruct(cm1, 'pr','beta',1);
wpr = pfp_convcmstruct(cm_seq_ia.CCO, 'wpr', 'beta',1);
rm = pfp_convcmstruct(cm_seq_ia.CCO, 'rm', 'order', 2);

prcurve = cafa_eval_seq_curve('temp1', config.bm_mfo, pr, 'full');
[fmax.fmax, fmax.point, fmax.tau] = pfp_fmaxc(prcurve.curve, prcurve.tau, 1);

% evaluation with only "is_a" ontology:
ont_np=pfp_ontbuild_nopartof('/home/nzhou/Documents/CAFA2/go.obo');

