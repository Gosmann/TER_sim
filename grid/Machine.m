classdef Machine
   properties
       % mechanics
        pole_pairs {mustBeInteger} = 4               
        J {mustBePositive}
        damping {mustBePositive}
        base_torque {mustBePositive}

        % power
        Pn {mustBePositive} % Nominal power {VA}
        P0_pu {mustBePositive} % Initial power in pu
        P0 {mustBePositive} % initial power in VA

        % Torque Actuator control 
        % tau {mustBePositive}
        % Kp {mustBePositive}
        % Ki {mustBeNonnegative}
        droopP1 {mustBePositive}

        % Voltage control
        Kp_V {mustBePositive}
        Ki_V {mustBeNonnegative}
        droopV1 {mustBePositive}

        % Machine
        field_In {mustBePositive}
        Ra {mustBePositive}
        Xi {mustBePositive}
        Xd {mustBePositive}
        Xq {mustBePositive}
        Xd_l {mustBePositive}
        Xd_ll {mustBePositive}
        Xq_ll {mustBePositive}

        Td0_l {mustBePositive}
        Td0_ll {mustBePositive}
        Tq0_ll {mustBePositive}
        

   end
end