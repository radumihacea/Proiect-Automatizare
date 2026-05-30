%%Proiect IRA 2
%%CALCULUL REGULATOARELOR PRIN METODA  REPARTIŢIEI 	POLI-ZEROURI
%%
clc;
clear all;
close all;
%% Def parte fixata Hf
s = tf('s');
K_f = 5.306;
T_ap = 0.01;
T_m1 = 0.074208;
T_m_star = 0.63104;
Hf = K_f / ( (T_ap*s + 1) * (T_m1*s + 1) * (T_m_star*s + 1) );

%% Definirea regulatorului Hr1 calculat
HR1 = 1.255 * ( (T_ap*s + 1) * (T_m1*s + 1) * (T_m_star*s + 1) ) / ( s * (0.124*s + 1) );

%% Sistem in bcla deschisa
H_deschis = minreal(HR1 * Hf);

%% Sistem bucla inchis
H_inchis = feedback(H_deschis, 1);

%% treapta unitara
figure;
step(H_inchis);
title('Treapta unitara');
xlabel('Timp');
ylabel('Amp');
grid on;

%% rampa unitara\
figure;
t = 0:0.01:5;             
r = t;                    
y = lsim(H_inchis, r, t); 
plot(t, r, '--r', 'LineWidth', 1.5); hold on;
plot(t, y, 'b', 'LineWidth', 1.5);
title('Rampa unitara');
xlabel('Timp');
ylabel('Amp');
grid on;

%% Parte 2 Trasare grafic răspunsul sistemului închis H02’ şi H02” 
%pentru intrare treapta si rampa in comp cu H02
%parte fixa
K_f = 5.306; T_ap = 0.01; T_m1 = 0.074208; T_m_star = 0.63104;
Hf = K_f / ( (T_ap*s + 1) * (T_m1*s + 1) * (T_m_star*s + 1) );

%% H02 calc
omega_n = 7.33; zeta = 0.55;
H02 = omega_n^2 / (s^2 + 2*zeta*omega_n*s + omega_n^2);

%% H02 prim
HR1_prim = 1.295 * (T_ap*s + 1)*(T_m_star*s + 1) / s;
H_deschis_prim = minreal(HR1_prim * Hf);
H02_prim = feedback(H_deschis_prim, 1);

%% H02 sec prim
HR1_secund = 1.255 * (T_m1*s + 1)*(0.64104*s + 1) / (s * (0.124*s + 1));
H_deschis_secund = minreal(HR1_secund * Hf);
H02_secund = feedback(H_deschis_secund, 1);

%% Rasp treapta
figure;
step(H02, 'b-', H02_prim, 'r--', H02_secund, 'g-.');
title('Raspunsul treapta');
xlabel('Timp'); ylabel('Amp');
grid on;

%% Rasp rampa
t = 0:0.01:5;
r = t; 
y_ideal = lsim(H02, r, t);
y_prim = lsim(H02_prim, r, t);
y_secund = lsim(H02_secund, r, t);

plot(t, r, 'k:', 'LineWidth', 1.5); hold on;
plot(t, y_ideal, 'b-', 'LineWidth', 1.5);
plot(t, y_prim, 'r--', 'LineWidth', 1.5);
plot(t, y_secund, 'g-.', 'LineWidth', 1.5);
title('Raspunsul la rampa');
xlabel('Timp'); ylabel('Amp');
grid on;


%% PARTEA 3 - Sistemul corectat cu Dipol (HR2)
clear; clc; close all;
s = tf('s');

%% Definirea partii fixate Hf(s)
K_f = 5.306;
T_ap = 0.01;
T_m1 = 0.074208;
T_m_star = 0.63104;
Hf = K_f / ( (T_ap*s + 1) * (T_m1*s + 1) * (T_m_star*s + 1) );

%% 2. Definirea noului regulator HR2(s) cu dipol
num_R2 = 19.78 * (s + 0.541) * (T_ap*s + 1) * (T_m1*s + 1) * (T_m_star*s + 1);
den_R2 = s * (s + 0.204) * (s + 14.164);
HR2 = num_R2 / den_R2;

