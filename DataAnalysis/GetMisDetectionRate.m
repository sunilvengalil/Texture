%Count the number of 2 in top region
clc
topregion = tmap(1:399,:);
bottomregion = tmap(401:800,:);
[h w] = size(topregion);

%Find the majority pixel in top and bottom region
numberOf1inTopregion = sum(sum(topregion == 1));
numberOf2inTopregion = sum(sum(topregion == 2));

numberOf1inBottomregion = sum(sum(bottomregion == 1));
numberOf2inBottomregion = sum(sum(bottomregion == 2));


reg1Maj = 1;
if numberOf2inTopregion > numberOf1inTopregion
    reg1Maj = 2;
end
reg2Maj =1;
if reg1Maj == 1 
    reg2Maj = 2;
end

if reg1Maj == 1
    misdetectionRateTop  = numberOf2inTopregion/(numberOf1inTopregion + numberOf2inTopregion)
    misdetectionRateBottom = numberOf1inBottomregion/(numberOf1inBottomregion + numberOf2inBottomregion)
else
    misdetectionRateTop  = numberOf1inTopregion/(numberOf1inTopregion + numberOf2inTopregion)
    misdetectionRateBottom = numberOf2inBottomregion/(numberOf1inBottomregion + numberOf2inBottomregion)
end





