Simulink.sdi.clear;
clear
run("params.m");
run("Results.m");
run("wind_params.m");
run("params_solar.m");

% The object where we save the Results
numberOfSimulations = 121; % TODO
resultArray(numberOfSimulations) = Results;

Model = 'grid';
CalibrationModel = 'calibration'
open(Model);


p_ref_i = 3;
freq_i = 2;
% The first run is meant to calibrate the necessary base torque of the
% machine for the specified power. An initial guess is made and the results
% are used to improve it. One iteration should be enough. The easiest way
% to have only one machine is to set both machines to be identical. I could
% have a secondary file only with a machine and a charge in an isolated
% grid.

calibration = 0;
if calibration == 1
    "Machine 1"                
    % first pass
    open(CalibrationModel);
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
end

%-------------------------------------------------------------------------%
%- - - - - - - - - - - - now to the real simulation - - - - - - - - - - - %             
%-------------------------------------------------------------------------%
"Real simulation" %#ok<*NOPTS>
i = 0;

percantageArray = 0:0.1:0.3 ;
delta_f_array = 0:0.1:0.3;
%TODO: encontrar os indices adequados, fazer isso depois de integrar os
%paineis solares. 
for ren_percent = 0:0.1:0.3
    i = i + 1
    P_M = M1.P0 + M2.P0;
    if ren_percent == 0
        P_sol = Power_per_pannel;
        P_eol = 0;
        P_ren = P_sol;
    else 
        P_ren = P_M * ren_percent/ (1 - ren_percent);
        P_sol = Power_per_pannel * round((0.5 * P_ren)/ Power_per_pannel)
        P_eol = P_ren - P_sol
    end
    Pn_L1 = M1.P0 + M2.P0 + P_ren; 
    Pn_L2 = Pn_L1 * 0.01;
    
    simOut = sim(Model);
    
    % FREQUENCY
    freq = simOut.logsout{6};
    % after closing
    freq_2_array = freq.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
    % after reopening
    freq_3_array = freq.Values.Data(open_time/0.0002 - 500 + 2: end);

    % VOLTAGE
    tension = simOut.logsout{1};

    % P_ref_1 e 2
    % The control signal after the droop that sets the torque (pu)
    P_ref_1 = simOut.logsout{11};
    P_ref_2 = simOut.logsout{12};
    % after closing
    P_ref_1_2_array = P_ref_1.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
    P_ref_2_2_array = P_ref_2.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
    % after reopening
    P_ref_1_3_array = P_ref_1.Values.Data(open_time/0.0002 - 500 + 2: end);
    P_ref_2_3_array = P_ref_2.Values.Data(open_time/0.0002 - 500 + 2: end);

    % POWER
    P = simOut.logsout{2};
    P1 = simOut.logsout{7};
    P2 = simOut.logsout{8};
    P_sol_array = simOut.logsout{5};
    P_eol_array = simOut.logsout{9};

    % after closing
    P_2_array = P.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);    
    P1_2_array = P1.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);
    P2_2_array = P2.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);


    % after reopening
    P_3_array = P.Values.Data(open_time/0.0002 - 500 + 2: end);
    P1_3_array = P1.Values.Data(open_time/0.0002 - 500 + 2: end);    
    P2_3_array = P2.Values.Data(open_time/0.0002 - 500 + 2: end);

    freq_1 = freq.Values.Data(close_time/0.0002 - 500 );
    freq_2 = freq_2_array(end);
    delta_f = freq_2 - freq_1;
    delta_f_array(i) = abs(delta_f);

    % SAVING THE RESULTS
    resultArray(i).freq_1 = freq_1;
    resultArray(i).freq_2 = freq_2;
    resultArray(i).freq_3 = freq_3_array(end);

    resultArray(i).freq_2_min = min(freq_2_array);
    resultArray(i).freq_3_max = max(freq_3_array);

    resultArray(i).tension_1 = tension.Values.Data(close_time/0.0002 - 500 );
    resultArray(i).tension_2 = tension.Values.Data(open_time/0.0002 -500);
    resultArray(i).tension_3 = tension.Values.Data(end);

    resultArray(i).P_ref_1_1 = P_ref_1.Values.Data(close_time/0.0002 - 500 );
    resultArray(i).P_ref_2_1 = P_ref_2.Values.Data(close_time/0.0002 - 500 );
    resultArray(i).P_ref_1_2 = P_ref_1_2_array(end);
    resultArray(i).P_ref_2_2 = P_ref_2_2_array(end);
    resultArray(i).P_ref_1_3 = P_ref_1_3_array(end);
    resultArray(i).P_ref_2_3 = P_ref_2_3_array(end);

    resultArray(i).P_ref_1_2_max = max(P_ref_1_2_array);
    resultArray(i).P_ref_2_2_max = max(P_ref_2_2_array);
    resultArray(i).P_ref_1_3_min = min(P_ref_1_3_array);
    resultArray(i).P_ref_2_3_min = min(P_ref_2_3_array);

    resultArray(i).P_1 = P.Values.Data(close_time/0.0002 - 500 );
    resultArray(i).P1_1 = P1.Values.Data(close_time/0.0002 - 500 );
    resultArray(i).P2_1 = P2.Values.Data(close_time/0.0002 - 500 );
    resultArray(i).P_2 = P_2_array(end);
    resultArray(i).P1_2 = P1_2_array(end);
    resultArray(i).P2_2 = P2_2_array(end);
    resultArray(i).P_3 = P_3_array(end);
    resultArray(i).P1_3 = P1_3_array(end);
    resultArray(i).P2_3 = P2_3_array(end);

    resultArray(i).P_2_min = min(P_2_array);
    resultArray(i).P_2_max = max(P_2_array);
    resultArray(i).P1_2_min = min(P1_2_array);
    resultArray(i).P1_2_max = max(P1_2_array);
    resultArray(i).P2_2_min = min(P2_2_array);
    resultArray(i).P2_2_max = max(P2_2_array);
    resultArray(i).P_3_max = max(P_3_array);
    resultArray(i).P1_3_max = max(P1_3_array);
    resultArray(i).P2_3_max = max(P2_3_array);

    resultArray(i).P_machines = P_M; 
    resultArray(i).P_eol = P_eol;
    resultArray(i).P_PV = 0;
    resultArray(i).P_charge = Pn_L1;
    resultArray(1).ren_percent = ren_percent;

    plotSim(freq, P, P1, P2, tension, P_ref_1, P_ref_2, ren_percent, P_sol_array, P_eol_array);
