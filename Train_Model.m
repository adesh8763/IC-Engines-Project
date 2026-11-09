clear;
clc;

% Load the dataset
data = readtable('SI_Engine_Dataset.csv');

% Input features
X = data{:,1:4};

% Output labels
Y = categorical(data.Condition);

% Split data into training and testing sets
cv = cvpartition(Y,'HoldOut',0.30);

XTrain = X(training(cv),:);
YTrain = Y(training(cv));

XTest = X(test(cv),:);
YTest = Y(test(cv));

% Train a Decision Tree classifier
model = fitctree(XTrain,YTrain);

% Predict the test data
YPred = predict(model,XTest);

% Calculate accuracy
accuracy = mean(YPred == YTest) * 100;

fprintf('Prediction Accuracy = %.2f%%\n',accuracy);

% Display confusion matrix
figure;
confusionchart(YTest,YPred);

title('Knock and Misfire Prediction');