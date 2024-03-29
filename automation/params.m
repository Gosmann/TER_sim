run("Machine.m")
%%% synchronous generator
ref_freq = 50.0 ;    % Hz
ref_volt = 4160 ;     % V      

% MACHINE 1
    M1 = Machine;
    % mechanics
    M1.pole_pairs = 4;               
    M1.J = 30e3;
    M1.damping = 0.01;
    M1.base_torque = 7.772812264089572e+04;

    % power
    M1.Pn = 6e6;
    M1.P0_pu = 0.7;
    M1.P0 = M1.Pn * M1.P0_pu;

    M1.droopP1 = 0.03;
    % Voltage control
    M1.Kp_V = 100;
    M1.Ki_V = 10;
    M1.droopV1 = 0.01;
    % Machine
    M1.field_In = 50;
    M1.Ra = 0.011;
    M1.Xi = 0.15;
    M1.Xd = 1.05;
    M1.Xq = 0.7;
    M1.Xd_l = 0.35;
    M1.Xd_ll = 0.25;
    M1.Xq_ll = 0.325;

    M1.Td0_l = 5.25;
    M1.Td0_ll = 0.03;
    M1.Tq0_ll = 0.05;

% MACHINE 2
    M2 = Machine;
    % mechanics
    M2.pole_pairs = 4;               
    M2.J = 10e3;
    M2.damping = 0.015;
    M2.base_torque = 5.208487924073615e+04;
    % power
    M2.Pn = 4e6;
    M2.P0_pu = 0.8;
    M2.P0 = M2.Pn * M2.P0_pu;

    M2.droopP1 = 0.05;
    % Voltage control
    M2.Kp_V = 100;
    M2.Ki_V = 10;
    M2.droopV1 = 0.01;
    % Machine
    M2.field_In = 55;
    M2.Ra = 0.012;
    M2.Xi = 0.14;
    M2.Xd = 1.01;
    M2.Xq = 0.8;
    M2.Xd_l = 0.37;
    M2.Xd_ll = 0.27;
    M2.Xq_ll = 0.323;

    M2.Td0_l = 5.35;
    M2.Td0_ll = 0.035;
    M2.Tq0_ll = 0.045;

%%% Load

close_time = 20;
open_time = 30;



%%% power division

%fig = uifigure;
%sld = uislider(fig);
%sld.Limits = [0 100];

