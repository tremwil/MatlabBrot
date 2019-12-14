%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% updateTextBox.m          %
% AUTHOR: William Tremblay %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Handles key down in edit boxes to make sure the accepted values
% are valid according to a range and a custom function with 2 outputs:
% The first should be a transformed value to be saved in the settings
% while the second should be a boolean describing if the value is correct.

% If an incorrect value is entered and the user presses ENTER to validate,
% the box will turn red (indicating a wrong value). At this point,
% switching to another UI element will reset the value to the last correct
% one.

% Numeric value stored in Value, and UserData is a cell array containing:
% - Elem 1: Last accepted string (to cancel invalid user input)
% - Elem 2: Default string (for reset)
% - Elem 3: Default numeric value (for reset)

function valid = updateTextBox(src, min, max, func, ignore)
    if nargin > 3
        [vNext, valid] = func(src.String); % Parse input with function
    else
        vNext = str2double(src.String);
        valid = ~isnan(vNext);
    end
    if any(vNext < min | vNext > max) && ~(nargin > 4 && ignore)
        valid = 0; 
    end
    % Get last pressed character
    vk = get(gcf, 'CurrentCharacter');
    % using disp is necessary to prevent double callbacks for some unknown
    % reason, probably has to to with the inernal system that Matlab uses
    % to handle window focus and events (or mabye timing?)
    disp(int32(vk));
    if valid % Input valid, save value
        src.BackgroundColor = [1.0 1.0 1.0];    % Normal background
        src.UserData{1} = src.String;           % Update last good input
        src.Value = vNext;                      % Update value
    elseif vk == 13 % User pressed Enter + invalid, soft reset
        src.BackgroundColor = [1.0 0.32 0.32]; % Redish background
        % Use Java keypress emulator to send a key so that MATLAB considers
        % the text box to have updated, allowing the callback function to
        % be called again when focus is lost. This is a hacky solution but
        % MATLAB does not give a direct way to detect when a UI element
        % loses focus.
        import java.awt.Robot;
        import java.awt.event.KeyEvent;
        robot=Robot;
        % Type a character '1' in the text box
        robot.keyPress(KeyEvent.VK_1);              
        robot.keyRelease(KeyEvent.VK_1);
        % Send backspace to remove the '1' that was typed
        robot.keyPress(KeyEvent.VK_BACK_SPACE);    
        robot.keyRelease(KeyEvent.VK_BACK_SPACE);
    else % Lost focus + invalid, hard reset
        src.BackgroundColor = [1.0 1.0 1.0]; % Normal background
        src.String = src.UserData{1};
    end
end