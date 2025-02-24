function  ncStruct = getMeNc(fileName)
% ncdisp(fileName);
ni = ncinfo(fileName);
for i=1:length(ni.Variables)
    vn = ni.Variables(i).Name;
    ncStruct.(vn) = ncread(fileName, vn);  % The output is a structure 
end
end