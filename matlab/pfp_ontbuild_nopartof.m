function [ont]= pfp_ontbuild_nopartof(obo_file)
%
 %PFP_ONTBUILD Ontology build
% {{{
%
% [ont] = PFP_ONTBUILD_nopartof(obo_file);
%
%   only extract ontology from "is_a" relationship, instead of "is_a" and
%   "part_of"
%
% Input
% -----
%
% [char]
% obo_file: The OBO file name.
%   must be a GO file.
%
% Output (didn't change output)
% ------
% [struct]
% ont:      The ontology structure having the following fields:
%           [struct]
%           .term       A term structure array, each has two fields:
%
%             [char]
%             .id       The term ID.
%
%             [char]
%             .name     The name tag attached to each term.
%
%           [struct]
%           .alt_list   The alternative ID list.
%
%             [char]
%             .old      The old ID.
%
%             [char]
%             .new      The corresponding new ID.
%
%           [double and sparse]
%           .DAG        The adjacency matrix (for a directed acyclic graph)
%                       where DAG(i, j) = t indicates term i has relation type
%                       'rel_code{t}' with term j, typically,
%                       t = 1 ("is_a")
%                       t = 2 ("part_of")
%
%           [cell]
%           .rel_code   A relationship code array, typically, {'is_a',
%                       'part_of'}
%
%           [char]
%           .ont_type   The ontology name tag.
%                       One of {'DO', 'BPO', 'CCO', 'MFO', 'HPO'}
%
%           [char]
%           .date       The date when this 'ont' was built.
% }}}

 % check argument 'obo_file' {{{
  validateattributes(obo_file, {'char'}, {'nonempty'}, '', 'obo_file', 2);
  % check argument 'obo_file' }}}
  
  % check and read OBO file {{{
  fid = fopen(obo_file, 'r');
  if fid == -1
    error('pfp_ontbuild:FileErr', 'Cannot open the OBO file [%s].', obo_file);
  end
  obo = textscan(fid, '%s', 'WhiteSpace', '\n');
  obo = obo{1};
  fclose(fid);
  % check and read OBO file }}}
  ont_type='GO';
   % parse obo file {{{
  stanza_begin = find(cellfun(@length, regexp(obo, '^\[.+\]')));
  is_term      = strcmpi(obo(stanza_begin), '[Term]'); % locate the line: [Term]
  term_begin   = stanza_begin(is_term);
  stanza_end   = [stanza_begin(2 : end) - 1; numel(obo)];
  term_end     = stanza_end(is_term);

  tid             = zeros(numel(obo), 1);
  tid(term_begin) = 1 : numel(term_begin);
  tid(term_end)   = -(1 : numel(term_begin));
  tid             = cumsum(tid);
  tid             = max([0; tid(1 : end - 1)], tid);
  
  % hereafter, for any positive integer k, tid(i) = k indicates 
  % the i-th line belongs to the k-th Term stanza.

  % these hash keys must match with those in hashkeywords
  HK_ID     = 1;
  HK_NAME   = 2;
  HK_NAMESP = 3;
  HK_IS_A   = 4;
  HK_ALT_ID = 5;
  HK_IS_OBS = 6; % is_obsoleted
  HK_RELATI = 7; % relationship

  hk = hashkeywords;

  key = max(0, char(regexp(obo, '^\w{1,6}', 'match', 'once')) - '`');
  if size(key, 2) < 6
    % append zeros columns if the 'key' matrix has less than 6 columns
    key = [key, zeros(size(key, 1), 6 - size(key, 2))];
  end
  tags = full(hk(key * [27^5; 27^4; 27^3; 27^2; 27; 1] + 1));

  % keep only those values and remove matched tags
  obo = regexprep(obo, '^\w+:\s*', '');

  % extract lines of interest
  id   = obo(tid & (tags == HK_ID));
  name = obo(tid & (tags == HK_NAME));
  if strcmp(ont_type, 'GO')
    ns   = obo(tid & (tags == HK_NAMESP));
  end
  is_a_index = tid & (tags == HK_IS_A);
  % note: [is_a_list.l1] is a [is_a_list.l2]
  is_a_list.l1 = id(tid(is_a_index));
  is_a_list.l2 = regexprep(obo(is_a_index), '\s*!.*', '');

  alt_id_index = tid & (tags == HK_ALT_ID);
  % note: [alt_list.l1] is an alternative id of [alt_list.l2]
  alt_list.l1 = obo(alt_id_index);
  alt_list.l2 = id(tid(alt_id_index));

  % remove obseleted terms
  is_obs = tid(tid & (tags == HK_IS_OBS));
  id(is_obs)   = [];
  name(is_obs) = [];
  if strcmp(ont_type, 'GO')
    ns(is_obs)   = [];
  end

  % construct 'term'
    is_mfo   = strcmpi(ns, 'molecular_function');
    is_bpo   = strcmpi(ns, 'biological_process');
    is_cco   = strcmpi(ns, 'cellular_component');
    mfo_term = cell2struct([id(is_mfo), name(is_mfo)], {'id', 'name'}, 2);
    bpo_term = cell2struct([id(is_bpo), name(is_bpo)], {'id', 'name'}, 2);
    cco_term = cell2struct([id(is_cco), name(is_cco)], {'id', 'name'}, 2);
    ont.MFO  = construct_ont('MFO', mfo_term, alt_list, is_a_list);
    ont.BPO  = construct_ont('BPO', bpo_term, alt_list, is_a_list);
    ont.CCO  = construct_ont('CCO', cco_term, alt_list, is_a_list);
  % parse obo file }}}
return

% function: hashkeywords % {{{
function [hk] = hashkeywords
    powers = [27^5; 27^4; 27^3; 27^2; 27; 1];
    hk = sparse(27^6, 1);
    hk(max(0, 'id    '-'`') * powers + 1) = 1;
    hk(max(0, 'name  '-'`') * powers + 1) = 2;
    hk(max(0, 'namesp'-'`') * powers + 1) = 3;
    hk(max(0, 'is_a  '-'`') * powers + 1) = 4;
    hk(max(0, 'alt_id'-'`') * powers + 1) = 5;
    hk(max(0, 'is_obs'-'`') * powers + 1) = 6;
    hk(max(0, 'relati'-'`') * powers + 1) = 7; % relationship
return
% function: hashkeywords % }}}

% function: construct ont {{{
function ont = construct_ont(ont_type, term, alt_list, is_a_list, REL, rel_list)
    [~, order] = sort({term.id}); % sort by id
    ont.term = term(order);
    n = numel(term);

    % construct 'alt' list
    found = ismember(alt_list.l2, {ont.term.id});
    ont.alt_list.old = alt_list.l1(found);
    ont.alt_list.new = alt_list.l2(found);

    % construct 'DAG'
    ont.rel_code = {'is_a'}; type_cnt = numel(ont.rel_code);
    [found1, index1] = ismember(is_a_list.l1, {ont.term.id});
    [found2, index2] = ismember(is_a_list.l2, {ont.term.id});
    valid = found1 & found2;
    from = index1(valid);
    to   = index2(valid);
    val  = ones(sum(valid), 1);
    ont.DAG = sparse(from, to, val, n, n);

    % preparing output
    ont.ont_type = upper(ont_type);
    ont.date     = date;
return
% function: construct ont }}}
  
   % -------------
% Based on the function "pfp_ontbuild" by
% Yuxiang Jiang (yuxjiang@indiana.edu)
% Department of Computer Science
% Indiana University Bloomington
% Modified by Naihui Zhou (nzhou@iastate.edu)
% BCB, Iowa State University
% Last modified: 10/22/2015