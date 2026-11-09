clear;
clc;

% Number of engine cycles
N = 500;

% Crank angle
CA = -180:0.5:540;

% Store features and labels
features = zeros(N,4);
labels = strings(N,1);

rng(10);

% Start with normal operation
condition = "Normal";

for i = 1:N

    % Occasionally start an abnormal sequence
    if condition == "Normal"

        r = rand;

        if r < 0.08
            % Start a knock sequence
            condition = "Knock_Pre";
        elseif r < 0.16
            % Start a misfire sequence
            condition = "Misfire_Pre";
        end

    elseif condition == "Knock_Pre"

        % Precursor cycle followed by knock
        condition = "Knock";

    elseif condition == "Misfire_Pre"

        % Precursor cycle followed by misfire
        condition = "Misfire";

    elseif condition == "Knock"

        % Return to normal after knock
        condition = "Normal";

    elseif condition == "Misfire"

        % Return to normal after misfire
        condition = "Normal";
    end

    % Base combustion pressure
    peakVariation = 1 + 0.04*randn;

    P = 1 + 8*peakVariation .* ...
        exp(-((CA)/35).^2);

    % Knock precursor
    if condition == "Knock_Pre"

        precursor = 0.4*sin(2*pi*CA/8) .* ...
            exp(-((CA-10)/40).^2);

        P = P + precursor;

    % Knock
    elseif condition == "Knock"

        knockAmplitude = 1.5 + 0.5*rand;

        knock = knockAmplitude .* ...
            sin(2*pi*CA/5) .* ...
            exp(-((CA-15)/35).^2);

        P = P + knock;

    % Misfire precursor
    elseif condition == "Misfire_Pre"

        P = 1 + 5.5*peakVariation .* ...
            exp(-((CA)/40).^2);

    % Misfire
    elseif condition == "Misfire"

        P = 1 + 1.5*peakVariation .* ...
            exp(-((CA)/40).^2);
    end

    % Measurement noise
    P = P + 0.05*randn(size(P));

    % Early region
    idx = CA >= -50 & CA <= 10;

    earlyP = P(idx);

    % Extract features
    maxPressure = max(earlyP);
    meanPressure = mean(earlyP);
    rmsPressure = rms(earlyP);
    pressureStd = std(earlyP);

    features(i,:) = [maxPressure ...
                     meanPressure ...
                     rmsPressure ...
                     pressureStd];

    % Label
    labels(i) = condition;

end

% Display distribution
disp('Condition distribution:');
disp(tabulate(labels));

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

% Save
writetable(dataset,'SI_Engine_Early_Sequence_Dataset.csv');

disp('New early-prediction dataset created successfully!');