
Model = 'grid';
CalibrationModel = 'calibration'
run("params.m")
open(Model);
open(CalibrationModel);

p_ref_i = 11;
freq_i = 7;
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

P_ref = simOut.logsout{17};
freq = simOut.logsout{11};

figure(1)
plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name);
legend

figure(2)
plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
legend