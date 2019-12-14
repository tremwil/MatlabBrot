%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculateAxis.m          %
% AUTHOR: William Tremblay %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate axis limits based on a center point and zoom level, with
% default zoom radius defined by the z1_fit variable.
function calculateAxis(ax, x, y, zoom, z1_fit)
    if nargin < 5 % If z1_fit not provided, set default to 2
        z1_fit = 2;
    end
    % Compute aspect ratio of axis
    pxpos = getpixelposition(ax);
    r = pxpos(3)/pxpos(4);
    if r >= 1
        % If aspect ratio is larger than 1, touching sides are vertical
        xLim = r*[-z1_fit z1_fit];
        yLim =   [-z1_fit z1_fit];
    else
        % Otherwise, they are horizontal
        xLim = [-z1_fit z1_fit];
        yLim = [-z1_fit z1_fit]/r;
    end
    % Adjust limits based on zoom magnification and center point
    ax.XLim = xLim/zoom + x;
    ax.YLim = yLim/zoom + y;
end

