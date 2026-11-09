clear;
clc;

% Load the new sequence dataset
data = readtable('SI_Engine_Early_Sequence_Dataset.csv');

% Features from current cycle
features = data{:,1:4};

% Current cycle conditions
conditions = string(data.Condition);

% ------------------------------------------------
% Target:
% Predict the NEXT cycle's actual condition
% ------------------------------------------------

% Use cycles 1 to N-1 as inputs
X = features(1:end-1,:);

% Next cycle condition is the target
nextCondition = conditions(2:end);

% Convert precursor states into their final events
Y = nextCondition;

% Change any precursor labels in the target
% into Normal, Knock or Misfire
Y(Y == "Knock_Pre") = "Normal";
Y(Y == "Misfire_Pre") = "Normal";

% Convert to categorical
Y = categorical(Y);

% ------------------------------------------------
% Split data into training and testing
% ------------------------------------------------

cv = cvpartition(Y,'HoldOut',0.30);

XTrain = X(training(cv),:);
YTrain = Y(training(cv));

XTest = X(test(cv),:);
YTest = Y(test(cv));

% ------------------------------------------------
% Train Decision Tree
% ------------------------------------------------

model_early = fitctree(XTrain,YTrain);

% Predict next cycle
YPred = predict(model_early,XTest);

% ------------------------------------------------
% Accuracy
% ------------------------------------------------

accuracy = mean(YPred == YTest) * 100;

fprintf('\nEarly Prediction Accuracy = %.2f%%\n',accuracy);

% ------------------------------------------------
% Confusion Matrix
% ------------------------------------------------

figure;

confusionchart(YTest,YPred);

title('Early Prediction of Knock and Misfire');
