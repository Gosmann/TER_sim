run("params.m");
run("Results.m");
Simulink.sdi.clear;

Model = 'grid';
CalibrationModel = 'calibration'
open(Model);
open(CalibrationModel);

p_ref_i = 3;
freq_i = 2;
% The first run is meant to calibrate the necessary base torque of the
% machine for the specified power. An initial guess is made and the results
% are used to improve it. One iteration should be enough. The easiest way
% to have only one machine is to set both machines to be identical. I could
% have a secondary file only with a machine and a charge in an isolated
% grid.


% The object where we save the Results
numberOfSimulations = 121; % TODO
resultArray(numberOfSimulations) = Results;
"Machine 1"                
% first pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{freq_i};

plotM_1(P_ref, freq, 1);

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

% Second pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{freq_i};

plotM_2(P_ref, freq, 1);

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

% Now doing the same for the second machine
"Machine 2"
M1_backup = M1;
M1 = M2;
% first pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{freq_i};

plotM_1(P_ref, freq, 2);

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

% Second pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{freq_i};

plotM_2(P_ref, freq, 2);

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

M2 = M1;
M1 = M1_backup;

%-------------------------------------------------------------------------%
%- - - - - - - - - - - - now to the real simulation - - - - - - - - - - - %             
%-------------------------------------------------------------------------%
"Real simulation" %#ok<*NOPTS>

clear necessaryGain;

simOut = sim(Model);

% FREQUENCY
freq = simOut.logsout{3};
% imediately before closing 
freq_1 = freq.Values.Data(close_time/0.0002 - 500 );

% after closing
freq_2_array = freq.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
freq_2 = freq_2_array(end);
freq_2_min = min(freq_2_array);

% after reopening
freq_3_array = freq.Values.Data(open_time/0.0002 - 500 + 2: end);
freq_3 = freq_3_array(end);
freq_3_max = max(freq_3_array);

% VOLTAGE
tension = simOut.logsout{1};
% imediately before closing 
tension_1 = tension.Values.Data(close_time/0.0002 - 500 );

% after closing
tension_2_array = tension.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
tension_2 = tension_2_array(end);

% after reopening
tension_3_array = tension.Values.Data(open_time/0.0002 - 500 + 2: end);
tension_3 = tension_3_array(end);

% P_ref_1 e 2
% The control signal after the droop that sets the torque (pu)
P_ref_1 = simOut.logsout{6};
P_ref_2 = simOut.logsout{7};
% imediately before closing 
P_ref_1_1 = P_ref_1.Values.Data(close_time/0.0002 - 500 );
P_ref_2_1 = P_ref_2.Values.Data(close_time/0.0002 - 500 );

% after closing
P_ref_1_2_array = P_ref_1.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P_ref_1_2 = P_ref_1_2_array(end);
P_ref_1_2_max = max(P_ref_1_2_array);

P_ref_2_2_array = P_ref_2.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P_ref_2_2 = P_ref_2_2_array(end);
P_ref_2_2_max = max(P_ref_2_2_array);

% after reopening
P_ref_1_3_array = P_ref_1.Values.Data(open_time/0.0002 - 500 + 2: end);
P_ref_1_3 = P_ref_1_3_array(end);
P_ref_1_3_min = min(P_ref_1_3_array);

P_ref_2_3_array = P_ref_2.Values.Data(open_time/0.0002 - 500 + 2: end);
P_ref_2_3 = P_ref_2_3_array(end);
P_ref_2_3_min = min(P_ref_2_3_array);

% POWER
P = simOut.logsout{2};
P1 = simOut.logsout{4};
P2 = simOut.logsout{5};
% imediately before closing 
P_1 = P.Values.Data(close_time/0.0002 - 500 );
P1_1 = P1.Values.Data(close_time/0.0002 - 500 );
P2_1 = P2.Values.Data(close_time/0.0002 - 500 );

% after closing
P_2_array = P.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P_2 = P_2_array(end);
P_2_min = min(P_2_array);
P_2_max = max(P_2_array);

P1_2_array = P1.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P1_2 = P1_2_array(end);
P1_2_min = min(P1_2_array);
P1_2_max = max(P1_2_array);

P2_2_array = P2.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P2_2 = P2_2_array(end);
P2_2_min = min(P2_2_array);
P2_2_max = max(P2_2_array);

% after reopening
P_3_array = P.Values.Data(open_time/0.0002 - 500 + 2: end);
P_3 = P_3_array(end);
P_3_max = max(P_3_array);

P1_3_array = P1.Values.Data(open_time/0.0002 - 500 + 2: end);
P1_3 = P1_3_array(end);
P1_3_max = max(P1_3_array);