%% 3. Sistemul in bucla deschisa si inchisa
H_deschis_2 = minreal(HR2 * Hf);
H_inchis_2 = feedback(H_deschis_2, 1);

%% 4. Raspunsul la Treapta
figure;
step(H_inchis_2);
title('Raspunsul la treapta unitara (HR2 cu dipol)');
xlabel('Timp'); ylabel('Amp');
grid on;

%% 5. Raspunsul la Rampa
figure;
t = 0:0.01:3;             
r = t;                    
y_rampa = lsim(H_inchis_2, r, t);

plot(t, r, '--r', 'LineWidth', 1.5); hold on;
plot(t, y_rampa, 'b', 'LineWidth', 1.5);
title('Raspunsul la rampa unitara (HR2 cu dipol)');
xlabel('Timp'); ylabel('Amp');
legend('Referinta', 'Raspuns sistem', 'Location', 'northwest');
grid on;

%% PARTEA 4 - Comparatie finala Corectie cu Dipol
clear; clc; close all;
s = tf('s');

%% 1. Partea Fixata (Hf)
Hf = 5.306 / ( (0.01*s + 1)*(0.074208*s + 1)*(0.63104*s + 1) );

%% 2. Regulatoarele (de la ideal la PID-ul final)
HR2 = 19.78 * (s + 0.541)*(0.01*s + 1)*(0.074208*s + 1)*(0.63104*s + 1) / (s*(s + 0.204)*(s + 14.164));
HR2_p = 1.396 * (s + 0.541)*(0.01*s + 1)*(0.074208*s + 1)*(0.56044*s + 1) / (s*(s + 0.204));
HR2_pp = 1.396 * (s + 0.541)*(0.074208*s + 1)*(0.57044*s + 1) / (s*(s + 0.204));
HR2_ppp = 3.702 * (0.074208*s + 1)*(0.57044*s + 1) / s;

%% 3. Calculul buclelor inchise
H0C = feedback(minreal(HR2 * Hf), 1);
H0C_p = feedback(minreal(HR2_p * Hf), 1);
H0C_pp = feedback(minreal(HR2_pp * Hf), 1);
H0C_ppp = feedback(minreal(HR2_ppp * Hf), 1);

%% Grafice

