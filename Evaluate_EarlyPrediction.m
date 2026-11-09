clear;
clc;

% Load dataset
data = readtable('SI_Engine_Early_Sequence_Dataset.csv');

% Features
features = data{:,1:4};

% Conditions
conditions = string(data.Condition);

% Previous cycle -> next cycle
X = features(1:end-1,:);
Y = conditions(2:end);

% Convert precursor labels to Normal
Y(Y == "Knock_Pre") = "Normal";
Y(Y == "Misfire_Pre") = "Normal";

Y = categorical(Y);

% Split data
rng(1);
cv = cvpartition(Y,'HoldOut',0.30);

XTrain = X(training(cv),:);
YTrain = Y(training(cv));

XTest = X(test(cv),:);
YTest = Y(test(cv));

% Train model
model = fitctree(XTrain,YTrain);

% Predict
YPred = predict(model,XTest);

% Confusion matrix
CM = confusionmat(YTest,YPred);

disp('Confusion Matrix:');
disp(CM);

% Accuracy
accuracy = mean(YPred == YTest) * 100;

fprintf('\nOverall Accuracy = %.2f%%\n',accuracy);

% Class-wise metrics
classes = categories(YTest);

for i = 1:length(classes)

    TP = CM(i,i);
    FN = sum(CM(i,:)) - TP;
    FP = sum(CM(:,i)) - TP;

    precision = TP / (TP + FP);
    recall = TP / (TP + FN);

    F1 = 2 * (precision * recall) / ...
        (precision + recall);

    fprintf('\n%s:\n',classes{i});
    fprintf('Precision = %.2f%%\n',precision*100);
    fprintf('Recall    = %.2f%%\n',recall*100);
    fprintf('F1 Score  = %.2f%%\n',F1*100);

end