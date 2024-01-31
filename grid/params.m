run("Machine.m")

run("params_solar.m")

run("wind_params.m")

run("synch_params.m")

% GLOBAL
ref_freq = 50.0 ;    % Hz
ref_volt = 4160 ;     % V      

P_nom_MS = 8.0e6 ;
M1.Pn = P_nom_MS * 0.6 ;
M2.Pn = P_nom_MS * 0.4 ;

P_nom_solar = 1e-3;

P_nom_wind = 1.0e6;		    % puissance nominale de la machine

%
M1.P0_pu = 0.5;
M1.P0 = M1.Pn * M1.P0_pu;

M2.P0_pu = 0.5;
M2.P0 = M2.Pn * M2.P0_pu;


