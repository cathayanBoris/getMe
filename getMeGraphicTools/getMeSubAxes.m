function position = getMeSubAxes(leftX13,botY11,widthX775,heightY815,mode)
% gets you sub axes that aligns at corners of a plot, n = [1 4] quadrant
% corner to align with, n = [A D] to specify width, or ignore n to specify
% parameters as generic axesPosition

% mode:

% if mode is a NUMBER: the corner will attach to the corner of associated
% quadrant and the opposite corner will land at the coordinates of request

% if mode is a LETTER: the corner will attach to the corner of associated 
% quadrant and overwrite (x) two inputs, the rest (o) will govern the else
% A: [o o x x]
% B: [x o o x]
% C: [x x o o]
% D: [o x x o]


% reference inputs
% X = [0.13 0.9050]
% Y = [0.11 0.9250]

if nargin <=4
    mode = [];
end



if isempty(mode)
    % proceed to the output statement
elseif isnumeric(mode) || ~isnan(str2double(mode)) % n is a number
    if mode == 1 || convertStringsToChars(mode) == '1' || mode == '1'
        widthX775 = 0.7750+0.13-leftX13;
        heightY815 = 0.8150+0.11-botY11;
    elseif mode == 2 || convertStringsToChars(mode) == '2' || mode == '2'
        widthX775 = leftX13 - 0.13;
        leftX13 = 0.13;
        heightY815 = 0.8150+0.11-botY11;
    elseif mode == 3 || convertStringsToChars(mode) == '3' || mode == '3'
        widthX775 = leftX13 - 0.13;
        heightY815 = botY11 - 0.11;
        leftX13 = 0.13;
        botY11 = 0.11;
    elseif mode == 4 || convertStringsToChars(mode) == '4' || mode == '4'
        heightY815 = botY11 - 0.11;
        botY11 = 0.11;
        widthX775 = 0.7750+0.13-leftX13;
    end
else % n is not a number
    if mode == 'A' || mode == 'a' || convertStringsToChars(mode) == 'A' || convertStringsToChars(mode) == 'a'
        widthX775 = 0.7750+0.13-leftX13;
        heightY815 = 0.8150+0.11-botY11;
    elseif mode == 'B' || mode == 'b' || convertStringsToChars(mode) == 'B' || convertStringsToChars(mode) == 'b'
        leftX13 = 0.13;
        heightY815 = 0.8150+0.11-botY11;
    elseif mode == 'C' || mode == 'c' || convertStringsToChars(mode) == 'C' || convertStringsToChars(mode) == 'c'
        leftX13 = 0.13;
        botY11 = 0.11;
    elseif mode == 'D' || mode == 'd' || convertStringsToChars(mode) == 'D' || convertStringsToChars(mode) == 'd'
        botY11 = 0.11;
        widthX775 = 0.7750+0.13-leftX13;
    end
end
% output statement
position = [leftX13 botY11 widthX775 heightY815];
end