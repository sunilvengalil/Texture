function [ features ] = loadFeatures( fileName )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% fim1 = load(fileName);
% fim = fim1.fim;
% d = numel(fim);
% n = numel(fim{1});
% data = zeros(d,n);
% for i = 1:d,
%   data(i,:) = abs(fim{i}(:))';
% end

t = load(fileName);




features = t.data;

end

