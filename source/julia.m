% Main dispatcher function, init complex space & call algorithm
function [itMat] = julia(c, N, imSz, mSpace, varargin)
    % Handle keywords given without the optional ones
    if nargin > 2 && ~isnumeric(imSz); varargin = [{imSz} varargin]; end
    if nargin > 3 && ~isnumeric(mSpace); varargin = [{mSpace} varargin]; end
    % Check for default optional arguments
    if nargin < 3 || ~isnumeric(imSz); imSz = [350 200]; end
    if nargin < 4 || ~isnumeric(mSpace); mSpace = [-2.5 -1 1 1]; end
    % Parse user parameters
    kw = parseParams(varargin);
    % Make 3D matrix containing the complex numbers as real/imag pairs
    % This is prefered to a complex matrix because Matlab is very slow with
    % complex matrices
    [re,im] = meshgrid(linspace(mSpace(1),mSpace(3),imSz(1)),...
                           linspace(mSpace(2),mSpace(4),imSz(2)));
    mGrid = cat(3, re, im);
    itMat = algo_esc_iter(c, N, mGrid, kw);
end

% Escape value algorithm using FOR loops with smooth color. Uses the
% potential function of the iteration. Here escape value should be large
% (more than 100) for this to yield a continuous coloring.
function [itMat] = algo_esc_iter(c, N, mGrid, kw)
    esc2 = kw('escapevalue')^2;     % Compute square escape value
    ex = kw('exponent');            % Expoenent of z in set calc.
    szX = size(mGrid,2);            % Width of grid in pixels
    szY = size(mGrid,1);            % Height of grid in pixels
    itMat = zeros(szY,szX);         % Iteration matrix (0 = in set)
    inv_ln = 1/reallog(ex);         % Precompute 1/ln(2) (used every iter.)
    % Iterate through every pixel
    for j=1:szX
        for i=1:szY
            % Calculate the number of iterations at this point and store
            % last square values of x and y
            [it,z] = ptEscape(mGrid(i,j,1), mGrid(i,j,2), c,N,esc2,ex);
            % Compute potential function
            if it == N
                itMat(i,j) = N;
                continue
            end
            % Set minimum escape of 100 for continuous coloring
            nu = -1;
            if esc2 >= 10000
                log_zn = reallog(z*conj(z)) * 0.5;
                nu = reallog( log_zn * inv_ln) * inv_ln; 
            end
            % Consider potential function in iteration
            itMat(i,j) = it + 1 - nu;
        end
    end
end

% Escape value algorithm subroutine.
function [it, z] = ptEscape(x0, y0, c, N, esc2, ex)
    it = 0;         % Iteration count
    z = x0 + 1i*y0; % Value of z (current point)
    
    while z*conj(z) <= esc2 && it < N % Under escape val or N iter.
        z = z.^ex + c;     % Compute new Z value
        it = it + 1;       % Increment iter. cnt.
    end
end

% Parse optional keyword parameters in varargin
function [kw] = parseParams(args)
    possibleKw = containers.Map('UniformValues',0);
    % POSSIBLE PARAMETERS (first element is default)
    % If not in a cell array, should be numeric input
    possibleKw('exponent') = 2;     % Power of z in calculation
    possibleKw('escapevalue') = 2;  % Bailout magnitude
    % Set default properties
    kw = containers.Map('UniformValues',0);
    for key=possibleKw.keys()
        kw(key{1}) = possibleKw(key{1});
    end
    % Parse user arguments
    for i=1:2:length(args)
        key = lower(args{i});
        kw(key) = args{i+1};
    end
end