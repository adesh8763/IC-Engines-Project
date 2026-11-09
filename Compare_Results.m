clear;
clc;

% Accuracy results
baseline_accuracy = 95.56;
early_accuracy = 99.33;

% Model names
models = categorical({'Current-Cycle Classification', ...
    'Early Prediction'});

% Accuracy values
accuracy = [baseline_accuracy early_accuracy];

% Create bar chart
figure;

bar(models,accuracy);

ylabel('Accuracy (%)');
xlabel('Model');
title('Comparison of Model Performance');

ylim([0 100]);
grid on;

% Display values above bars
for i = 1:length(accuracy)
    text(models(i),accuracy(i)+2, ...
        sprintf('%.2f%%',accuracy(i)), ...
        'HorizontalAlignment','center');
end