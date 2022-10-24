classdef scaleBar
    %{
    scaleBar - remove axes and add scale bar
        ALL UNITS IN THAT OF AXES
    %}

%% Properties
    %% Main
    properties

    end

    %% Bars
    properties

        %% Length
        barLength (1, 2) double {mustBePositiveOrNan} = nan;
        barOrigin (1, 2) double = nan;

        %% Color
        bar_RGB (2, :) {validatecolor(bar_RGB, 'multiple')} = 'k';

        %% Linestyle
        bar_LineStyle (1, 2) cell{mustBePlotLineStyle} = {'-', '-'};
        
        %% Units 
        xUnitsStr (1, :) {mustBeText} = 'x';
        yUnitsStr (1, :) {mustBeText} = 'y';
        unitsSPRINTFstr (1, :) {mustBeText} = ''; 
        numDecimals (1, 2) double ...
            {mustBeGreaterThanOrEqual(numDecimals, 0)} = 2; 
        
        %% Which bars 
        xBarOnly (1, 1) logical = false;
        yBarOnly (1, 1) logical = false; 
    end
    
    properties (Constant = true)
        xBarTextLocationScale (1, 1) double = 1.25;
        yBarTextLocationScale (1, 1) double = 1.35;
    end

    %% Axes
    properties
        ax (1, 1) matlab.graphics.axis.Axes;
        originalHoldState (1, 1) logical = ishold;
    end
    
    %% Handles 
    properties 
        xBarLine (1, 1) matlab.graphics.chart.primitive.Line; 
        yBarLine (1, 1) matlab.graphics.chart.primitive.Line;
        xUnitsText (1, 1) matlab.graphics.primitive.Text;
        yUnitsText (1, 1) matlab.graphics.primitive.Text; 
    end

