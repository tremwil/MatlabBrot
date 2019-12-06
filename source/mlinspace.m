function [mat] = mlinspace(m1, m2, n, d)
%MLINSPACE Linspace of matrices along the dimension d
    if nargin == 3
        d = find(size(m1) ~= 1, 1); 
        if numel(d) == 0; d = length(size(m1)) + 1; end
    end
    if ~isequal(size(m1), size(m2))
        error('Matrices must have the same size')
    end
    delta = (m2 - m1) / (n - 1);
    dsp = 1:max(d,2);
    vM = repmat(permute((0:(n-1))', [d dsp(dsp~=d)]), size(m1));
    mat = m1 + delta .* vM;
end

