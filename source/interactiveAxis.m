function interactiveAxis(src, evt, handles)
    % Check if dynamic zoom is disabled
    zoomCB = handles.dynamicZoom;
    if ~zoomCB.Value
        return; 
    end
    % Perform interactive axis events for each axis object
    axPrefix = {'Mandel', 'Julia'};
    for i=1:2
        % Get handles for the relevant parts
        ax      = handles.(['ax' axPrefix{i}]);
        cxTB    = handles.([lower(axPrefix{i}) 'Cx']);
        cyTB    = handles.([lower(axPrefix{i}) 'Cy']);
        zoomTB  = handles.([lower(axPrefix{i}) 'Zoom']);
        % Skip axis if turned off
        if ~ax.Visible
            continue;
        end
        % Get current mouse position and check if in bounds
        cpt = ax.CurrentPoint(1,1:2);
        inBounds = cpt(1) >= ax.XLim(1) && cpt(1) <= ax.XLim(2) && ...
                   cpt(2) >= ax.YLim(1) && cpt(2) <= ax.YLim(2);
        % Left click inside axis
        if strcmp(evt.EventName, 'WindowMousePress') && inBounds && ...
                strcmp(src.SelectionType, 'normal')
            ax.UserData = cpt;
        % Left mouse is being held
        elseif ~isequal(ax.UserData, [0 0])
            % Mouse button released
            if strcmp(evt.EventName, 'WindowMouseRelease')
                ax.UserData = [0 0];
            end
            % Moving mouse while pressing button
            if strcmp(evt.EventName, 'WindowMouseMotion')
                delta = cpt - ax.UserData;
                nC = [cxTB.Value, cyTB.Value] - delta;
                % Update text boxes
                cxTB.Value = nC(1);
                cyTB.Value = nC(2);
                cxTB.String = num2str(nC(1));
                cyTB.String = num2str(nC(2));
                cxTB.UserData{1} = cxTB.String;
                cyTB.UserData{1} = cyTB.String;
                % Move axis accordingly
                calculateAxis(ax, nC(1), nC(2), zoomTB.Value);
                if handles.autoRender.Value
                    handles.renderSub(i == 1, i == 2, handles); 
                end
            end
        % Scrolling mouse
        elseif strcmp(evt.EventName, 'WindowScrollWheel') && inBounds
            % Compute new zoom value and center
            zF = -evt.VerticalScrollCount;
            % Block zooming if already to high
            if zoomTB.Value > 1e13 && zF > 0
                return; 
            end
            nZ = zoomTB.Value * 1.100^zF;
            nC = 1.100^(-zF)*([cxTB.Value, cyTB.Value] - cpt) + cpt;
            % Update text boxes
            cxTB.Value = nC(1);
            cyTB.Value = nC(2);
            zoomTB.Value = nZ;
            cxTB.String = num2str(nC(1));
            cyTB.String = num2str(nC(2));
            zoomTB.String = num2str(nZ);
            cxTB.UserData{1} = cxTB.String;
            cyTB.UserData{1} = cyTB.String;
            zoomTB.UserData{1} = zoomTB.String;
            % Recalculate axis
            calculateAxis(ax, nC(1), nC(2), nZ);
            if handles.autoRender.Value
                handles.renderSub(i == 1, i == 2, handles); 
            end
        end
    end
end
