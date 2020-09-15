function [ fr ] = occur(str,list)

for jj=1:size(list,1)
    listchar=char(list(jj));
    fr(jj)=length(strfind(str, listchar));
end

end

