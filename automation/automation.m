
Model = 'grid';
CalibrationModel = 'calibration'
run("params.m")
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

"Machine 1"

% first pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

% Second pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{freq_i};

figure(1)
plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name);
legend

figure(2)
plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
legend

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

% Now doing the same for the second machine
"Machine 2"
M1_backup = M1;
M1 = M2;
% first pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

% Second pass
simOut = sim(CalibrationModel);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{freq_i};

figure(1)
plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name);
legend

figure(2)
plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
legend

necessaryGain = P_ref.Values.Data(end)/M1.P0_pu
M1.base_torque = M1.base_torque * necessaryGain;

M2 = M1;
M1 = M1_backup;

%---------%
% now to the real simulation
%---------%
"Real simulation"

clear necessaryGain;

simOut = sim(Model);

% FREQUENCY
freq = simOut.logsout{4};
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
P_ref_1 = simOut.logsout{8};
P_ref_2 = simOut.logsout{10};
% imediately before closing 
P_ref_1_1 = P_ref_1.Values.Data(close_time/0.0002 - 500 );
P_ref_2_1 = P_ref_2.Values.Data(close_time/0.0002 - 500 );

% after closing
P_ref_1_2_array = P_ref_1.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P_ref_1_2 = P_ref_1_2_array(end);
P_ref_1_2_min = min(P_ref_1_2_array);

P_ref_2_2_array = P_ref_2.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P_ref_2_2 = P_ref_2_2_array(end);
P_ref_2_2_min = min(P_ref_2_2_array);

% after reopening
P_ref_1_3_array = P_ref_1.Values.Data(open_time/0.0002 - 500 + 2: end);
P_ref_1_3 = P_ref_1_3_array(end);
P_ref_1_3_max = max(P_ref_1_3_array);

P_ref_2_3_array = P_ref_2.Values.Data(open_time/0.0002 - 500 + 2: end);
P_ref_2_3 = P_ref_2_3_array(end);
P_ref_2_3_max = max(P_ref_2_3_array);

% POWER
P = simOut.logsout{3};
P1 = simOut.logsout{5};
P2 = simOut.logsout{6};
% imediately before closing 
P_1 = P.Values.Data(close_time/0.0002 - 500 );
P1_1 = P1.Values.Data(close_time/0.0002 - 500 );
P2_1 = P2.Values.Data(close_time/0.0002 - 500 );

% after closing
P_2_array = P.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P_2 = P_2_array(end);
P_2_min = min(P_2_array);

P1_2_array = P1.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P1_2 = P1_2_array(end);
P1_2_min = min(P1_2_array);

P2_2_array = P2.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
P2_2 = P2_2_array(end);
P2_2_min = min(P2_2_array);

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
