% Main dispatcher function, init complex space & call algorithm
function [itMat] = mandelbrot(N, imSz, mSpace, varargin)
    % Handle keywords given without the optional ones
    if nargin > 1 && ~isnumeric(imSz); varargin = [{imSz} varargin]; end
    if nargin > 2 && ~isnumeric(mSpace); varargin = [{mSpace} varargin]; end
    % Check for default optional arguments
    if nargin < 2 || ~isnumeric(imSz); imSz = [350 200]; end
    if nargin < 3 || ~isnumeric(mSpace); mSpace = [-2.5 -1 1 1]; end
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
    itMat = algo(N, mGrid, kw);
end

% Multibrot escape value algorithm using FOR loops with smooth color.
% Uses the potential function of the iteration. Here escape value should be
% large (more than 100) for this to yield a continuous coloring.
function [itMat] = algo_esc_val(N, mGrid, kw)
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
            [it,z] = ptEscape(mGrid(i,j,1), mGrid(i,j,2), N,esc2,ex);
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

% Escape value algorithm using FOR loops with smooth color for arbitrary
% polynomials. The slowest of all the algorithms. Aagin, escape value
% should be larger than 100, otherwise colors will be discrete.
function [itMat] = algo_esc_val_poly(N, mGrid, kw)
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
            it = 0;         % Iteration count
            z = complex(0); % Iterated value (z)
            c = mGrid(i,j,1)+1i*mGrid(i,j,2); % Value of c (current point)
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

% Escape value algorithm using FOR loops with smooth color, optimized for a
% power of 2. Uses the potential function of the iteration. Here escape
% value should be large (more than 100) for this to work properly.
function [itMat] = algo_esc_val2(N, mGrid, kw)
    esc2 = kw('escapevalue')^2;     % Compute square escape value
    bc = kw('bulbcheck');           % Bulb check on/off
    
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
            [it,x,y] = ptEscape2(mGrid(i,j,1), mGrid(i,j,2), N,esc2,bc);
            % Compute potential function
            if it == 0
                itMat(i,j) = 0;
                continue
            end
            nu = -1;
            if esc2 >= 10000
                log_zn = reallog(x+y) * 0.5;
                nu = reallog( log_zn * inv_lnr) * inv_ln2; 
            end
            % Consider potential function in iteration
            itMat(i,j) = it + 1 - nu;
        end
    end
end

% Quadtree-based algorithm exploiting the simply connected property of the
% Multibrot set and it's lemniscates. All closed paths in an iteration or
% the set itself can be reduced to a point without intersecting another
% section, so if one can find a rectangle whose boundary is uniform in the
% number of iterations, the inside region can be filled without iterating
% it. This gives a significant performance improvement, since a large
% number of points can be skipped.
function [itMat] = algo_quadtree(N, mGrid, kw)
    esc2 = kw('escapevalue')^2;     % Compute square escape value
    ex = kw('exponent');            % Exponent
    
    szX = size(mGrid,2);            % Width of grid in pixels
    szY = size(mGrid,1);            % Height of grid in pixels
    itMat = zeros(szY,szX);         % Iteration matrix (0 = in set)
    
    rectQueue = zeros(szX*szY,4);   % LIFO queue to store rectangles
    rectQueue(1,:) = [1 1 szX szY]; % Init with entire screen space
    li = 1;                         % Last index for LIFO queue
    % While rectangles queued,
    while li > 0
        % Extract last rect in queue, precompute its inside rectangle
        cr = rectQueue(li,:);
        cri = [cr(1)+1 cr(2)+1 cr(3)-1 cr(4)-1];
        li = li-1;
        
        uniform = 1;    % True if border is at same iteration level
        itC = -1;       % Current iteration

        for j=cr(1):cr(3)   % Check horizontal bounds
            it1 = ptEscape(mGrid(cr(2),j,1), mGrid(cr(2),j,2), N,esc2,ex);
            it2 = ptEscape(mGrid(cr(4),j,1), mGrid(cr(4),j,2), N,esc2,ex);
            itMat(cr(2),j) = it1;
            itMat(cr(4),j) = it2;
            if itC == -1; itC = it1; end
            if itC ~= it1 || itC ~= it2; uniform = 0; end
        end
        for i=cri(2):cri(4) % Check vertical bounds
            it1 = ptEscape(mGrid(i,cr(1),1), mGrid(i,cr(1),2), N,esc2,ex);
            it2 = ptEscape(mGrid(i,cr(3),1), mGrid(i,cr(3),2), N,esc2,ex);
            itMat(i,cr(1)) = it1;
            itMat(i,cr(3)) = it2;
            if itC ~= it1 || itC ~= it2; uniform = 0; end
        end
        % Compute total width and height of the rectangle
        dx = cr(3)-cr(1)+1;
        dy = cr(4)-cr(2)+1;
        % Check for interior pixels
        if ~(dx==2 || dy==2)
            if uniform % Uniform, fill interior with iteration level
                itMat(cri(2):cri(4),cri(1):cri(3)) = itC; 
            else
                % Not uniform, subdivide into 4 rectangles and add to LIFO
                cx = cr(1)+floor(dx/2);
                cy = cr(2)+floor(dy/2);
                rectQueue(li+1:li+4,:) = [
                    cri(1) cri(2) cx-1   cy-1
                    cx     cri(2) cri(3) cy-1
                    cri(1) cy     cx-1   cri(4)
                    cx     cy     cri(3) cri(4)
                ];    
                li = li+4;
            end
        end
    end
