function [rp ci ai]=sparse_to_csr(A,varargin)
% SPARSE_TO_CSR Convert a sparse matrix into compressed row storage arrays
% 
% [rp ci ai] = sparse_to_csr(A) returns the row pointer (rp), column index
% (ci) and value index (ai) arrays of a compressed sparse representation of
% the matrix A.
%
% [rp ci ai] = sparse_to_csr(i,j,v,n) returns a csr representation of the
% index sets i,j,v with n rows.
%
% Example:
%   A=sparse(6,6); A(1,1)=5; A(1,5)=2; A(2,3)=-1; A(4,1)=1; A(5,6)=1; 
%   [rp ci ai]=sparse_to_csr(A)
%
% See also SPARSE_TO_CSC

% David Gleich
% Copyright, Stanford University, 2008

% History
% 2008-04-07: Initial version
% 2008-04-24: Added triple array input

error(nargchk(1, 4, nargin, 'struct'))
retc = nargout>1; reta = nargout>2;

if nargin>1
    n = varargin{end};
    nzi = A; nzj = varargin{1};
    if reta && length(varargin) > 2, nzv = varargin{2}; end    
    nz = length(A);
    if length(nzi) ~= length(nzj), error('gaimc:invalidInput',...
            'length of nzi (%i) not equal to length of nzj (%i)', nz, ...
            length(nzj)); end
    if reta && length(varargin) < 3, error('gaimc:invalidInput',...
            'no value array passed for triplet input, see usage'); end
    if ~isscalar(n), error('gaimc:invalidInput',...
            ['the final input to sparse_to_csr with triple input was not ' ...
             'a scalar']); end
        
else
    n = size(A,1); nz=nnz(A);
    retc = nargout>1; reta = nargout>2;
    if reta,     [nzi nzj nzv] = find(A); 
    else         [nzi nzj] = find(A);
    end
end
if retc, ci = zeros(nz,1,'uint32'); end
if reta, ai = zeros(nz,1); end
rp = zeros(n+1,1,'uint32');
for i=1:nz
    rp(nzi(i)+1)=rp(nzi(i)+1)+1;
end
%rp=cumsum(rp);
cs=0; for i=1:n+1, cs=cs+rp(i); rp(i)=cs; end
if ~retc && ~reta, rp=rp+1; return; end
for i=1:nz
    if reta, ai(rp(nzi(i))+1)=nzv(i); end
    ci(rp(nzi(i))+1)=nzj(i);
    rp(nzi(i))=rp(nzi(i))+1;
end
for i=n:-1:1
    rp(i+1)=rp(i);
end
rp(1)=0;
rp=rp+1;