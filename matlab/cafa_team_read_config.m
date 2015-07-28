function [iid, eid, tname, ttype, dname, pname, kw, chex] = cafa_team_read_config(team_file)
%CAFA_TEAM_READ_CONFIG CAFA team read config
% {{{
%
% [iid, eid, tname, ttype, dname, pname, kw, chex] = CAFA_TEAM_READ_CONFIG(team_file);
%
%   Reads and parses team information file.
%
% Input
% -----
% [char]
% team_file:  The team information file.
%
%             Note: team information/configuration file consists of 8 columns:
%             1. Method ID (internal ID, starts with 'M' for participating
%                methods and 'B' for baseline methods)
%             2. Method ID (external ID, each method should be aware of its own
%                external ID)
%             3. Team name
%             4. Type of the method
%             5. Display name of the method
%             6. PI's name of the method/team
%             7. Keyword list of the method
%             8. Assigned color of the method/PI
%
% Output
% ------
% [cell]
% iid:    The internal model id.
%
% [cell]
% eid:    The external model id.
%
% [cell]
% tname:  The registered team name.
%
% [cell]
% ttype:  One of qualified/disqualified/naive/blast.
%         possible value: q/d/n/b
%
% [cell]
% dname:  The model name to display.
%
% [cell]
% pname:  The PI name.
%
% [cell]
% kw:     The keywords list. Separated by comma.
%
% [cell]
% chex:   Assigned color for the method. (a distinct color for each PI)
%         RGB value in HEX.
% }}}

  % check inputs {{{
  if nargin ~= 1
    error('cafa_team_read_config:InputCount', 'Expected 1 input.');
  end

  % check the 1st input 'team_file' {{{
  validateattributes(team_file, {'char'}, {'nonempty'}, '', 'team_file', 1);
  fid = fopen(team_file, 'r');
  if fid == -1
    error('cafa_team_read_config:FileErr', 'Cannot open the team file [%s].', team_file);
  end
  % }}}
  % }}}

  % read and parse {{{
  fmt = '%s%s%s%s%s%s%s%s';
  team = textscan(fid, fmt, 'HeaderLines', 1, 'Delimiter', '\t');
  fclose(fid);

  iid   = team{1};
  eid   = team{2};
  tname = team{3};
  ttype = team{4};
  dname = team{5};
  pname = team{6};
  kw    = team{7};
  chex  = team{8};
  % }}}
return

% -------------
% Yuxiang Jiang (yuxjiang@indiana.edu)
% Department of Computer Science
% Indiana University, Bloomington
% Last modified: Tue 28 Jul 2015 02:35:21 PM E