end

% Quadtree-based algorithm exploiting the simply connected property of the
% Mandelbrot set and it's lemniscates. Optimized for the power = 2 case.
% The fastest Mandelbrot algorithm.
function [itMat] = algo_quadtree2(N, mGrid, kw)
    esc2 = kw('escapevalue')^2;     % Compute square escape value
    bc = kw('bulbcheck');           % Bulb check on/off
    
    szX = size(mGrid,2);            % Width of grid in pixels
    szY = size(mGrid,1);            % Height of grid in pixels
    itMat = zeros(szY,szX);         % Iteration matrix
    
    rectQueue = zeros(szX*szY,4);   % LIFO queue to store rectangles
    rectQueue(1,:) = [1 1 szX szY]; % Init with entire screen space
    li = 1;                         % Last index for LIFO queue
    % While rectangles queued,
    while li > 0
        % Extract last rect in queue, precompute its inside rectangle
        cr = rectQueue(li,:);
        cri = [cr(1)+1 cr(2)+1 cr(3)-1 cr(4)-1];
        li = li-1;
        
        uniform = 1;    % True if border is at same iteration level
        itC = -1;       % Current iteration

        for j=cr(1):cr(3)   % Check horizontal bounds
            it1 = ptEscape(mGrid(cr(2),j,1), mGrid(cr(2),j,2), N,esc2,bc);
            it2 = ptEscape(mGrid(cr(4),j,1), mGrid(cr(4),j,2), N,esc2,bc);
            itMat(cr(2),j) = it1;
            itMat(cr(4),j) = it2;
            if itC == -1; itC = it1; end
            if itC ~= it1 || itC ~= it2; uniform = 0; end
        end
        for i=cri(2):cri(4) % Check vertical bounds
            it1 = ptEscape(mGrid(i,cr(1),1), mGrid(i,cr(1),2), N,esc2,bc);
            it2 = ptEscape(mGrid(i,cr(3),1), mGrid(i,cr(3),2), N,esc2,bc);
            itMat(i,cr(1)) = it1;
            itMat(i,cr(3)) = it2;
            if itC ~= it1 || itC ~= it2; uniform = 0; end
        end
        % Compute total width and height of the rectangle
        dx = cr(3)-cr(1)+1;
        dy = cr(4)-cr(2)+1;
        % Check for interior pixels
        if ~(dx==2 || dy==2)
            if uniform % Uniform, fill interior with iteration level
                itMat(cri(2):cri(4),cri(1):cri(3)) = itC; 
            else
                % Not uniform, subdivide into 4 rectangles and add to LIFO
                cx = cr(1)+floor(dx/2);
                cy = cr(2)+floor(dy/2);
                rectQueue(li+1:li+4,:) = [
                    cri(1) cri(2) cx-1   cy-1
                    cx     cri(2) cri(3) cy-1
                    cri(1) cy     cx-1   cri(4)
                    cx     cy     cri(3) cri(4)
                ];    
                li = li+4;
            end
        end
    end
end

% Escape value algorithm subroutine for arbitrary power. Does not come with
% the optimizations of the one for a power of two, but still faster than
% the algebraic (polynomial) Mandelbrot 
function [it, z] = ptEscape(x0, y0, N, esc2, ex)
    it = 0;         % Iteration count
    c = x0 + 1i*y0; % Value of c (current point)
    z = complex(0); % Iterated value (z)

    while z*conj(z) <= esc2 && it < N % Under escape val or N iter.
        z = z.^ex + c;     % Compute new Z value
        it = it + 1;       % Increment iter. cnt.
    end
end

% Optimized escape value algorithm subroutine. Computes only 3
% multiplications per iteration and algebraically checks if the point is in
% either of the two main bulbs for speed.
function [it, rsqr, isqr] = ptEscape2(x0, y0, N, esc2, bcheck)
    % Optimized iteration using reduced multiplication
    it = 0;
    rsqr = 0;   % real part square
    isqr = 0;   % imag. part square
    zsqr = 0;   % square of real part + imag. part
    % Check if the point is in the period 1 or 2 bulbs
    if bcheck
        q = (x0-0.25)*(x0-0.25) + y0*y0;
        if (x0+1)*(x0+1) + y0*y0 <= 0.0625 || q*(q+x0-0.25) <= 0.25*y0*y0
            it = N;
            return
        end
    end
    while rsqr + isqr <= esc2 && it < N % Under escape val or N iter.
         x = rsqr - isqr + x0;          % New real part
         y = zsqr - rsqr - isqr + y0;   % New imag. part
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
        'QuadtreeFill'      @algo_quadtree
        'QuadtreeFill2'     @algo_quadtree2
        'EscapeValuePoly'   @algo_esc_val_poly};
    possibleKw('smoothRadius') = 2; % Smooth color max radius for detail
    possibleKw('poly') = [0 0 1];   % When in poly mode, the coefs (z^2).
    possibleKw('bulbcheck') = 1;    % Check bulbs when using power of 2
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