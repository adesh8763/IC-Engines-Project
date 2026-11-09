% SI Engine synthetic combustion data

clear;
clc;

% Crank angle
CA = -180:0.5:540;

% Normal combustion pressure
P_base = 1 + 8*exp(-((CA-0)/35).^2);

% Knock oscillation
knock_signal = 2*sin(2*pi*CA/5).*exp(-((CA-20)/30).^2);

% Misfire pressure
P_misfire = 1 + 1.5*exp(-((CA-0)/40).^2);

% Normal
P_normal = P_base;

% Knock
P_knock = P_base + knock_signal;

% Misfire
P_misfire = P_misfire;

% Plot
figure;

plot(CA,P_normal,'LineWidth',1.5);
hold on;

plot(CA,P_knock,'LineWidth',1.2);

plot(CA,P_misfire,'LineWidth',1.2);

xlabel('Crank Angle (deg)');
ylabel('Cylinder Pressure (bar)');
legend('Normal','Knock','Misfire');
title('SI Engine Combustion Conditions');
grid on;

% Prepare data for Simulink
time = CA - CA(1);

normal_data = [time' P_normal'];
knock_data = [time' P_knock'];
misfire_data = [time' P_misfire'];