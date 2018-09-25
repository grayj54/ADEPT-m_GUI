function aprintf(varargin)
global VERBOSE A_FID
if VERBOSE; fprintf(A_FID,varargin{1:nargin}); end
