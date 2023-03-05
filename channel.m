%% settings
clear; clc;
k = 100;    % number of UEs
symbol_power = 23;    % dBm
bandwidth = 1e6;    % Hz
background_noise_PSD = -174;    % noise spectrum density -174dbm/Hz


%% fading preprocess
distance = 50+150*rand(k, 1);    % uniform distribution (m)
channel_PL = 128.1 + 37.6*log10(distance/1000);    % 128.1 + 37.6log10(d) dB
channel_PL = 10.^(-channel_PL/10);    % dB to power (db2pow)
% https://github.com/mengyuan-lee/learn-to-branch-d2d/blob/main/channel_fading_UE_to_BS.m
% https://github.com/mengyuan-lee/learn-to-branch-d2d/blob/3aa26c7cdecfb833769c148f8d05684c08da3494/Fun_chGain.m
% save('PL.mat', 'channel_PL', '-v7')
disp(mean(sqrt(channel_PL/2)))


%% awgn test 
% We test N0 = 10 with transmit signal [0, 2], the transmit power is 2
% clc
x = randi([0,1],1e6,1)*2;
x_power = mean(abs(x).^2);    % Watt
N0 = 20;
noise = sqrt(N0/2) * (randn(1e6, 1) + 1j*randn(1e6, 1));    % N0 = noise power in Watt
noise_power = mean(abs(noise).^2);    % Watt
fprintf("signal power: %.2f, noise power: %.2f.\n", x_power, noise_power)
fprintf("we can see that N0 = noise power.\n\n\n")

% awgn usage
% sig_pwr/n_pwr = 2 (linear) = 3 (dB)
[y, np] = awgn(x, 3, 'measured', 'db');    % return awgn corrupted signal and noise power
noise = y - x;
noise_power = mean(abs(noise).^2);    % Watt
fprintf("matlab awgn function noise power: %.2f.\nour test noise power: %.2f.\n", np, noise_power)
fprintf("ratio of signal and noise %.2f\n", x_power/np)
fprintf("signal power: %.2f dBm\n",10*log10(x_power)+30)    % dbm
fprintf("noise power: %.2f dBm\n",10*log10(noise_power)+30)    % dbm


%% N0 dbm and large scale fading usage
N0_dbm = background_noise_PSD - 30 + 10*log10(bandwidth);
% -30: dBm to dBW
% https://www.digikey.com.au/en/resources/conversion-calculators/conversion-calculator-dbm-to-watts
N0 = 10.^(N0_dbm/10);    % dBW to Watt
H = sqrt(channel_PL/2) * (randn + 1j*randn);    % large + small scale
noise = sqrt(N0/2) * (randn + 1j*randn);
% model: https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8320821

