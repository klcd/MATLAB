function [ ] = replace_projections( old_projection_file,new_projection_file,old_projections,new_projections )
%REPLACE_PROJECTIONS Replace projections in old_projection_file by ones
%from new_projection_file
%   Replace projections in new_projection_file by others from
%   new_projection_file. old_projections is a list containing the indices
%   of the projections to replace. new_projections is a list containing the
%   indices of the projections to replace the old ones.
%   The number of projections replaced must be equal to the number of new
%   projections.
%   The new projections must be defined on at least as many bands as the
%   old ones.
%   INPUT:
%   old_projection_file: .amn-file with the old projections
%   new_projection_file: .amn-file with the projections to be inserted into
%       old_projection_file
%   old_projections: list of integer indexing the projections that are to
%       be replaced.
%   new_projections: list of integer indexing the projections that are
%       replacing others.
%   
%   The lists do not need to be ordered. The first projection in
%       new_projections will replace the first on in old_projections.
%   OUTPUT:
%   No return value. The updated .amn-file is saved with an _updated.amn
%       extension.

%% Read the header of the .amn-files and make sure the numbers add up
ofid = fopen(old_projection_file,'r');
nfid = fopen(new_projection_file,'r');
title = fgets(ofid); fgets(nfid);
obuff = fgets(ofid); nbuff = fgets(nfid);
tmp = sscanf(obuff,'%d%d%d'); Nbo = tmp(1); Nko = tmp(2); Nwo = tmp(3);
tmp = sscanf(nbuff,'%d%d%d'); Nbn = tmp(1); Nkn = tmp(2); Nwn = tmp(3);

% Check for possible errors
% The new projections must be defined for all bands in the old file
if Nbo > Nbn
    fclose(ofid);
    fclose(nfid);
    error([new_projection_file ' contains not enough bands!'])
end
% Projections are defined for too many bands. Use the first Nbo ones and
% discard the rest.
if Nbn > Nbo
    warning([new_projection_file ' contains more bands than ' old_projection_file '. Ignoring the extra bands!']);
end
% The k-points must be identical. As they are not specified in the file, at
% least their number have to match.
if Nko ~= Nkn
    fclose(ofid);
    fclose(nfid);
    error('The number of k-points is inequal!');
end
% Replace only, the number of removed projections must match the number of
% new projections.
if length(old_projections) ~= length(new_projections)
    fclose(ofid);
    fclose(nfid);
    error('The number of projections to replace must be equal to the number of new projections!');
end
% Too many projections marked to replace in the old file
if length(old_projections) > Nko
    fclose(ofid);
    fclose(nfid);
    error('More projections marked to replace than are present in the old file!');
end
% Too many projections marked to replace in the new file
if length(new_projections) > Nkn
    fclose(ofid);
    fclose(nfid);
    error('More projections marked to replace than are present in the new file!');
end
% All checks are done, open the file to write
wfid = fopen([old_projection_file(1:end-4) '_updated.amn'],'w');
fprintf(wfid,[title obuff]);

%% If the new file contains more bands, the indices of the required bands are necessary
% just pick the ones from 1 to Nbo
if Nbo < Nbn
    band_inds = zeros(Nwn*Nbo,1);
    for ww = 1:Nwn
        band_inds((ww-1)*Nbo+1:ww*Nbo) = (ww-1)*Nbn+1:(ww-1)*Nbn+Nbo;
    end
end

%% Go through all blocks and replace the projectsion
for kk = 1:Nko
    disp(['Processing k-point: ' num2str(kk) ' ...'])
    % read a whole k-point block in one go, as the old and new projections
    % may be located anywhere in it.
    % read the new projections
    p_block_new = textscan(nfid,'%d %d %d %.12f %.12f',Nwn*Nbn);
    p_block_new_int = cell2mat(p_block_new(:,1:3));
    p_block_new_double = cell2mat(p_block_new(:,4:5));
    % read the old projections
    p_block_old = textscan(ofid,'%d %d %d %.12f %.12f',Nwo*Nbo);
    p_block_old_int = cell2mat(p_block_old(:,1:3));
    p_block_old_double = cell2mat(p_block_old(:,4:5));
    
    % if the number of bands doesn't match, discard the unused ones
    if Nbo ~= Nbn
        p_block_new_int = p_block_new_int(band_inds,:);
        p_block_new_double = p_block_new_double(band_inds,:);
    end
    % insert the new data into the array containing the old data
    for ii = 1:length(old_projections)
        p_block_old_double(p_block_old_int(:,2)==old_projections(ii),:) = p_block_new_double(p_block_new_int(:,2)==new_projections(ii),:);
    end
    % write the combined data to the file
    fprintf(wfid,'%d\t%d\t%d\t%.12f\t%.12f\n',[double(p_block_old_int.');p_block_old_double.']);
end
fclose(wfid);
fclose(ofid);
fclose(nfid);
end

