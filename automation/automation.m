
Model = 'synchronous_machine_2021a';
run("params.m")
open(Model);

p_ref_i = 19;
freq_i = 11;
% The first run is meant to calibrate the necessary base torque of the
% machine for the specified power. An initial guess is made and the results
% are used to improve it. One iteration should be enough. The easiest way
% to have only one machine is to set both machines to be identical. I could
% have a secondary file only with a machine and a charge in an isolated
% grid.
close_time = 999;
open_time = 999;

M2_backup = M2;
M2 = M1;
simOut = sim(Model);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{freq_i};

figure(1)
plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name);
legend

figure(2)
plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
legend

necessaryGain = P_ref.Values.Data(end);
M1.base_torque = M1.base_torque * necessaryGain/M1.P0_pu;

% Now doing the same for the second machine

M2 = M2_backup;
M1_backup = M1;
M1 = M2;

simOut = sim(Model);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{11};

figure(1)
plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name);
legend

figure(2)
plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
legend

necessaryGain = P_ref.Values.Data(end);
M2.base_torque = M2.base_torque * necessaryGain/M2.P0_pu;



% now to the real simulation
M1 = M1_backup;

clear M1_backup;
clear M2_backup;
clear necessaryGain;

close_time = 40;
open_time = 80;
simOut = sim(Model);

P_ref = simOut.logsout{p_ref_i};
freq = simOut.logsout{11};

figure(1)
plot(P_ref.Values.Time, P_ref.Values.Data, 'DisplayName', P_ref.Name);
legend

figure(2)
plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
legend