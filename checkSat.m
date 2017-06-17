function [  ] =  checkSat( fp )
sig = fp.Signed;
wl = fp.WordLength;
sint = storedInteger(fp);
if sig  % Signed number
    if (sint == 2^(wl-1) - 1) || (sint == -2^(wl-1))  
    % Didn't consider when the number meets the upper limit but not saturate 
        warning('Saturaion may happen!');
    end
else    % Unsigned number
    if sint == 2^wl - 1   
    % Didn't consider when the number meets the upper limit but not saturate 
        warning('Saturaion may happen!');
    end
end

end