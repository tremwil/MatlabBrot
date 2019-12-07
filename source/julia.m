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
    % Choose algorithm according to keywords
    algo = kw('algorithm');
    itMat = algo(c, N, mGrid, kw);
end

% Genral Julia escape value algorithm using with smooth color.
% Uses the potential function of the iteration. Here escape value should be
% large (more than 100) for this to yield a continuous coloring.
function [itMat] = algo_esc_val(c, N, mGrid, kw)
    esc2 = kw('escapevalue')^2;     % Compute square escape value
    ex = kw('exponent');            % Expoenent of z in set calc.
    
    inv_ln = 1/reallog(ex);                  % Precompute 1/ln(ex)
    inv_lnr = 1/reallog(kw('smoothRadius')); % Precompute 1/ln(r)
    
    szX = size(mGrid,2);            % Width of grid in pixels
    szY = size(mGrid,1);            % Height of grid in pixels
    itMat = zeros(szY,szX);         % Iteration matrix
    
    % Iterate through every pixel
    for j=1:szX
        for i=1:szY
            % Calculate the number of iterations at this point and store
            % value of z when escaping to compute potential function
            [it,z] = ptEscape(c, mGrid(i,j,1), mGrid(i,j,2), N,esc2,ex);
            % Compute potential function
            if it == N
                itMat(i,j) = N;
                continue
            end
            % Set minimum escape of 100 for continuous coloring
            nu = -1;
            if esc2 >= 10000
                log_zn = reallog(z*conj(z)) * 0.5;
                nu = reallog( log_zn * inv_lnr) * inv_ln; 
            end
            % Consider potential function in iteration
            itMat(i,j) = it + 1 - nu;
        end
    end
end

% Escape value algorithm using smooth color for arbitrary
% polynomials. The slowest of all the algorithms. Aagin, escape value
% should be larger than 100, otherwise colors will be discrete.
function [itMat] = algo_esc_val_poly(c, N, mGrid, kw)
    esc2 = kw('escapevalue')^2;     % Compute square escape value
    coef = kw('poly');              % Coefs. of the polynomial
    deg = length(coef) - 1;         % Degree of the polynomial
    pmat = (0:deg)';                % Power matrix for computing the poly.
    
    inv_ln = 1/reallog(deg);                 % Precompute 1/ln(deg)
    inv_lnr = 1/reallog(kw('smoothRadius')); % Precompute 1/ln(r)
    
    szX = size(mGrid,2);            % Width of grid in pixels
    szY = size(mGrid,1);            % Height of grid in pixels
    itMat = zeros(szY,szX);         % Iteration matrix
    
    for j=1:szX
        for i=1:szY
            % Calculate the number of iterations at this point and store
            % value of z when escaping to compute potential function
            it = 0;                             % Iteration count
            z = mGrid(i,j,1)+1i*mGrid(i,j,2);   % Iterated value (z)
            % While under escape val or N iter.
            while z*conj(z) <= esc2 && it < N 
                z = coef*(z.^pmat) + c; % Compute new Z value
                it = it + 1;            % Increment iter. cnt.
            end
            % Compute potential function
            if it == N
                itMat(i,j) = N;
                continue
            end
            % Set minimum escape of 100 for continuous coloring
            nu = -1;
            if esc2 >= 10000
                log_zn = reallog(z*conj(z)) * 0.5;
                nu = reallog( log_zn * inv_lnr) * inv_ln; 
            end
            % Consider potential function in iteration
            itMat(i,j) = it + 1 - nu;
        end
    end
end

