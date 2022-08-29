function results2 = MyCode()
function rng(x)
  randn("seed",x)
  rand("seed",x)
end

rng(1);
clear;
pkg load statistics;
pkg load optim;

rand(1)
data = csvread('F:\Git_Files\Customer Segmentation\data_for_snob.csv');
data = data(2:end,:);
data = data(:,2:end);
data2 = data;
size_data = size(data2,2);
result = snob(data2, {'norm',1:size_data});


results2 = result.r;
csvwrite('F:\Git_Files\Customer Segmentation\Probabilities.csv',results2);
end