end

figure(5)
set(gcf,'name','Frequency deviation');
plot(percantageArray, delta_f_array, 'DisplayName', "delta_f");
title("Frequency deviation in terms of the renewable percentage (pu)");
legend

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

function plotSim(freq, P, P1, P2, tension, P_ref_1, P_ref_2, r, P_sol_array, P_eol_array)
    % Graphs for debugging the simulation
    figure(3)
    set(gcf,'name','Simulation');
    subplot(2,2,1);
    plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name);
    xlim([10 40])
    title("Frequency (pu)");
    legend
    
    subplot(2,2,2);
    plot(P.Values.Time, P.Values.Data, 'DisplayName', P.Name);
    hold on
    plot(P1.Values.Time, P1.Values.Data, 'DisplayName', P1.Name);
    plot(P2.Values.Time, P2.Values.Data, 'DisplayName', P2.Name);
    plot(P_sol_array.Values.Time, P_sol_array.Values.Data, 'DisplayName', P_sol_array.Name);
    plot(P_eol_array.Values.Time, P_eol_array.Values.Data, 'DisplayName', P_eol_array.Name);
    title("Power measurements (W)");
    xlim([10 40])
    hold off
    legend
    
    subplot(2,2,3);
    plot(tension.Values.Time, tension.Values.Data, 'DisplayName', tension.Name);
    title("Tension measurements (pu)");
    xlim([10 40])
    legend
    
    subplot(2,2,4);
    plot(P_ref_1.Values.Time, P_ref_1.Values.Data, 'DisplayName', P_ref_1.Name);
    hold on
    plot(P_ref_2.Values.Time, P_ref_2.Values.Data, 'DisplayName', P_ref_2.Name);
    title("Power command (pu)");
    xlim([10 40])
    hold off
    legend
    
    %superposition of frequency graphs
    figure(4)
    set(gcf,'name','Frequency supeposition');
    plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name + " (" + string(r) + ")");
    hold on
    title("Instant frequency for different intermittent percentages (pu)");
    xlim([10 40])
    legend

    % backuping in a file
    figure(1);
    saveas(gcf, 'figures/calibration/' +string(r) +'_M1.png');
    
    figure(2);
    saveas(gcf, 'figures/calibration/' +string(r) +'_M2.png');
    
    figure(3);
    saveas(gcf, 'figures/simulation/' +string(r) +'.png');
end