% Escape value algorithm with smooth color, optimized for a
% power of 2. Uses the potential function of the iteration. Here escape
% value should be large (more than 100) for this to work properly.
function [itMat] = algo_esc_val2(c, N, mGrid, kw)
    esc2 = kw('escapevalue')^2;     % Compute square escape value
    cx = real(c); cy = imag(c);
    
    inv_ln2 = 1/reallog(2);                  % Precompute 1/ln(2)
    inv_lnr = 1/reallog(kw('smoothRadius')); % Precompute 1/ln(r)
    
    szX = size(mGrid,2);            % Width of grid in pixels
    szY = size(mGrid,1);            % Height of grid in pixels
    itMat = zeros(szY,szX);         % Iteration matrix (0 = in set)
    % Iterate through every pixel
    for j=1:szX
        for i=1:szY
            % Calculate the number of iterations at this point and store
            % last square values of x and y
            [it,x,y] = ptEscape2(cx,cy,mGrid(i,j,1),mGrid(i,j,2),N,esc2);
            % Compute potential function
            if it == 0
                itMat(i,j) = 0;
                continue
            end
            nu = -1;
            if esc2 >= 10000
                log_zn = reallog(x + y) * 0.5;
                nu = reallog( log_zn * inv_lnr) * inv_ln2; 
            end
            % Consider potential function in iteration
            itMat(i,j) = it + 1 - nu;
        end
    end
end

% Escape value algorithm subroutine for arbitrary power. Does not come with
% the optimizations of the one for a power of two, but still faster than
% the algebraic (polynomial) Mandelbrot 
function [it, z] = ptEscape(c, x0, y0, N, esc2, ex)
    it = 0;         % Iteration count
    z = x0 + 1i*y0; % Iterated value (z)

    while z*conj(z) <= esc2 && it < N % Under escape val or N iter.
        z = z.^ex + c;     % Compute new Z value
        it = it + 1;       % Increment iter. cnt.
    end
end

% Optimized escape value algorithm subroutine. Computes only 3
% multiplications per iteration.
function [it, rsqr, isqr] = ptEscape2(cx, cy, x0, y0, N, esc2)
    % Optimized iteration using reduced multiplication
    it = 0;
    rsqr = x0*x0;   % real part square
    isqr = y0*y0;   % imag. part square
    zsqr = (x0+y0)*(x0+y0); % square of real part + imag. part
    while rsqr + isqr <= esc2 && it < N % Under escape val or N iter.
         x = rsqr - isqr + cx;          % New real part
         y = zsqr - rsqr - isqr + cy;   % New imag. part
         rsqr = x * x;      % New square real part
         isqr = y * y;      % New square imag. part
         zsqr = (x+y)*(x+y);% New square sum
         it = it + 1;       % Increment iter. cnt.
    end
end

% Parse optional keyword parameters in varargin
function [kw] = parseParams(args)
    possibleKw = containers.Map('UniformValues',0);
    % POSSIBLE PARAMETERS (first element is default)
    % If not in a cell array, should be numeric input
    possibleKw('algorithm') = {     % Possible algorithms to use
        'EscapeValue'       @algo_esc_val
        'EscapeValue2'      @algo_esc_val2
        'EscapeValuePoly'   @algo_esc_val_poly};
    possibleKw('smoothRadius') = 2; % Smooth color max radius for detail
    possibleKw('poly') = [0 0 1];   % When in poly mode, the coefs (z^2).
    possibleKw('exponent') = 2;     % Power of z in calculation
    possibleKw('escapevalue') = 2;  % Bailout magnitude
    % Set default properties
    kw = containers.Map('UniformValues',0);
    for key=possibleKw.keys()
        val = possibleKw(key{1});
        if iscell(val); kw(key{1}) = val{1,2}; else; kw(key{1}) = val; end
    end
    % Parse user arguments
    for i=1:2:length(args)
        key = lower(args{i});
        if kw.isKey(key) && iscell(possibleKw(key))
            poss = possibleKw(key);
            vals = poss(:,2);
            r = strcmpi(poss(:,1), args{i+1});
            if ~any(r); error(['Invalid value: ' args{i+1}]); end
            kw(key) = vals{r};
        else
            kw(key) = args{i+1};
        end
    end
end