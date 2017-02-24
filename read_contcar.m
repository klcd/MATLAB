function [ positions,coords,vectors ] = read_contcar( file_name )
%READ_CONTCAR Summary of this function goes here
%   Detailed explanation goes here

if nargin < 1
    file_name = 'CONTCAR';
end

fid = fopen(file_name,'r');
fgetl(fid); % only comment on first line

%% Constant to scale the positions
line = fgetl(fid);
s = str2double(line); % scale everything with this number

%% get the three vectors
vectors = zeros(3,3);
for ii=1:3
    vectors(ii,:) = str2num(fgetl(fid))*s; %#ok<*ST2NM>
end
    
% Type of atoms
line = fgetl(fid);
name_ele = strsplit(strtrim(line));

line = fgetl(fid);
num_atoms = str2num(line);
num_ele = length(num_atoms);

coords = cell(num_ele,3);

line = strtrim(fgetl(fid));

% Selectives dynamics
if (line(1) == 'S' || line(1) == 's')
    line = strtrim(fgetl(fid));
end

if ~(line(1) == 'D' || line(1) == 'd')
    
    for ii=1:num_ele
        
        coords_temp = zeros(num_atoms(ii),3);

        for jj=1:num_atoms(ii)
            
            if feof(fid)
                error('Missing coordinates!')
            end
            line = fgetl(fid);
            line = textscan(line,'%s');
            pos = [str2double(line{1,1}(1)) str2double(line{1,1}(2)) str2double(line{1,1}(3))];
            coords_temp(jj,:) = pos*s;

        end

        coords{ii,1} = name_ele(ii);
        coords{ii,2} = num_atoms(ii);
        coords{ii,3} = coords_temp;

    end
    
else

    for ii=1:num_ele

        coords_temp = zeros(num_atoms(ii),3);

        for jj=1:num_atoms(ii)

            if feof(fid)
                error('Missing coordinates!')
            end
            line = fgetl(fid);
            line = textscan(line,'%s');
            pos = [str2double(line{1,1}(1)) str2double(line{1,1}(2)) str2double(line{1,1}(3))];
            coords_temp(jj,:) = vectors(1,:)*pos(1)+vectors(2,:)*pos(2)+vectors(3,:)*pos(3);

        end

        coords{ii,1} = name_ele(ii);
        coords{ii,2} = num_atoms(ii);
        coords{ii,3} = coords_temp;
    end

end

fclose(fid);
positions = [];%zeros(sum(num_atoms),3);
for ii=1:num_ele
    positions = [positions; coords{ii,3}];
end

end

