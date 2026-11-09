CA = -180:0.5:540;

% Normal combustion
P_normal = 1 + 8*exp(-((CA)/35).^2);

% Knock combustion
knock_signal = 2*sin(2*pi*CA/5).* ...
    exp(-((CA-20)/30).^2);
P_knock = P_normal + knock_signal;

% Misfire combustion
P_misfire = 1 + 1.5*exp(-((CA)/40).^2);

% Time vector
time = CA - CA(1);

% Data for Simulink
normal_data = [time' P_normal'];
knock_data = [time' P_knock'];
misfire_data = [time' P_misfire'];