function alldata = ReadStabFile(controls)
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

% Get Inertia Data
[file,path] = uigetfile('*.xlsx');
data = xlsread(sprintf('%s%s',path,file),3);

% Store relavent values into alldata
% All aircraft dimensional and flow Properties are in alldata{1}
% alldata{1}(1) => Wing area (in^2)
% alldata{1}(2) => wing span (in)
% alldata{1}(3) => mass (slugs)
% alldata{1}(4) => Air Density (slugs/in^3)
% alldata{1}(5) => Vinf, steady state velocity (in/s)
% alldata{1}(6) => gravitational constant (in/s^2)
% alldata{1}(7) => Wing Chord (in)
% alldata{1}(8) => dynamic pressure (lbf/in^2)
% alldata{1}(9) => Angle of Attack steady state (deg)
% % All aircraft inertial Properties are in alldata{2}
% alldata{2}(1) => IxxB ()
% alldata{2}(2) => IzzB ()
% alldata{2}(3) => IxzB ()
% % All Y-Force non-dimensional derivatives are in alldata{3}
% alldata{3}(1) => Cyb ()
% alldata{3}(2) => Cyp ()
% alldata{3}(3) => Cyr ()
% alldata{3}(4) => Cyda ()
% % All Rolling Moment non-dimensional derivatives are in alldata{4}
% alldata{4}(1) => Clb ()
% alldata{4}(2) => Clp ()
% alldata{4}(3) => Clr ()
% alldata{4}(4) => Clda ()
% All Yawing Moment non-dimensional derivatives are in alldata{5}
% alldata{5}(1) => Cnb ()
% alldata{5}(2) => CnTb () only used if 1 engine inoperable
% alldata{5}(3) => Cnp ()
% alldata{5}(4) => Cnr ()
% alldata{5}(5) => Cnda ()

% All aircraft dimensional and flow Properties are in alldata{1}
alldata{1}(1) = sscanf(rawdata{4,1},'%*s %f'); % Wing area (in^2)
alldata{1}(2) = sscanf(rawdata{6,1},'%*s %f'); % wing span (in)
alldata{1}(3) = data(20, 13); % mass (slugs)
alldata{1}(4) = 0.00228106/12^3;%sscanf(rawdata{13,1},'%*s %f'); % Air Density (slugs/in^3)
alldata{1}(5) = sscanf(rawdata{14,1},'%*s %f'); % Vinf, steady state velocity (in/s)
alldata{1}(6) = data(21, 13); % gravitational constant (in/s^2)
alldata{1}(7) = sscanf(rawdata{5,1},'%*s %f'); % Wing Chord (in)
alldata{1}(8) = 0.5*alldata{1}(4)*alldata{1}(5); % dynamic pressure (lbf/in^2)
alldata{1}(9) = sscanf(rawdata{11,1},'%*s %f'); % Angle of Attack steady state (deg) 
% All aircraft inertial Properties are in alldata{2}
alldata{2}(1) = data(15, 13); % IxxB ()
alldata{2}(2) = data(17, 13); % IzzB ()
alldata{2}(3) = data(18, 13); % IxzB ()
alldata{2}(4) = data(16, 13); % IyyB ()
% All Y-Force non-dimensional derivatives are in alldata{3}
temp = sscanf(rawdata{39,1},'%*s %f %f %f %f %f %f %f %f %f');
alldata{3}(1) = temp(3); % Cyb ()
alldata{3}(2) = temp(4); % Cyp ()
alldata{3}(3) = temp(6); % Cyr ()
if controls
    alldata{3}(4) = temp(9); % Cyda ()
end
% All Rolling Moment non-dimensional derivatives are in alldata{4}
temp = sscanf(rawdata{47,1},'%*s %f %f %f %f %f %f %f %f %f');
alldata{4}(1) = temp(3); % Clb ()
alldata{4}(2) = temp(4); % Clp ()
alldata{4}(3) = temp(6); % Clr ()
if controls
    alldata{4}(4) = temp(9); % Clda ()
end
% All Yawing Moment non-dimensional derivatives are in alldata{5}
temp = sscanf(rawdata{47,1},'%*s %f %f %f %f %f %f %f %f %f');
alldata{5}(1) = temp(3); % Cnb ()
alldata{5}(2) = 0; % CnTb () only used if 1 engine inoperable
alldata{5}(3) = temp(4); % Cnp ()
alldata{5}(4) = temp(6); % Cnr ()
if controls
    alldata{5}(5) = temp(9); % Cnda ()
end
end