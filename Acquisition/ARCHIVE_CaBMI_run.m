function TData = CaBMI_run(ROI,pl,arduino)
%% CaBMI_BMIrun.m

  % Pull data and align it, then save it all together.
  % Put a text flag that data needs to be processed today.

  % d12.10.2017
  % WAL3


% Vars
check = 1;
L= 1;
fdbk = 1;

trials = 20;
P1 = 15; % Pause in the begining
P2 = 15; % pause in the end
P3 = 30; % Interval between trials
max_time = 60; % BMI time

%% Start Aquisition (trigger start with TTL) ( also trigger video monitor)

% Trigger to start
Tm = trials*(P1+max_time+P2)+P3;
Tf = Tm*30;
disp( '----------------------------------------------------');
disp([ 'total number of trials: ', num2str(trials)]);
disp( ['total time is ', num2str(Tm/60), ' minutes']);
disp([ 'total frames is ', num2str(Tf)]);
%% Do BMI periodically;
disp( '----------------------------------------------------');
  disp('Aquireing Baseline....');
fprintf(arduino,'%c',char(98)); % START trigger


pause(P3); % aquire baseline...

for i = 1:trials

  disp('Starting...');
  % Start:
  disp('triggering...');


  pause(P1);

  % run BMI
  disp(['Running BMI Script ',num2str(L), ' of ',num2str(trials)]);
  [data] = caBMI_feedback(pl,arduino,ROI,max_time)
  % TTL Start Aquisition
  % TTL

  pause(P2)

  TData{L} = data;
  clear data;
  Tz = tic;
  check = check+1;
  L = L+1;


    if check >5
      % Periodic alignment check- move ROI masks if need be...
      disp('Running Alignment Check..');

      disp('Adjusting ROIs..');
      disp('ROIs are OK..');
      check = 1;

end



end
fprintf(arduino,'%c',char(98)); % START trigger





%% Save Data Temporarily


disp('save(...)');

%% Consolidate time series data in 2P Temp folder

disp('movedata(...)');