% 4. Grafic pentru Răspunsul la Treaptă
figure;
step(H0C, 'b-', H0C_p, 'r--', H0C_pp, 'g-.', H0C_ppp, 'm:');
title('Raspunsul indicial (Treapta) - Comparatie simplificari');
xlabel('Timp'); ylabel('Amp');
legend('H_{0C} (Corectat Ideal)', 'H_{0C}'' (Simplificare d.1)', ...
       'H_{0C}'''' (Simplificare d.2)', 'H_{0C}'''''' (PID Final)', 'Location', 'southeast');
grid on;

% 5. Grafic pentru Răspunsul la Rampă
figure;
t = 0:0.01:3;
r = t;
y = lsim(H0C, r, t);
y_p = lsim(H0C_p, r, t);
y_pp = lsim(H0C_pp, r, t);
y_ppp = lsim(H0C_ppp, r, t);

plot(t, r, 'k', 'LineWidth', 1.5); hold on;
plot(t, y, 'b-', 'LineWidth', 1.5);
plot(t, y_p, 'r--', 'LineWidth', 1.5);
plot(t, y_pp, 'g-.', 'LineWidth', 1.5);
plot(t, y_ppp, 'm:', 'LineWidth', 2);
title('Raspunsul la rampa unitara - Comparatie simplificari');
xlabel('Timp'); ylabel('Amp');
legend('Referinta', 'H_{0C} (Corectat Ideal)', 'H_{0C}'' (d.1)', ...
       'H_{0C}'''' (d.2)', 'H_{0C}'''''' (PID Final)', 'Location', 'northwest');
grid on;


%% Capitol 2 - Metoda Frecventiala (Regulator P)

clear; clc; close all;
s = tf('s');

%% 1 Definirea partii fixate simplificate 
Kf = 8.543;
Tf = 0.0842;
T  = 1.0161;

K_total = Kf / T;
H_fix = K_total / (s * (Tf*s + 1));

%% 2. Cautarea amplificarii Vr
[mag, phase, wout] = bode(H_fix, logspace(-1, 2, 5000));
phase = squeeze(phase); mag = squeeze(mag);

[~, idx] = min(abs(phase - (-118)));
wt = wout(idx);   
mag_wt = mag(idx);

Vr = 1 / mag_wt;
%Verificare conditie de viteza 
Cv_calculat = Vr * K_total;

fprintf('--- Rezultate calcul Regulator P ---\n');
fprintf('Pulsatia de taiere (wt) = %.4f rad/s\n', wt);
fprintf('Factorul de amplificare (Vr) = %.4f\n', Vr);
fprintf('Coeficientul la viteza (Cv) = %.4f (Trebuie sa fie > 5)\n', Cv_calculat);

%% 3 Sistemul in bucla deschisa cu Vr inclus
H_deschis = Vr * H_fix;

%% 4. Desenarea Diagramei Bode
figure('Name', 'Diagrama Bode - Regulator P');
margin(H_deschis);
grid on;


%% Grafic]
clear; clc; close all;
s = tf('s');
Kf = 8.543; Tf = 0.0842; T = 1.0161;

% Partea fixata necorectata
H_fix = (Kf/T) / (s*(Tf*s + 1));

% Generare diagrama de modul
figure('Name', 'Diagrama de modul H_f(s)', 'Position', [100 100 600 400]);
bodemag(H_fix);
grid on; hold on;

% Marcarea punctului F (Pulsatia de frangere)
wf = 11.87;
mag_wf = 20*log10(abs(evalfr(H_fix, j*wf)));
plot(wf, mag_wf, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
text(wf + 2, mag_wf + 5, 'Punctul F (\omega_f = 11.87)', 'FontSize', 11, 'Color', 'r');

%% 5. Sistemul in bucla inchisa cu Regulator P
H_inchis_P = feedback(H_fix, 1);

%% 6. Raspunsul la treapta unitara
figure('Name', 'Raspuns Treapta - Regulator P');
step(H_inchis_P);
title('Raspunsul la treapta unitara (Regulator P)');
xlabel('Timp [s]');
ylabel('Amplitudine');
grid on;

%% 7. Raspunsul la rampa unitara
figure('Name', 'Raspuns Rampa - Regulator P');
t = 0:0.01:5; 
r = t;
y_rampa_P = lsim(H_inchis_P, r, t);

plot(t, r, '--r', 'LineWidth', 1.5); hold on;
plot(t, y_rampa_P, 'b', 'LineWidth', 1.5);
title('Raspunsul la rampa unitara (Regulator P)');
xlabel('Timp [s]');
ylabel('Amplitudine');
legend('Referinta (Rampa)', 'Raspuns sistem cu Reg. P', 'Location', 'northwest');
grid on;

%% CAPITOL 2.3 - Regulator PI (Metoda Frecventiala)
clc; clear; close all;
s = tf('s');

%% 1. Partea fixata simplificata (din cap 2.1)
Kf = 8.543;
Tf = 0.0842;
T  = 1.0161;

H_fix = Kf / (T * s * (Tf*s + 1));   

%% 2. Parametrii regulatorului PI calculati
VR_PI = 0.955;       
Tz = 1.25;          
Tp = 1.748;         

% Functia de transfer a regulatorului PI
HR_PI = VR_PI * (Tz*s + 1) / (Tp*s + 1);  

%% 3. Sistemul in bucla deschisa si inchisa
H_deschis = HR_PI * H_fix;
H_inchis = feedback(H_deschis, 1);

%% 4. Verificare performante
info = stepinfo(H_inchis);
sigma = info.Overshoot;
tr = info.RiseTime;

% Coeficientul la viteza Cv
Cv = VR_PI * Kf * Tz / T;

% Latimea de banda
[~, ~, ~, wb] = margin(H_deschis);
delta_wb = wb;  

fprintf('--- Verificare Performante PI ---\n');
fprintf('Suprareglaj sigma = %.2f %% (impus <= 7.5%%)\n', sigma);
fprintf('Timp de raspuns tr = %.3f s (impus <= 1 s)\n', tr);
fprintf('Coeficient la viteza Cv = %.2f (impus >= 10)\n', Cv);
fprintf('Latime de banda = %.2f rad/s (impus <= 10)\n', delta_wb);

%% 5. Grafic: Raspuns la Treapta
figure('Name', 'Raspuns Treapta - Regulator PI');
step(H_inchis);
title('Raspunsul la treapta unitara (Regulator PI)');
xlabel('Timp [s]'); ylabel('Amplitudine');
grid on;

%% 6. Grafic: Raspuns la Rampa
figure('Name', 'Raspuns Rampa - Regulator PI');
t = 0:0.01:10;          
r = t;                   
y = lsim(H_inchis, r, t);

plot(t, r, '--r', 'LineWidth', 1.5); hold on;
plot(t, y, 'b', 'LineWidth', 1.5);
title('Raspunsul la rampa unitara (Regulator PI)');
xlabel('Timp [s]'); ylabel('Amplitudine');
legend('Referinta', 'Raspuns sistem', 'Location', 'southeast');
grid on;

%% 7. Diagrama Bode
figure('Name', 'Diagrama Bode - Regulator PI');
margin(H_deschis);
grid on;

%% CAPITOL 2.4 - Regulator PD (Metoda Frecventiala)
clc; clear; close all;
s = tf('s');

%% 1. Partea fixata simplificata (din cap 2.1)
Kf = 8.543;
Tf = 0.0842;
T  = 1.0161;

H_fix = Kf / (T * s * (Tf*s + 1));

%% 2. Parametrii regulatorului PD
VR_PD = 0.95;
tau_d = 0.125;
T_N = 0.0125;

% Functia de transfer a regulatorului PD
HR_PD = VR_PD * (tau_d*s + 1) / (T_N*s + 1);

%% 3. Sistemul in bucla deschisa si inchisa
H_deschis = HR_PD * H_fix;
H_inchis = feedback(H_deschis, 1);

%% 4. Verificare performante
info = stepinfo(H_inchis);
sigma = info.Overshoot;
tr = info.RiseTime;

% Coeficientul la viteza Cv
Cv = VR_PD * Kf / T;

% Latimea de banda
[~, ~, ~, wb] = margin(H_deschis);
delta_wb = wb;

fprintf('--- Verificare Performante PD ---\n');
fprintf('Suprareglaj sigma = %.2f %% (impus <= 10%%)\n', sigma);
fprintf('Timp de raspuns tr = %.3f s (impus <= 0.5 s)\n', tr);
fprintf('Coeficient la viteza Cv = %.2f (impus >= 5)\n', Cv);
fprintf('Latime de banda = %.2f rad/s (impus <= 10)\n', delta_wb);

%% 5. Grafic: Raspuns la Treapta
figure('Name', 'Raspuns Treapta - Regulator PD');
step(H_inchis);
title('Raspunsul la treapta unitara (Regulator PD)');
xlabel('Timp [s]');
ylabel('Amplitudine');
grid on;

%% 6. Grafic: Raspuns la Rampa
figure('Name', 'Raspuns Rampa - Regulator PD');
t = 0:0.01:5;
r = t;
y = lsim(H_inchis, r, t);

plot(t, r, '--r', 'LineWidth', 1.5); hold on;
plot(t, y, 'b', 'LineWidth', 1.5);
title('Raspunsul la rampa unitara (Regulator PD)');
xlabel('Timp [s]');
ylabel('Amplitudine');
legend('Referinta', 'Raspuns sistem', 'Location', 'southeast');
grid on;

%% 7. Diagrama Bode
figure('Name', 'Diagrama Bode - Regulator PD');
margin(H_deschis);
grid on;

%% CAPITOL 2.5 - Regulator PID - V6 
clc; clear; close all;
s = tf('s');

%% 1. Partea fixata simplificata
Kf = 8.543;
Tf = 0.0842;
T  = 1.0161;
H_fix = Kf / (T * s * (Tf*s + 1));

%% 2. Parametrii regulatorului PID 
VR_PID = 1.1;       

% Partea de PI
Tz = 1.45;           
Tp = 1.748;          

% Partea de PD
tau_d = 0.125;       
T_N = 0.0012;        

% Functia de transfer PID
HR_PID = VR_PID * (Tz*s + 1)/(Tp*s) * (tau_d*s + 1)/(T_N*s + 1);

%% 3. Sistemul in bucla deschisa si inchisa
H_deschis = HR_PID * H_fix;
H_inchis = feedback(H_deschis, 1);

%% 4. Verificare performante
info = stepinfo(H_inchis);
sigma = info.Overshoot;
tr = info.RiseTime;

Cv = VR_PID * Kf * Tz / (T * Tp);

[~, ~, ~, wb] = margin(H_deschis);
delta_wb = wb;

fprintf('============= Verificare Performante PID V6 =============\n');
fprintf('Suprareglaj sigma    = %.2f %%  (impus <= 7.5%%)\n', sigma);
fprintf('Timp de raspuns tr   = %.3f s   (impus <= 0.5 s)\n', tr);
fprintf('Coeficient viteza Cv = %.2f     (impus >= 12)\n', Cv);
fprintf('Latime de banda      = %.2f rad/s (impus <= 10)\n', delta_wb);
fprintf('===========================================================\n');

%% 5. Grafice
%% Raspuns treapta
figure('Name', 'Raspuns Treapta - Regulator PID V6');
step(H_inchis);
title('Raspunsul la treapta unitara (Regulator PID)');
xlabel('Timp'); ylabel('Amp');
grid on;

%% Raspuns Rampa unitara
figure('Name', 'Raspuns Rampa - Regulator PID V6');
t = 0:0.01:10;
r = t;
y = lsim(H_inchis, r, t);
plot(t, r, '--r', 'LineWidth', 1.5); hold on;
plot(t, y, 'b', 'LineWidth', 1.5);
title('Raspunsul la rampa unitara (Regulator PID)');
xlabel('Timp'); ylabel('Amp');
legend('Referinta', 'Raspuns sistem', 'Location', 'southeast');
grid on;

%% Diagrama Bode
figure('Name', 'Diagrama Bode - Regulator PID V6');
margin(H_deschis);
grid on;

%% CAPITOL 3 CALCULUL REGULATOARELOR PRIN METODE
% FRECVENŢIALE CU ASIGURAREA UNEI MARGINI DE FAZĂ IMPUSE

%% 3.2 Calculul parametrilor unui regulatori PI

% Parametrii partii fixate
K_f = 0.2242;
tau_c = 99.078;

% Definirea functiei de transfer cu timp mort
s = tf('s');
H_f = K_f / ((4*s + 1) * (660.52*s + 1) * (16*s + 1));
H_f.InputDelay = tau_c; % Adaugam timpul mort

% Setarea optiunilor pentru diagrama Bode (in rad/s)
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'rad/s';

% Trasarea diagramelor de modul si faza
figure;
bode(H_f, opts);
grid on;
title('Caracteristicile de modul si faza pentru partea fixata H_f(s)');

% Verificarea marginii de faza pe grafic
margin(H_f);

%% Calcule si diagrame Pentru partea fixata

% 1. Definirea variabilei complexe 's'
s = tf('s');

% 2. Parametrii partii fixate
K_f = 0.2242;
tau_c = 99.078;
H_f = K_f / ((4*s + 1) * (660.52*s + 1) * (16*s + 1));
H_f.InputDelay = tau_c; % Timpul mort

% 3. Parametrii regulatorului PI calculati
V_R = 19.45;
tau_i = 625;
H_R = V_R * (1 + 1/(tau_i * s));

% 4. Calculul partii directe Hd(s)
H_d = H_R * H_f;

% 5. Setari pentru afisare in rad/s
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'rad/s';

% 6. Trasarea diagramei Bode cu evidentierea marginilor
figure;
margin(H_d, opts);
grid on;
title('Caracteristicile de modul si faza pentru partea directa Hd(s)');

% 7. Afisarea valorilor exacte in Command Window
[Gm, Pm, Wcg, Wcp] = margin(H_d);
fprintf('Marginea de castig (mk) = %.2f dB\n', 20*log10(Gm));
fprintf('Marginea de faza (gamma_k) = %.2f grade\n', Pm);

%% 3.3Calcul pentru PD, diagrama de faza si de modul   

% Parametrii partii fixate
s = tf('s');
K_f = 0.2242;
tau_c = 99.078;
H_f = K_f / ((4*s + 1) * (660.52*s + 1) * (16*s + 1));
H_f.InputDelay = tau_c;

% Parametrii regulatorului PD calculati
beta = 0.1;
V_R = 13.57;
t_d = 224.3;
t_N = 22.43;

% Functiile de transfer pentru regulator si partea directa
H_R = V_R * (t_d*s + 1) / (t_N*s + 1);
H_d = H_R * H_f;

% Trasare diagrama Bode si afisare margini
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'rad/s';

figure;
margin(H_d, opts);
grid on;
title('Caracteristicile de modul si faza pentru sistemul compensat cu PD');

% Afisare valori exacte in consola
[Gm, Pm, Wcg, Wcp] = margin(H_d);
fprintf('Marginea de castig (mk) = %.2f dB\n', 20*log10(Gm));
fprintf('Marginea de faza (gamma_k) = %.2f grade\n', Pm);

%% 3.4 Calcul pentru PD, diagrama de faza si de modul 
clc;
clear all;
close all;
% Parametrii partii fixate
s = tf('s');
K_f = 0.2242;
tau_c = 99.078;
H_f = K_f / ((4*s + 1) * (660.52*s + 1) * (16*s + 1));
H_f.InputDelay = tau_c;

% Parametrii regulatorului PID calculati anterior
V_R = 9.78;
tau_i = 534.7;
tau_d = 222.8;
tau_N = 22.28;

% Functia de transfer a regulatorului PID
H_R_PI = (tau_i*s + 1) / (tau_i*s);
H_R_PD = (tau_d*s + 1) / (tau_N*s + 1);
H_R = V_R * H_R_PI * H_R_PD;

% Functia de transfer a buclei deschise
H_d = H_R * H_f;

% Setari si trasare diagrama Bode
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'rad/s';

figure;
margin(H_d, opts);
grid on;
title('Sistem compensat cu PID - Verificare Margini de Faza si Castig');

% Afisare rezultate in consola
[Gm, Pm, Wcg, Wcp] = margin(H_d);
fprintf('Marginea de castig (mk) = %.2f dB\n', 20*log10(Gm));
fprintf('Marginea de faza (gamma_k) = %.2f grade\n', Pm);

%% Capitol 4
clc;
clear all; 
close all;

%% Calculul regulatoarelor prin metoda modulului

s = tf('s');
H_0 = (10 * (0.01*s + 1)) / (0.0002*s^2 + 0.02*s + 1);

figure;
step(H_0);
grid on;
title('Raspunsul la treapta pentru \Omega_{TM}(t) - Metoda Modulului (PI)');
stepinfo(H_0)

%% Calculul regulatoarelor prin metoda simetriei
s = tf('s');
% Functia de transfer a sistemului in bucla inchisa H0(s)
H_0 = 10 * (0.04*s + 1) / (0.000008*s^3 + 0.0008*s^2 + 0.04*s + 1);

figure;
step(H_0);
grid on;
title('Raspunsul la treapta pt metoda Simetriei');

% Extragerea valorilor de performanta
info = stepinfo(H_0);
disp('--- Performante Reale ---');
fprintf('Suprareglaj real (sigma): %.1f %%\n', info.Overshoot);
fprintf('Timp de crestere (RiseTime): %.3f s\n', info.RiseTime);

%% CAPITOL 5 - Calculul regulatoarelor in cazul reglarii in cascada.
clc;
clear all;
close all;
%% --- PARAMETRII SISTEMULUI (Părții Fixate) ---
s = tf('s');

% Timpul mort estimat (modifică dacă ai altă valoare în proiect)
tau_m = 1; 

% Constante de timp [secunde]
tau_ap = 0.01; 
Tm1 = 0.0742; 
Tm_star = 0.631; 
Ttm_star = 4.99; 
T_star = 12 + tau_m; 

% Factori de amplificare
Kap = 23.026; 
K1 = 0.371; 
Km_star = 0.621; 
Ktm_star = 2.4104; 
K_star = 0.16;

%% --- FUNCȚIILE DE TRANSFER PARȚIALE ---
% Hf1: AP + Motor (partea electrică)
Hf1 = (Kap * K1) / ((tau_ap*s + 1) * (Tm1*s + 1));
% Hf2: Motor (partea mecanică)
Hf2 = Km_star / (Tm_star*s + 1);
% Hf3: Transportoarele + Doza gravimetrică
Hf3 = (Ktm_star * K_star) / ((Ttm_star*s + 1) * (T_star*s + 1));

% Partea fixată totală (pentru monobuclă)
Hf_total = Hf1 * Hf2 * Hf3;

%% --- 1. REGLAREA ÎN CASCADĂ ---
% A. Regulatorul Buclei Interioare (Turație) - PID / Modul
V_R_omega = 1 / 0.1061; % Aprox 9.425
H_R_omega = V_R_omega * (1 + Tm1*s) * (1 + Tm_star*s) / s;

% B. Regulatorul Buclei Exterioare (Debit) - PI / Modul
V_RQ = T_star / 3.864;
tau_iQ = T_star;
H_RQ = V_RQ * (1 + 1/(tau_iQ * s));

%% --- 2. REGLAREA MONOBUCLĂ ---
% Regulatorul PI calculat prin metoda frecvențială (margine fază > 45 grade)
V_R_mono = 1.93;
tau_i_mono = 20;
H_R_mono = V_R_mono * (1 + 1/(tau_i_mono * s));

%% --- 3. ANALIZA LA PERTURBAȚIE (Mr) ---
% Vrem să vedem efectul perturbației Mr (cuplu rezistent) asupra turației (U_omega)

% Funcția de transfer de la Mr la U_omega (Reglare Cascadă - doar bucla internă)
U_omega_cascada = Hf2 / (1 + H_R_omega * Hf1 * Hf2);

% Funcția de transfer de la Mr la U_omega (Reglare Monobuclă)
U_omega_mono = Hf2 / (1 + H_R_mono * Hf_total);

% Setări pentru simulare
t_sim = 0:0.01:5;
Mr_amplitude = 0.1; % Amplitudinea treptei

figure(1);
% Înmulțim funcția de transfer direct cu amplitudinea treptei
step(U_omega_mono * Mr_amplitude, t_sim);
hold on;
step(U_omega_cascada * Mr_amplitude, t_sim);
grid on;
title('Efectul perturbației M_r = 0.1 asupra turației (U_\Omega)');
legend('Sistem Monobuclă (Regulator PI lent)', 'Sistem în Cascadă (Buclă internă rapidă)', 'Location', 'best');
xlabel('Timp [secunde]');
ylabel('Amplitudine U_\Omega [V]');

%% 5.3 Calculul regulatorului sistemului de reglare a temperaturii
clc;
clear all;
close all
%% --- 1. PARAMETRII BUCLEI INTERIOARE ---
s = tf('s');

tau_c = 99.078;
Tf = 680.52;
Kf = 0.5605;

% Parametrii Z-N pentru bucla interioara
VRC = 0.2338;
tau_ic = 326.96;

% Forma polinomiala a lui H_oc(s)
num_oc = VRC * Kf * (1 + 2.3 * tau_c * s);
den_oc = 3.3 * tau_c * s * (1 + Tf * s) * (tau_c * s + 1) + num_oc;
H_oc = num_oc / den_oc;

% --- Determinarea polilor ---
p = pole(H_oc);
fprintf('--- DATE PENTRU DOCUMENTATIE ---\n');
fprintf('p1 = %.6f\n', p(1));
fprintf('p2 = %.6f\n', p(2));
fprintf('p3 = %.6f\n', p(3));

%% --- 2. SIMPLIFICAREA FUNCTIEI ECHIVALENTE ---
% Calculul sumei constantelor de timp (T1 + T2 + T3) = suma(1 / abs(p))
sum_T = sum(1 ./ abs(p));
Toc = sum_T - 2.3 * tau_c;
fprintf('\nTimpul constant simplificat Toc = %.2f [s]\n', Toc);

% Functia simplificata Hoc_prim
H_oc_prim = 1 / (Toc * s + 1);

%% --- 3. PROIECTAREA REGULATORULUI EXTERN (H_Rm) ---
K_thetaT_star = 8;
T_thetaT_star = 108.208;
tau_T = 6.2104;

% Partea fixata pentru bucla exterioara
H_f_ext = H_oc_prim * (K_thetaT_star / (T_thetaT_star * s + 1));
H_f_ext.InputDelay = tau_T;

% Cautam valoarea VR_max care aduce sistemul la limita de stabilitate
[VR_max, Pm, Wcg, Wcp] = margin(H_f_ext);
T0 = 2 * pi / Wcg;

fprintf('\nPentru aducerea la limita de stabilitate:\n');
fprintf('VR_max = %.4f\n', VR_max);
fprintf('Perioada oscilatiilor T0 = %.2f [s]\n', T0);

% Parametrii regulatorului extern PID conform Ziegler-Nichols
VRE = 0.6 * VR_max;
tau_iE = 0.5 * T0;
tau_dE = 0.125 * T0;

fprintf('\nParametrii finali ai regulatorului EXTERN (PID):\n');
fprintf('VRE = %.4f\n', VRE);
fprintf('tau_iE = %.2f [s]\n', tau_iE);
fprintf('tau_dE = %.2f [s]\n', tau_dE);

%% --- 4. VERIFICAREA REZULTATELOR ---
% Regulatorul extern PID
H_Rm = VRE * (1 + 1/(tau_iE * s) + tau_dE * s);

% Functia de transfer in bucla inchisa totala
H_inchis_total = feedback(H_Rm * H_f_ext, 1);

% Simulare raspuns la treapta
t_sim = 0:1:5000;
figure;
step(H_inchis_total, t_sim);
grid on;
title('Raspunsul la treapta - Reglare Temperatura in Cascada');
xlabel('Timp [s]');
ylabel('Amplitudine \theta_m');

%% Capitol 6 - Calculul unui regulator cu predictie
clc;
clear all;
close all;
%% --- PARAMETRII SISTEMULUI ---
s = tf('s');

% Seteaza valoarea timpului mort (o presupunem 1 secunda pentru rulare)
tau_m = 1; 
T_min = 5.01;

%% --- 1. METODA PREDICȚIEI (SMITH PREDICTOR) ---
% Functia de transfer in circuit inchis cu predictor (H0)
H0 = 1 / (2 * T_min * s + 1)^2;
H0.InputDelay = tau_m; % Adaugam timpul mort

%% --- 2. REGULATOR PI CLASIC ---
% Partea fixata Hf(s)
Hf = 0.3857 / ((0.02*s + 1) * (4.99*s + 1) * (12*s + 1));
Hf.InputDelay = tau_m;

% Proiectarea unui PI cu marginea de faza > 60 grade
opts = pidtuneOptions('PhaseMargin', 65);
C_pi = pidtune(Hf, 'PI', opts);

% Extragem parametrii PI pentru a-i nota in proiect
VR_pi = C_pi.Kp;
tau_i_pi = C_pi.Kp / C_pi.Ki;
fprintf('--- Parametri Regulator PI clasic (Margine Faza > 60) ---\n');
fprintf('VR = %.2f\n', VR_pi);
fprintf('tau_i = %.2f [s]\n', tau_i_pi);

% Functia in bucla inchisa cu PI-ul clasic
H_inchis_PI = feedback(C_pi * Hf, 1);

%% --- 3. SIMULARE ȘI COMPARAȚIE ---
t_sim = 0:0.1:100; % Timpul de simulare (100 secunde)

figure;
step(H0, t_sim);
hold on;
step(H_inchis_PI, t_sim);
grid on;

% Estetica graficului
title('Comparatie Răspuns la Treaptă: Predictor Smith vs PI Clasic');
legend('Predictor Smith (H_0)', 'Regulator PI clasic (\gamma_k > 60^\circ)', 'Location', 'best');
xlabel('Timp [s]');
ylabel('Amplitudine Debit');
