function varargout = scorePlot(varargin)
%SCOREPLOT Plot individuals in a factorial plane
%
%   scorePlot(PCA, I, J)
%
%   scorePlot(PCA)
%   Assumes I = 1 and J = 2.
%
%   Example
%   scorePlot
%
%   See also
%   loadingPlot, correlationCircle
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-10-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.

% Extract the axis handle to draw in
[ax, varargin] = parseAxisHandle(varargin{:});

% extract calling table
this = varargin{1};
varargin(1) = [];

% get factorial axes
cp1 = 1;
cp2 = 2;
if length(varargin) >= 2 && isnumeric(varargin{1})
    cp1 = varargin{1};
    cp2 = varargin{2};    
    varargin(1:2) = [];
end

% input argument control
nc = size(this.scores, 2);
if cp1 > nc || cp2 > nc
    error('Component number should be less than variable number');
end

% extract display options
showNames = true;
for i = 1:2:(length(varargin)-1)
    if strcmpi('showNames', varargin{i})
        showNames = varargin{i+1};
        varargin(i:i+1) = [];
        break;
    end
end

% Set up parent figure
hFig = get(ax, 'Parent');
str = sprintf('PCA Scores - CP%d vs CP%d', cp1, cp2);
set(hFig, 'Name', str, 'NumberTitle', 'off');

% setup axis
if ~isempty(varargin)
    set(ax, varargin{:});
end

% score coordinates
x = this.scores(:, cp1).data;
y = this.scores(:, cp2).data;

% display either names or dots
if showNames
    drawText(ax, x, y, this.scores.rowNames);
else
    plot(ax, x, y, '.k');
end

% create legends
annotateFactorialPlot(this, ax, cp1, cp2);

if nargout > 0
    varargout = {hFig};
end
