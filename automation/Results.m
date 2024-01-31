classdef Results
   properties
        % FREQUENCY
        % imediately before closing 
        freq_1 {mustBeNumeric}
        
        % after closing
        freq_2 {mustBeNumeric}
        freq_2_min {mustBeNumeric}
        
        % after reopening
        freq_3 {mustBeNumeric}
        freq_3_max {mustBeNumeric}
        
        % VOLTAGE
        % imediately before closing 
        tension_1 {mustBeNumeric}
        
        % after closing
        tension_2 {mustBeNumeric}
        
        % after reopening
        tension_3 {mustBeNumeric}
        
        % P_ref_1 e 2
        % The control signal after the droop that sets the torque (pu)
        % imediately before closing 
        P_ref_1_1 {mustBeNumeric}
        P_ref_2_1 {mustBeNumeric}
        
        % after closing
        P_ref_1_2 {mustBeNumeric}
        P_ref_1_2_max {mustBeNumeric}
        
        P_ref_2_2 {mustBeNumeric}
        P_ref_2_2_max {mustBeNumeric}
        
        % after reopening
        P_ref_1_3 {mustBeNumeric}
        P_ref_1_3_min {mustBeNumeric}
        
        P_ref_2_3 {mustBeNumeric}
        P_ref_2_3_min {mustBeNumeric}
        
        % POWER
        % imediately before closing 
        P_1 {mustBeNumeric}
        P1_1 {mustBeNumeric}
        P2_1 {mustBeNumeric}
        
        % after closing
        P_2 {mustBeNumeric}
        P_2_min {mustBeNumeric}
        P_2_max {mustBeNumeric}
        
        P1_2 {mustBeNumeric}
        P1_2_min {mustBeNumeric}
        P1_2_max {mustBeNumeric}
        
        P2_2 {mustBeNumeric}
        P2_2_min {mustBeNumeric}
        P2_2_max {mustBeNumeric}
        
        % after reopening
        P_3 {mustBeNumeric}
        P_3_max {mustBeNumeric}
        
        P1_3 {mustBeNumeric}
        P1_3_max {mustBeNumeric}
        
        P2_3 {mustBeNumeric}
        P2_3_max {mustBeNumeric}

        % parametres
        P_machines {mustBeNumeric}
        P_eol {mustBeNumeric}
        P_PV {mustBeNumeric}
        P_charge {mustBeNumeric}
   end
end