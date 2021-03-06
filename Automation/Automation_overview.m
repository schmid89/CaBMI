function Automation_overview

% Automation Overview

% 1. Sort data onto processing computer
% 2. Make a scheduler ( assign folders to process)
% 3. CaBMI pipeline ( with text/email warnings)


% See what we have in each folder
%    Date->animals->main
%                  map


% Initialize:
START_DIR_ROOT = cd; % or a scheduled folder...
if exist('Processed','file') >=0;;
 mkdir('Processed');
end
% 

csv_ext = 0;


% Run through everything

% Get a list of all files and folders in this folder.

files = dir(pwd);
files(ismember( {files.name}, {'.', '..'})) = [];  %remove . and ..

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
for k = 1 : length(subFolders)
	fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
end



% Run through all folder...
for i = 1:length(subFolders)-1;
disp(['entering folder', char(subFolders(i).name)])
cd(subFolders(i).name)

%% Find, and enter, main folder:

Sfiles = dir(pwd);
Sfiles(ismember( {Sfiles.name}, {'.', '..'})) = [];  %remove . and ..
% Get a logical vector that tells which is a directory.
SdirFlags = [Sfiles.isdir];
% Extract only those that are directories.
SsubFolders = Sfiles(SdirFlags);
% Print folder names to command window.

counter = 1;
for k1 = 1:length(SsubFolders)
    A = strfind(SsubFolders(k1).name, 'main');
    if ~isempty(A)
        S2S(counter) = SsubFolders(k1);
        counter = counter+1;
    end
end

% ** TO DO: Sometimes there are two 'main' folders... Check to see if this is the case.

 for ii = 1:length(S2S)
cd([S2S(ii).folder,'\',S2S(ii).name])
disp(['Entering  ',char(S2S(ii).name)]);


% ** TO DO: Check to see if 'mptifs'. if not, convert the tifs
if  exist('Processed','file') ==0; % if no tiff extraction...
 
CaBMI_mptif; % add a delete term to the raw tifs....
disp('extracting tifs...')
end


% Extracting CSV
if csv_ext ==1;
disp('Saving CSV extraction...');
try
[csv_data] = CaBMI_csvExtract;
mkdir([START_DIR_ROOT,'\','Processed','\',S2S(ii).name]);
save([START_DIR_ROOT,'\','Processed','\',S2S(ii).name,'\','csv_data'],'csv_data','-v7.3');
catch
    disp('NO CSV file, skipping...')
end
end


  if exist('Processed/roi','file') >= 1 %
        disp( ' Folder already extracted!');
        
  else
        disp(' mptiffs extracted, getting ROIs...')
    
        try
            cd('Processed')
            % if so, run them

            disp('processing ( ROI extraction)...')
            pause(0.01);
            [ROI,roi_ave] = CaBMI_Process('type',2);
        catch
              disp(' Folder does not exist');
        end
  end

% copy data over
disp('copying data...');
copyfile([S2S(ii).folder,'\',S2S(ii).name,'\','Processed\','roi\','ave_roi.mat'],[START_DIR_ROOT,'\','Processed','\',S2S(ii).name]);
% TO DO: Go back, and extract ROIs on the 'MAP' files.
% TO DO: Send warnings via text
 end
 
clear Sfiles SdirFlags S2S counter

cd(START_DIR_ROOT);
disp('-------------------------------------------');
disp('-------------------------------------------');

end

% ** TO DO: make .txt file, and email the results to myself...

% ** TO DO: cut processed data into a new folder, or save it to the RAID under,
%     the date of the data
