clear;
clc;

% Load the early-prediction dataset
data = readtable('SI_Engine_Early_Sequence_Dataset.csv');

% Features
X = data{:,1:4};

% Conditions
conditions = string(data.Condition);

% Previous cycle -> next cycle
XTrainData = X(1:end-1,:);
YData = conditions(2:end);

% Convert precursor states to Normal
YData(YData == "Knock_Pre") = "Normal";
YData(YData == "Misfire_Pre") = "Normal";

YData = categorical(YData);

% Train the Decision Tree
rng(1);
model = fitctree(XTrainData,YData);

% Select one cycle for demonstration
cycleNumber = 100;

inputFeatures = XTrainData(cycleNumber,:);

% Predict next cycle
prediction = predict(model,inputFeatures);

% Display result
fprintf('\n=================================\n');
fprintf('   SI ENGINE EARLY PREDICTION\n');
fprintf('=================================\n');

fprintf('Previous Cycle Features:\n');
fprintf('Maximum Pressure : %.2f\n',inputFeatures(1));
fprintf('Mean Pressure    : %.2f\n',inputFeatures(2));
fprintf('RMS Pressure     : %.2f\n',inputFeatures(3));
fprintf('Pressure Std     : %.2f\n',inputFeatures(4));

fprintf('\nPredicted Next Cycle: %s\n',string(prediction));
fprintf('=================================\n');