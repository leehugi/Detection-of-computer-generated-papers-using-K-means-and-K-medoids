
function [strings, count] = partition_str(str, wind)
    m = length(str);
    count = fix(m / wind);
    index = 1: wind*count;
    mat = reshape(index, [wind, count])';
    strings = str(mat);
end