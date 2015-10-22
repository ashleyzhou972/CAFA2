%first import ontology (archived, 07/01/2013);
ont=pfp_ontbuild('GO','/home/nzhou/Documents/CAFA2/gene_ontology_edit.obo');
%ont.CCO;
load('CCO.mat','CCO');
%then import a CAFA submission file;
submission1=cafa_import('/home/nzhou/Documents/CAFA2/CAFA2_submissions/101/GO2Proto_1_7227',CCO);
%have to be a specific ontology, e.g. BPO, instead of geneontology;

%next pfp_seqcm;
config.bm_all   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/xxo_all_typex.txt', 'char');
config.bm_mfo   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/mfo_all_typex.txt', 'char');
config.bm_cco   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/cco_all_typex.txt', 'char');
config.bm_bpo   = pfp_loaditem('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/bpo_all_typex.txt', 'char');
config.mfoa     = load('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/mfoa.mat', 'oa');
config.bpoa     = load('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/bpoa.mat', 'oa');
config.ccoa     = load('/home/nzhou/Documents/CAFA2/CAFA matlab/Yuxiang benchmarks/ccoa.mat', 'oa');
config.pred = submission1;
% oafield = sprintf('%sa', ont.CCO);
config.ccoa=config.ccoa.oa;
benchmark=pfp_seqcm(config.bm_cco,config.pred,config.ccoa,'toi','noroot');
%ontology mismatch
if numel(config.pred.ontology.term) ~= numel(config.ccoa.ontology.term) || ~all(strcmp({config.pred.ontology.term.id}, {config.ccoa.ontology.term.id}))
    error('pfp_seqcm:InputErr', 'Ontology mismatch.');
end
%solved


%cafa_driver_preeval();
cm_seq = pfp_seqcm(config.bm_cco,config.pred,config.ccoa,'toi','noroot');
cm_seq_ia = pfp_seqcm(config.bm, config.pred, config.oa, 'toi', 'noroot', 'w', 'eia');

% compute and save metrics of interest
pr = pfp_convcmstruct(cm_seq, 'pr', 'beta', 1);

