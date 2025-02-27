function position = getMeSubAxes(leftX13,botY11,widthX775,heightY815,mode)
% gets you sub axes that aligns at corners of a plot, n = [1 4] quadrant
% corner to align with, n = [A D] to specify width, or ignore n to specify
% parameters as generic axesPosition
% X = [0.13 0.9050]
% Y = [0.11 0.9250]

if nargin <=4
    mode = [];
end

if isempty(mode)
    % proceed to the output statement
elseif isnumeric(mode) % n is a number
    if mode == 1
        widthX775 = 0.7750+0.13-leftX13;
        heightY815 = 0.8150+0.11-botY11;
    elseif mode == 2
        widthX775 = leftX13 - 0.13;
        leftX13 = 0.13;
        heightY815 = 0.8150+0.11-botY11;
    elseif mode == 3
        widthX775 = leftX13 - 0.13;
        heightY815 = botY11 - 0.11;
        leftX13 = 0.13;
        botY11 = 0.11;
    elseif mode == 4
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