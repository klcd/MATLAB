first = 2;
last = 15;


for i = first:1:last;
    folder = ['part' num2str(i)];
    system(['mv WAVECAR ' folder '/']);
    cd(folder);
    system('vasp_no_overlap > output </dev/null &');
 
    found = false;

    while ~found

        FID = fopen('output', 'r');
        if FID == -1, error('Cannot open file'), end
        Data = textscan(FID, '%s', 'delimiter', '\n', 'whitespace', '');
        CStr = Data{1};
        fclose(FID);

        f = find(strcmp(CStr,' the WAVECAR file was read sucessfully'),1);
        found = ~isempty(f);
        if found
            disp('WAVECAR Read')
        else
            disp('not yet')
        end

        pause(5)

    end


    system('mv WAVECAR ../');
    cd('../');
end
 