P2_3_array = P2.Values.Data(open_time/0.0002 - 500 + 2: end);
P2_3 = P2_3_array(end);
P2_3_max = max(P2_3_array);

% SAVING THE RESULTS
resultArray(1).freq_1 = freq_1;
resultArray(1).freq_2 = freq_2;
resultArray(1).freq_2_min = freq_2_min;
resultArray(1).freq_3 = freq_3;
resultArray(1).freq_3_max = freq_3_max;
resultArray(1).tension_1 = tension_1;
resultArray(1).tension_2 = tension_2;
resultArray(1).tension_3 = tension_3;
resultArray(1).P_ref_1_1 = P_ref_1_1;
resultArray(1).P_ref_2_1 = P_ref_2_1;
resultArray(1).P_ref_1_2 = P_ref_1_2;
resultArray(1).P_ref_1_2_max = P_ref_1_2_max;
resultArray(1).P_ref_2_2 = P_ref_2_2;
resultArray(1).P_ref_2_2_max = P_ref_2_2_max;
resultArray(1).P_ref_1_3 = P_ref_1_3;
resultArray(1).P_ref_1_3_min = P_ref_1_3_min;
resultArray(1).P_ref_2_3 = P_ref_2_3;
resultArray(1).P_ref_2_3_min = P_ref_2_3_min;
resultArray(1).P_1 = P_1;
resultArray(1).P1_1 = P1_1;
resultArray(1).P2_1 = P2_1;
resultArray(1).P_2 = P_2;
resultArray(1).P_2_min = P_2_min;
resultArray(1).P_2_max = P_2_max;
resultArray(1).P1_2 = P1_2;
resultArray(1).P1_2_min = P1_2_min;
resultArray(1).P1_2_max = P1_2_max;
resultArray(1).P2_2 = P2_2;
resultArray(1).P2_2_min = P2_2_min;
resultArray(1).P2_2_max = P2_2_max;
resultArray(1).P_3 = P_3;
resultArray(1).P_3_max = P_3_max;
resultArray(1).P1_3 = P1_3;
resultArray(1).P1_3_max = P1_3_max;
resultArray(1).P2_3 = P2_3;
resultArray(1).P2_3_max = P2_3_max;

% TODO %
resultArray(1).P_machines = 0; 
resultArray(1).P_eol = 0;
resultArray(1).P_PV = 0;
resultArray(1).P_charge = 0;

plotSim(freq, P, P1, P2, tension, P_ref_1, P_ref_2);

save("results.mat", "resultArray");
msgbox("Done");


function plotM_1(P_ref, freq, machine)
    figure(machine)
    set(gcf,'name','Calibration Machine ' + string(machine));
    subplot(2,1,1);
    plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name + "First");
    title("Operating point");
    legend
    
    subplot(2,1,2);
    plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name + "First");
    title("Measured frequency");
    legend
end 

function plotM_2(P_ref, freq, machine)
    figure(machine)
    subplot(2,1,1);
    hold on
    plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name + "Second");
    hold off
    legend
    
    subplot(2,1,2);
    hold on
    plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name + "Second");
    hold off
    legend
end

function plotSim(freq, P, P1, P2, tension, P_ref_1, P_ref_2)
    % Graphs for debugging the simulation
    
    figure(3)
    set(gcf,'name','Simulation');
    subplot(2,2,1);
    plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
    title("Frequency (pu)");
    legend
    
    subplot(2,2,2);
    plot(P.Values.Time, P.Values.Data, 'DisplayName', P.Name);
    hold on
    plot(P1.Values.Time, P1.Values.Data, 'DisplayName', P1.Name);
    plot(P2.Values.Time, P2.Values.Data, 'DisplayName', P2.Name);
    title("Power measurements (W)");
    hold off
    legend
    
    subplot(2,2,3);
    plot(tension.Values.Time, tension.Values.Data, 'DisplayName', tension.Name);
    title("Tension measurements (pu)");
    legend
    
    subplot(2,2,4);
    plot(P_ref_1.Values.Time, P_ref_1.Values.Data, 'DisplayName', P_ref_1.Name);
    hold on
    plot(P_ref_2.Values.Time, P_ref_2.Values.Data, 'DisplayName', P_ref_2.Name);
    title("Power command (pu)");
    hold off
    legend
    
    % backuping in a file
    figure(1);
    saveas(gcf, 'figures/calibration/1_M1.png');
    
    figure(2);
    saveas(gcf, 'figures/calibration/1_M2.png');
    
    figure(3);
    saveas(gcf, 'figures/simulation/1.png');
end