
clc; clear; close all;

%% PARAMETROS
RL = 8;          % Impedancia da carga 
fc = 2500;       % Frequencia de corte 
wc = 2 * pi * fc; % Frequencia angular de corte

fprintf('--- Parâmetros de Projeto ---\n');
fprintf('Aluno: Luiz Eduardo Rufatto\n');
fprintf('RL (Impedância): %.0f Ohm\n', RL);
fprintf('fc (Corte): %.1f kHz (%.0f Hz)\n', fc/1000, fc);
fprintf('-----------------------------\n\n');

%% CALULO DOS VALORES IDEAIS

% Form para filtro Butterworth

L_ideal = (sqrt(2) * RL) / wc;
C_ideal = sqrt(2) / (wc * RL);

% Conv de unidades
L_ideal_mH = L_ideal * 1000;
C_ideal_uF = C_ideal * 1e6;

fprintf('--- Valores Ideais Calculados ---\n');
fprintf('L ideal: %.4f mH\n', L_ideal_mH);
fprintf('C ideal: %.2f uF\n', C_ideal_uF);
fprintf('---------------------------------\n\n');

%% COMPONENTES COMERCIAIS

% Tabela de indutores
L_comerciais_mH = [0.10, 0.12, 0.15, 0.18, 0.22, 0.27, 0.33, 0.39, 0.47, 0.56, ...
                   0.68, 0.82, 1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, ...
                   5.6, 6.8, 8.2, 10, 12, 15];

% Tabela de capacitores
C_comerciais_uF = [1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2, ...
                   10, 12, 15, 18, 22, 27, 33, 39, 47, 56, 68, 82, 100];

% Selecao pela menor diferenca

% Indutor
[~, idx_L] = min(abs(L_comerciais_mH - L_ideal_mH));
L_comercial_mH = L_comerciais_mH(idx_L);
L_comercial = L_comercial_mH / 1000; % Henry

% Capacitor
[~, idx_C] = min(abs(C_comerciais_uF - C_ideal_uF));
C_comercial_uF = C_comerciais_uF(idx_C);
C_comercial = C_comercial_uF / 1e6; % Farad

fprintf('--- Componentes Reais Selecionados ---\n');
fprintf('L comercial (mais próximo de %.4f mH): %.2f mH\n', L_ideal_mH, L_comercial_mH);
fprintf('C comercial (mais próximo de %.2f uF): %.2f uF\n', C_ideal_uF, C_comercial_uF);
fprintf('----------------------------------------\n\n');

%% FUNCOES DE TRANSFERENCIA

% Butterworth
Den_ideal = [1, sqrt(2)*wc, wc^2];
H_LPF_ideal = tf([0, 0, wc^2], Den_ideal);
H_HPF_ideal = tf([1, 0, 0], Den_ideal);

% Modelo Real
w0_real_sq = 1 / (L_comercial * C_comercial);

% LPF Real
Den_LPF_real = [1, 1/(RL*C_comercial), w0_real_sq];
H_LPF_real = tf([0, 0, w0_real_sq], Den_LPF_real);

% HPF Real
Den_HPF_real = [1, RL/L_comercial, w0_real_sq];
H_HPF_real = tf([1, 0, 0], Den_HPF_real);

%% GRAFICOS DE BODE

% frequecia para plotagem
freq_range = logspace(2, 4.3, 1000) * 2 * pi; 

% Grafico LPF // Woofer
figure(1);
hold on;
bode(H_LPF_ideal, freq_range, 'b');
bode(H_LPF_real, freq_range, 'r--');
grid on;
title('Resposta em Frequência - LPF (Woofer)');
legend('Ideal (2.5 kHz)', 'Real (Comercial)', 'Location', 'SouthWest');
hold off;

% Grafico HPF // Tweeter
figure(2);
hold on;
bode(H_HPF_ideal, freq_range, 'b');
bode(H_HPF_real, freq_range, 'r--');
grid on;
title('Resposta em Frequência - HPF (Tweeter)');
legend('Ideal (2.5 kHz)', 'Real (Comercial)', 'Location', 'SouthWest');
hold off;

%% Calculo pra exibir

% Freq de ressonancia real
f0_real = sqrt(w0_real_sq) / (2*pi);

% Diferencas percentuais
diff_fc = abs(f0_real - fc)/fc * 100;
diff_L = abs(L_comercial_mH - L_ideal_mH)/L_ideal_mH * 100;
diff_C = abs(C_comercial_uF - C_ideal_uF)/C_ideal_uF * 100;

% Amortecimento reais
zeta_LPF_real = (1/(RL*C_comercial)) / (2 * sqrt(w0_real_sq));
zeta_HPF_real = (RL/L_comercial) / (2 * sqrt(w0_real_sq));

fprintf('--- Análise Crítica ---\n');
fprintf('Frequência de Corte Real (f0): %.2f Hz\n', f0_real);
fprintf('Desvio da Frequência de Corte: %.2f%%\n', diff_fc);
fprintf('Erro no Indutor (L): %.2f%%\n', diff_L);
fprintf('Erro no Capacitor (C): %.2f%%\n', diff_C);
fprintf('Amortecimento LPF (Zeta): %.3f (Ideal 0.707)\n', zeta_LPF_real);
fprintf('Amortecimento HPF (Zeta): %.3f (Ideal 0.707)\n', zeta_HPF_real);
fprintf('---------------------------------------------\n');