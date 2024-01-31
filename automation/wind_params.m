P_eol = 1e6;		    % puissance nominale de la machine
loss_factor = 0.98843573; % Measured on the output of the DC/AC converter
P_eol_base = 4.957548e5 * loss_factor;      % [W] max power at 10m/s
V_ref = ref_volt ;          % [V] line-line RMS reference voltage

w_zero = 0 ;

% *****************************************************************
% 			 	Paramètres turbine éolienne 
% *****************************************************************

% caractéristique générale

ro_air=1.22;

%load('wind6','wind_speed6')
%load('wind8','wind_speed8')
t_sim = 0:1:100;

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Détermination des caractéristiques de la pale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
R_pal=24;                                   % rayon de pale [m]
S_pal=pi*R_pal*R_pal;                       % surface balayée
  
cp_opt = 0.47;                              % coeficient cp optimal
lambda_opt = 9;                             % lambda pour lequel cp est optimal
%m_red = 92.6;                               % rapport de réduction
    
La = 2;        Lb = 0.4;     Lc = 0.02;    Ld = 90;       % La, ... Lh : coefficients 
Le = 0.115;    Lf = 0.18;    Lg = 5;       Lh = 8;        % caractéristique de la pales
    
  
% Puissance nominale
v_pal_nom = 75;
w_eol_nom = v_pal_nom/R_pal;                       % vitesse de rotation nominal
w_max = w_eol_nom;    

w_zero = 3.000 ;    

w_init_eol = 2;   

mult = 50;            
        
% Calcul des coefficients Cp=f(lambda, beta) et Cp/lambda = Cr = f(lambda, beta)
% pour les points caractéristiques définis dans les tableaux lambda_ref et beta_ref
% Ces coefficients sont utilisés dans un tableau à double entrée dans le
% modèle Simulink

    lambda_ref=[0  2  4  6  8  10  12 14];
    beta_ref = 0:1:50;
    j_ind = 0;
    
for beta = 0:1:50
    j_ind = j_ind +1;
   for i = 1:size(lambda_ref,2)
        temp(i) = 1/(Lb + lambda_ref(i)/La)-Lc;
        lambdaf = 1/temp(i);
        Cp_ref(i,j_ind) = Lf*(Ld/lambdaf-Le*beta^2-Lg)*exp(-Lh/lambdaf);
        
        
        if lambda_ref(i) == 0
                    Cr_ref(i,j_ind) = 0;  
        else
            Cr_ref(i,j_ind) = Cp_ref(i,j_ind)/lambda_ref(i);
   
        end
      
   end
   
end     
 
u_dc = 1500;

R_mcc = 11.2e-3;
L_mcc = 0.1e-3;
k_mcc=9;


w_mcc_nom = 1500*pi/30;

w_init = w_mcc_nom/2;
C_mcc_nom = P_eol/w_mcc_nom;
i_mcc_nom = C_mcc_nom/k_mcc;

 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Partie mécanique
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
H_mcc = 0.5;
H_eol = 4;
H_tot = H_mcc + H_eol;

J_eol = 2*H_tot*P_eol/w_eol_nom^2;


 
J_tot = 2*H_tot*P_eol/w_mcc_nom^2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generation de la consigne de couple pour la génératrice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_vent_tab= 4:0.1:w_eol_nom*R_pal/lambda_opt;

% on en deduit les vitesses de rotations optimales : 
omega_tab =  v_vent_tab*lambda_opt/R_pal;

% Détermination des consignes de puissance optimales
length_v = length(v_vent_tab);
 
 for j=1:1:length_v
    P_opt_tab2(j) = 1/2*ro_air*S_pal*cp_opt*(R_pal*omega_tab(j))^3/lambda_opt^3;
end

% On d?finit ensuite 2 points suppl?mentaires sur la caract?ristique de puissance de r?f?rence
% 1? point : w_nom, P_nom
P_opt_tab2(length_v+1) = P_eol;
omega_tab(length_v +1) = w_eol_nom;

% 2? point : w_nom*2, P_nom
P_opt_tab2(length_v+2) = P_eol;
omega_tab(length_v +2) = w_eol_nom*2;

P_lim_opt =  1/2*ro_air*S_pal*cp_opt*(R_pal*w_eol_nom*0.95)^3/lambda_opt^3;

Te = 1e-3;


% correcteur de courant MCC


   Tr_is = 20e-3;
   wn_i = 3/Tr_is;
   zeta_i = 0.7;
   
   Ti_is = 2*zeta_i/wn_i;
   
   Gain_i = L_mcc*wn_i^2*Ti_is;
   
 % 


