function idx = ccs_strfind(cellstr,pattern)
idx = [];
for k=1:numel(cellstr)
    if strcmp(cellstr{k},pattern)
        idx = [idx k];
    end
end