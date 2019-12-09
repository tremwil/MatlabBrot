function calculateAxis(ax, x, y, zoom, z1_fit)
    if nargin < 5
        z1_fit = 2;
    end
    pxpos = getpixelposition(ax);
    r = pxpos(3)/pxpos(4);
    if r >= 1
        xLim = r*[-z1_fit z1_fit];
        yLim =   [-z1_fit z1_fit];
    else
        xLim = [-z1_fit z1_fit];
        yLim = [-z1_fit z1_fit]/r;
    end
    ax.XLim = xLim/zoom + x;
    ax.YLim = yLim/zoom + y;
end

