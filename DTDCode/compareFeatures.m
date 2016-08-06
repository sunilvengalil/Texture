%Author Sunil Kumar Vengalil
%compares two sets of local features 
clear all;
close all;

seed1  = 3;
seed2 = 4;
folderName =strcat('C:\DTD\data\dtd\features-', num2str(seed1),'\');
folderName1 =strcat('C:\DTD\data\dtd\features-', num2str(seed2),'\');

textures = dir(folderName);
files = dir(strcat(folderName,textures(3).name,'\*.mat'));
feature1 = loadFeatures( fullfile(strcat(folderName,textures(3).name),files(1).name) );

textures = dir(folderName1);
files = dir(strcat(folderName1,textures(3).name,'\*.mat'));
feature2 = loadFeatures( fullfile(strcat(folderName1,textures(3).name),files(1).name) );
fprintf('Folder1: %s\n',folderName);
fprintf('Folder1: %s\n',folderName1);
fprintf('Feature 1 dimensions:%d X %d\n', size(feature1,1),size(feature1,2));
fprintf('Feature 2 dimensions:%d X %d\n', size(feature2,1),size(feature2,2));


data = ['Allison Jones';'Development  ';'Phoenix      ';'Allison Jones';'Allison Jones';'Allison Jones';'Allison Jones';'Allison Jones'];
mismatches = cellstr(data);
countn = 1;
%noOfTexturesCompared = 0;
noOfFilesInEachTexture = zeros(1,47);
textureIndex = 1;
for i = 1 : length(textures)
    
    texture = textures(i).name;
    
    files = dir(strcat(folderName,texture,'\*.mat'));
    for j = 1: length(files);
        noOfFilesInEachTexture(1, textureIndex) = noOfFilesInEachTexture(1, textureIndex) + 1;
        fileName = files(j).name;
        f = loadFeatures(fullfile(strcat(folderName,texture),fileName));
        f1 = loadFeatures(fullfile(strcat(folderName1,texture),fileName));
        if norm(f -f1) ~= 0
            mismatches{countn} = strcat(num2str(seed1),'-',num2str(seed2),texture );
            countn = countn + 1;
        end
    end
    if noOfFilesInEachTexture(1, textureIndex) > 0
        textureIndex = textureIndex + 1;
    end
    
end



%f =loadFeatures(fullfile(folderName,fileName));
%f1 =loadFeatures(fullfile(folderName1,fileName));
%if norm(f -f1 <> 0)
    
%end
