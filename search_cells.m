function [res] = search_cells(keyword, cell)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here



j = 1;
for i = 1:length(cell{1,1})
    if strfind(cell{1,1}{i},keyword) ==1
        res{j,1} = cell{1,1}{i,1};
        j = j+1;
    end
end

if j ==1
    res{1,1} = '-1';
end

clearvars j


end

