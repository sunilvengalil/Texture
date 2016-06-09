startSigma = 1.5;
numScales=10;
scaling = 1.1;

for scale = 1:numScales,
  sigma = startSigma * scaling^(scale-1);
  sigma
  
end