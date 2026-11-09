clear;
clc;

% Number of engine cycles
N = 300;

% Crank angle
CA = -180:0.5:540;

% Store features and labels
features = zeros(N,4);
labels = strings(N,1);

rng(1);   % Reproducible random numbers

for i = 1:N

    % Randomly select operating condition
    r = rand;

    if r < 0.60
        condition = "Normal";
    elseif r < 0.80
        condition = "Knock";
    else
        condition = "Misfire";
    end

    % Small cycle-to-cycle variation
    peakVariation = 1 + 0.05*randn;

    % Base combustion pressure
    P = 1 + 8*peakVariation .* ...
        exp(-((CA)/35).^2);

    % Add condition-specific behavior

    if condition == "Knock"

        % Knock oscillations
        knockAmplitude = 1.5 + 0.5*rand;

        knock = knockAmplitude .* ...
            sin(2*pi*CA/5) .* ...
            exp(-((CA-15)/35).^2);

        P = P + knock;

    elseif condition == "Misfire"

        % Weak combustion
        P = 1 + 1.5*peakVariation .* ...
            exp(-((CA)/40).^2);
    end

    % Add small measurement noise
    P = P + 0.05*randn(size(P));

    % ---- Early-cycle region ----
    % Use pressure before the main combustion peak
    idx = CA >= -50 & CA <= 10;

    earlyP = P(idx);

    % Feature 1: maximum pressure in early region
    maxPressure = max(earlyP);

    % Feature 2: mean pressure
    meanPressure = mean(earlyP);

    % Feature 3: RMS pressure
    rmsPressure = rms(earlyP);

    % Feature 4: pressure variation
    pressureStd = std(earlyP);

    % Store features
    features(i,:) = [maxPressure ...
                     meanPressure ...
                     rmsPressure ...
                     pressureStd];

    % Store label
    labels(i) = condition;

end

% Create table
dataset = table( ...
    features(:,1), ...
    features(:,2), ...
    features(:,3), ...
    features(:,4), ...
    labels, ...
    'VariableNames', ...
    {'MaxPressure','MeanPressure','RMSPressure', ...
     'PressureStd','Condition'});

% Display first few rows
disp(dataset(1:10,:));

% Save dataset
writetable(dataset,'SI_Engine_Dataset.csv');

disp('Dataset created successfully!');