%% Methods
    %% Main
    methods
        function obj = scaleBar(varargin)

            %% Parse name-value inputs
            obj.ax = gca();
            p = inputParser();
            addParameter(p, 'ax', gca); 
            defaultBarLengths = obj.calculateDefaultBarLength(); 
            addParameter(p, 'barLength', defaultBarLengths);
            defaultBarOrigin = obj.calculateDefaultBarOrigin();
            addParameter(p, 'barOrigin', defaultBarOrigin); 
            addParameter(p, 'xUnitsStr', 'x');
            addParameter(p, 'yUnitsStr', 'y');
            addParameter(p, 'numDecimals', 2); 
            addParameter(p, 'xBarOnly', false);
            addParameter(p, 'yBarOnly', false); 
            parse(p, varargin{:});

            %% Assign properties
            obj.ax = p.Results.ax; 
            obj.barLength = p.Results.barLength;
            obj.barOrigin = p.Results.barOrigin; 
            obj.xUnitsStr = p.Results.xUnitsStr; 
            obj.yUnitsStr = p.Results.yUnitsStr; 
            obj.numDecimals = p.Results.numDecimals; 
            obj.xBarOnly = p.Results.xBarOnly;
            obj.yBarOnly = p.Results.yBarOnly; 

            hold(obj.ax, 'on');
            obj = obj.addScaleBar();
            obj.restoreHoldState();
        end

        function obj = addScaleBar(obj)
            arguments
                obj (1, 1) scaleBar
            end
            obj = obj.generateUnitStrings(); 
            if obj.xBarOnly || obj.yBarOnly
                if obj.xBarOnly 
                    obj = obj.addXScale();
                    obj = obj.labelXScale(); 
                elseif obj.yBarOnly
                    obj = obj.addYScale();
                    obj = obj.labelYScale(); 
                end
            else
                obj = obj.addXScale();
                obj = obj.addYScale();
                obj = obj.labelXScale(); 
                obj = obj.labelYScale(); 
            end
            obj.removeOldAxes();
        end
        
        function obj = generateUnitStrings(obj)
            arguments 
                obj (1, 1) scaleBar;
            end
            obj.unitsSPRINTFstr = sprintf('%%.%df %%s', obj.numDecimals); 
        end

        function removeOldAxes(obj)
            arguments
                obj (1, 1) scaleBar
            end
            set(obj.ax, 'visible', 'off');
        end

        function obj = addXScale(obj)
            arguments
                obj (1, 1) scaleBar
            end
            obj.xBarLine = plot(obj.ax, ...
                [obj.barOrigin(1), obj.barOrigin(1) + obj.barLength(1)], ...
                [obj.barOrigin(2), obj.barOrigin(2)], ...
                'color', obj.bar_RGB(1, :), ...
                'linestyle', obj.bar_LineStyle{1}, ...
                'tag', 'XScaleBar');
        end
        
        function obj = labelXScale(obj)
            arguments 
                obj (1, 1) scaleBar
            end
            xBarH = findobj(obj.ax, 'tag', 'XScaleBar'); 
            avgX = obj.barOrigin(1) + obj.barLength(1)/2; 
            avgY = obj.barOrigin(2) + obj.barLength(2)/2; 
            obj.xUnitsText = text(obj.ax, ...
                avgX, avgY - obj.barLength(2)/obj.xBarTextLocationScale, ...
                sprintf(obj.unitsSPRINTFstr, diff(xBarH.XData), obj.xUnitsStr), ...
                'horizontalalignment', 'center');
        end

        function obj = addYScale(obj)
            arguments
                obj (1, 1) scaleBar
            end
            obj.yBarLine = plot(obj.ax, ...
                [obj.barOrigin(1), obj.barOrigin(1)], ...
                [obj.barOrigin(2), obj.barOrigin(2) + obj.barLength(2)], ...
                'color', obj.bar_RGB(2, :), ...
                'linestyle', obj.bar_LineStyle{2}, ...
                'tag', 'YScaleBar');
        end
        
        function obj = labelYScale(obj)
            arguments 
                obj (1, 1) scaleBar
            end
            yBarH = findobj(obj.ax, 'tag', 'YScaleBar'); 
            avgX = obj.barOrigin(1) + obj.barLength(1)/2; 
            avgY = obj.barOrigin(2) + obj.barLength(2)/2; 
            obj.yUnitsText = text(obj.ax, ...
                avgX - obj.barLength(1)/obj.yBarTextLocationScale, avgY, ...
                sprintf(obj.unitsSPRINTFstr, diff(yBarH.YData), obj.yUnitsStr), ...
                'horizontalalignment', 'center', ...
                'rotation', 90);
        end

        function restoreHoldState(obj)
            arguments
                obj (1, 1) scaleBar
            end
            if obj.originalHoldState
                hold(obj.ax, 'on')
            else
                hold(obj.ax, 'off')
            end
        end
    end
    
    %% Default properties 
    methods 
        function defaultBarLengths = calculateDefaultBarLength(obj)
            arguments 
                obj (1, 1) scaleBar
            end
            xTickDiff = diff(get(obj.ax, 'xtick'));
            yTickDiff = diff(get(obj.ax, 'ytick')); 
            defaultBarLengths = [xTickDiff(1) yTickDiff(1)]; 
        end
        
        function defaultBarOrigin = calculateDefaultBarOrigin(obj)
            arguments
                obj (1, 1) scaleBar
            end
            xLim = get(obj.ax, 'xlim');
            yLim = get(obj.ax, 'ylim');
            defaultBarOrigin = [xLim(1) yLim(1)];
        end
    end
end

%% Custom property validation
function mustBePositiveOrNan(val)
isPositiveNum = ...
    sum(val > 0 & isreal(val) & isnumeric(val) & ~islogical(val));
isNans = sum(isnan(val)) == length(val);
if ~isNans && ~isPositiveNum
    eidType = 'Value:notPositiveOrNan';
    msgType = 'Value must be positive or nan.';
    throwAsCaller(MException(eidType, msgType))
end
end

function mustBePlotLineStyle(val)
lineStyleOptions = {'-', '--', ':', '-.', 'none'};
isPossibleLineStyle = sum(ismember(val, lineStyleOptions)) == length(val);
if ~isPossibleLineStyle
    eidType = 'Value:notPossibleLineStyle';
    msgType = ...
        sprintf('Value must be possible plot linestyle.]\n%s', lineStyleOptions{:});
    throwAsCaller(MException(eidType, msgType))
end
end
