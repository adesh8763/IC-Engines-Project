clear;
clc;

% Crank angle
CA = -180:0.5:540;

% Normal combustion
P_normal = 1 + 8*exp(-((CA)/35).^2);

% Knock combustion
knock_signal = 2*sin(2*pi*CA/5).* ...
    exp(-((CA-20)/30).^2);

P_knock = P_normal + knock_signal;

% Misfire combustion
P_misfire = 1 + 1.5*exp(-((CA)/40).^2);

% Plot
figure;

plot(CA,P_normal,'LineWidth',1.5);
hold on;

plot(CA,P_knock,'LineWidth',1.5);

plot(CA,P_misfire,'LineWidth',1.5);

xlabel('Crank Angle (degrees)');
ylabel('Cylinder Pressure (bar)');

legend('Normal','Knock','Misfire');

title('Synthetic SI Engine Combustion Conditions');

grid on;