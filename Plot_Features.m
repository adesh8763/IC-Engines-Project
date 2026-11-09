clear;
clc;

% Load early sequence dataset
data = readtable('SI_Engine_Early_Sequence_Dataset.csv');

% Extract features
maxP = data.MaxPressure;
meanP = data.MeanPressure;
rmsP = data.RMSPressure;
stdP = data.PressureStd;

% Convert conditions to categorical
condition = categorical(data.Condition);

% Feature names
featureNames = {'Maximum Pressure', ...
    'Mean Pressure', ...
    'RMS Pressure', ...
    'Pressure Variation'};

features = {maxP, meanP, rmsP, stdP};

% Create four separate plots
for i = 1:4

    figure;

    boxchart(condition,features{i});

    xlabel('Engine Condition');
    ylabel(featureNames{i});

    title(['Feature: ' featureNames{i}]);

    grid on;

end