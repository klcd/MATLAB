function [] = omen_sort(cmd_file,output_file, comments, header_lines)
%Sorts a oment command file according to the parameters that are specified
%in the file of the folder params.
%   cmd_file:       unsorte omen command file name
%   output_file:    sorted omen command file name
%   comments:       Decides if comments are included in the new file.
%                   If so comments = 1 els comments = 0
%   header_lines:   Number of header lines in the cmd_file

if exist(output_file, 'file')==2;
  delete(output_file);
end

if exist(output_file, 'file') == 0;
 disp('File does not exist, creating file.')
 f = fopen( output_file, 'w' );  
 fclose(f);
else
    disp('File exists.');
end



%Separating the command file into  variable, value and comment and put info
%into seperate cells

cm = fopen(cmd_file);
CM = strtrim(textscan(cm,'%s %s', 'Delimiter', '=','headerLines',header_lines));

for i = 1:length(CM{1})
    a = strsplit(CM{1,2}{i},'//');
    if length(a) == 1
        CM{1,2}{i,1} = strtrim(a);
        CM{1,3}{i,1} = '';
    elseif length(a) == 2;
        CM{1,2}{i,1} = strtrim(a{1});
        CM{1,3}{i,1} = strtrim(a{2});
    end 
end   

clearvars a ;

CM = [CM{1} CM{2} CM{3}];

%Path to the parameter folder

param_path = '/home/cedrick/Documents/MATLAB/omen_params/'



omen_sort_title(output_file, 'General Parameters');
CM = little_omen_sort(CM, [param_path 'general_params'], output_file,comments);

% %Channel structure
omen_sort_title(output_file, 'Channel Structure');
CM = omen_structure_sort(CM,[param_path 'mat_params'], output_file, comments);
 
% %oxide layer structure
omen_sort_title(output_file, 'Oxid Structure');
CM = omen_structure_sort(CM,[param_path 'oxid_params'], output_file, comments);
 
%gate contac structure
omen_sort_title(output_file, 'Gate Structure');
CM = omen_structure_sort(CM,[param_path 'gate_contact_params'], output_file, comments);

%roughness structure
omen_sort_title(output_file, 'Roughness');
CM = omen_structure_sort(CM,[param_path 'gate_contact_params'], output_file, comments);

%strain regions - not completed
omen_sort_title(output_file, 'Strain');
CM = omen_structure_sort(CM,[param_path 'strain_params'], output_file, comments);

%doping regions - not completed
omen_sort_title(output_file, 'Doping');
CM = omen_structure_sort(CM,[param_path 'doping_params'], output_file, comments);

%contact 
omen_sort_title(output_file, 'Schottky Contact Parameters');
CM = little_omen_sort(CM, [param_path 'schottky_contact'], output_file,comments);


%bandstructure
omen_sort_title(output_file, 'Bandstructure Options');
CM = little_omen_sort(CM, [param_path 'bandstructure_options_params'], output_file,comments);

%energy
omen_sort_title(output_file, 'Energy Parameters');
CM = little_omen_sort(CM, [param_path 'energy_params'], output_file,comments);

%poisson equation
omen_sort_title(output_file, 'Poisson Equation Parameters');
CM = little_omen_sort(CM, [param_path 'poisson_params'], output_file,comments);

%scattering
omen_sort_title(output_file, 'E-P and P-P Scattering');
CM = little_omen_sort(CM, [param_path 'ep_pp_scatter_params'], output_file,comments);

%voltage and temperature
omen_sort_title(output_file, 'Voltages and Temperatures');
CM = little_omen_sort(CM, [param_path 'volt_temp_params'], output_file,comments);

%parallelization
omen_sort_title(output_file, 'Parallelization Parameters');
CM = little_omen_sort(CM, [param_path 'parallel_params'], output_file,comments);

%other parameters
omen_sort_title(output_file, 'Other Parameters');
CM = little_omen_sort(CM, [param_path 'other_params'], output_file,comments);

%commands
omen_sort_title(output_file, 'Commands');
CM = omen_structure_sort(CM,[param_path 'command_params'], output_file, comments);
fclose('all');

disp('Eventually some parameters of your command file are not within the standard parameters.')
disp('These are excluded in the new file and listed below. Please include them in the library.')
disp('Eventually some lines are nonsence because parts of the comments are seen as new lines')
disp('by MATLABS textscan or they are pure comment lines.')
CM
end

