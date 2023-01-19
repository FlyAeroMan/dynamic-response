function allData = ReadStabFile
%ReadStabFile - a function that reads all relavent data from a .stab file
%which is an ascii file format output by VSPAero Stability runs.

%Allow the user to select the file
[filename, pathname] = uigetfile({'*.stab','*.*'});
filepathname = append(pathname, filename);

% Read the whole file into memory
FID = fopen(filepathname);
line = 1;
while ~feof(FID)
    rawdata{line, 1} = fgetl(FID);
    line = line + 1;
end
fclose(FID);

% Store relavent values into allData
alldata{1,1} = rawdata{4,1}
end