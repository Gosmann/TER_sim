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

calibrationEnable = 0;
if calibrationEnable == 1
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

percantageArray = 40:10:40;
delta_f_array = 0.4:0.1:0.4;
%TODO: encontrar os indices adequados, fazer isso depois de integrar os
%paineis solares. 
for ren_percent = 0.4:0.1:0.4
    i = i + 1
    P_M = M1.P0 + M2.P0;
    if ren_percent == 0
        P_sol = Power_per_pannel;
        P_eol = 0;
        P_ren = P_sol;
    else 
        P_ren = P_M * ren_percent/ (1 - ren_percent);
        P_sol = Power_per_pannel * round(P_ren/ Power_per_pannel);
        P_eol = 0;%P_ren - P_sol;
    end
    Pn_L1 = M1.P0 + M2.P0 + P_sol; %P_ren; 
    P_nom_bat = Pn_L1 * 0.20;
    Pn_L2 = Pn_L1 * 0.01;
    
    simOut = sim(Model);
    
    % FREQUENCY
    freq = simOut.logsout{6};
    % after closing
    freq_2_array = freq.Values.Data(close_time/0.0002 - 500 + 2: open_time/0.0002 -500);

    % VOLTAGE
    tension = simOut.logsout{1};

    % POWER
    P = simOut.logsout{2};
    P1 = simOut.logsout{7};
    P2 = simOut.logsout{8};
    P_sol_array = simOut.logsout{5};
    P_eol_array = simOut.logsout{9};

    freq_1 = freq.Values.Data(close_time/0.0002 - 500 );
    freq_2 = freq_2_array(end);
    delta_f = freq_2 - freq_1;
    delta_f_array(i) = abs(delta_f);

    P1_pu_array = simOut.logsout{11};
    P2_pu_array = simOut.logsout{13};
    plotSim(freq, P1_pu_array, P2_pu_array, P, P1, P2, tension, ren_percent, P_sol_array, P_eol_array);
end

figure(5)
set(gcf,'name','Frequency deviation');
plot(percantageArray, delta_f_array, 'DisplayName', "delta_f", "LineWidth",3);
title("Frequency deviation in terms of the renewable percentage (pu)");
xlabel("Percentage of intermittent power sources [%]");
ylabel("Maximum frequency deviation [pu]")
legend

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

function plotSim(freq, P1_pu_array, P2_pu_array, P, P1, P2, tension, r, P_sol_array, P_eol_array)
    % Graphs for debugging the simulation
    figure(3)
    set(gcf,'name','Simulation');
    subplot(2,2,1);
    plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name, 'LineWidth', 3);
    xlim([10 40])
    xlabel('t [s]')
    ylabel("Instantenous frequency [pu]")
    title("Frequency [pu]");
    legend
    
    subplot(2,2,2);
    plot(P.Values.Time, P.Values.Data, 'DisplayName', P.Name, 'LineWidth', 3);
    hold on
    plot(P1.Values.Time, P1.Values.Data, 'DisplayName', P1.Name, 'LineWidth', 3);
    plot(P2.Values.Time, P2.Values.Data, 'DisplayName', P2.Name, 'LineWidth', 3);
    plot(P_sol_array.Values.Time, P_sol_array.Values.Data, 'DisplayName', P_sol_array.Name, 'LineWidth', 3);
    plot(P_eol_array.Values.Time, P_eol_array.Values.Data, 'DisplayName', P_eol_array.Name, 'LineWidth', 3);
    title("Power measurements (W)");
    xlim([10 40])
    xlabel('t [s]')
    ylabel('Power [W]')
    hold off
    legend
    
    subplot(2,2,3);
    plot(tension.Values.Time, tension.Values.Data, 'DisplayName', tension.Name, 'LineWidth', 3);
    title("Voltage measurements (pu)");
    xlim([10 40])
    xlabel('t [s]')
    ylabel('Voltage [pu]')
    legend
    
    subplot(2,2,4);
    plot(P1_pu_array.Values.Time, P1_pu_array.Values.Data, 'DisplayName', P1_pu_array.Name, 'LineWidth', 3);
    hold on
    plot(P2_pu_array.Values.Time, P2_pu_array.Values.Data, 'DisplayName', P2_pu_array.Name, 'LineWidth', 3);
    title("Synchronous machines' power [pu]");
    xlim([10 40])
    xlabel('t [s]')
    ylabel('Power [pu]')
    hold off
    legend
    
    %superposition of frequency graphs
    figure(4)
    set(gcf,'name','Frequency supeposition');
    plot(freq.Values.Time, freq.Values.Data, 'DisplayName', freq.Name + " (" + string(r*100) + "%)", 'LineWidth', 3);
    hold on
    title("Instant frequency for different intermittent percentages [pu]");
    xlim([10 40])
    xlabel('t [s]')
    ylabel('Frequency [pu]')
    legend

    % backuping in a file
    figure(1);
    saveas(gcf, 'figures/calibration/' +string(r) +'_M1.png');
    
    figure(2);
    saveas(gcf, 'figures/calibration/' +string(r) +'_M2.png');
    
    figure(3);
    saveas(gcf, 'figures/simulation/' +string(r) +'.png');
end