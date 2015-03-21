% Prompt user for input directory only if not present in session
if(exist('dirName','var')==0)
    dirName=strcat(input('Enter simulation files directory path in  single quotes:\n '),'\');
end

% Prompt user for ouput directory only if not present in session
if(exist('outDirName','var')==0)
    outDirName=strcat(input('Enter output files(word,avg,diff) directory path in  single quotes:\n '),'\');
end

% Prompt user for query file name assuming simulation file is kept in
% directory as original simulation files and output files of this new query
% files realted to word,avg and diff are located in above output directory
% if not generate them using phase1 code and keep them it similar
% directories.
fileq=input('Enter your file name in  single quotes:\n');

% Pronpt user for K
k=input('Enter your integer k:\n');

% Prompt user for which similarity of task1 need to be user to generate
% heatmaps
simfun=input('Choose your similarity function number:\n 1.a\n 2.b\n 3.c\n 4.d\n 5.e\n 6.f\n 7.g\n 8.h\n');

switch simfun
    case 1
        simfun1='a';
    case 2
        simfun1='b';
    case 3
        simfun1='c';
    case 4
        simfun1='d';
    case 5
        simfun1='e';
    case 6
        simfun1='f';
    case 7
        simfun1='g';
    case 8
        simfun1='h';
    otherwise
        simfun1='a';
end

fnameq=strcat(fileq,'.csv');
filename1 = fullfile(dirName,fnameq);                         % full path to file
[A1,text1,raw1]=xlsread(filename1);                             % read the data from each file
sizem1=size(A1);                                              % find number of rows and columns
rowsize1 = sizem1(1);                                         % find number of rows
colsize1 = sizem1(2);                                         % find number of columns

files = dir( fullfile(dirName,'*.csv') );                       %# list all *.csv files
files_list = strrep({files.name},'.csv','');                    % store file names without extension .csv
files_list=files_list(~strcmp(files_list, fileq));

%clear simulationMatrix;
simulationMatrix=num2cell(zeros(numel(files_list),2));

% For all the input files and given query files running simarlity task as
% selected by user and store the output of each file into simulationMatrix
% along with file name of the similarity with query file.
for i=1:numel(files_list)
    fh=str2func(strcat('Task1',simfun1));
    simulationMatrix{i,1}= fh(dirName,fileq,files_list{i},outDirName,'');
    simulationMatrix{i,2}= files_list{i};
end

% sort the similarities in descending order
sortedSim = sort(cell2mat(simulationMatrix(:,1)) , 'descend');

filename2 = fullfile(dirName,fnameq);                         % full path to file
[Sim,Simtext,Simraw]=xlsread(filename2);                             % read the data from each file

% generating heatmap for the query file
% Create figure
figure1 = figure;
% Create axes
axes1 = axes('Parent',figure1,'Layer','top');
cdata1=Sim(:,3:end)';

box(axes1,'on');
hold(axes1,'all');

% Create image
image(cdata1,'Parent',axes1,'CDataMapping','scaled');
% Create colorbar
colorbar('peer',axes1);
title(fnameq);
set(axes1,'Units','normalized');
positions=get(axes1,'Position');

% generating heatmaps for the k similar files to query files
i=0;
for p=1:k
    if (i>=k)
        continue;
    end
    
    %  indexOfSim=find(simulationMatrix(:,1),sortedSim(j))
    % find the index of sorted element in simulation matrix
    [index1, index2] = find([simulationMatrix{:,1}] == sortedSim(p));
    
    
    for x=1:numel(index2)
        
        % to make sure generate only k similar heatmps if reached k skip
        % remaining if found equally similar
        if((x+i)>k)
            continue;
        end
        
        j=index2(x);
        
        file2=simulationMatrix{j,2};
        fname2=strcat(file2,'.csv');
        filename2 = fullfile(dirName,fname2);                                % full path to file
        [Sim,Simtext,Simraw]=xlsread(filename2);                             % read the data from each file
        
        % Create figure
        figure1 = figure;
        % Create axes
        axes1 = axes('Parent',figure1,'Layer','top');
        cdata1=Sim(:,3:end)';
        box(axes1,'on');
        hold(axes1,'all');
        
        % Create image
        %imagesc(cdata1,'Parent',axes1);
        image(cdata1,'Parent',axes1,'CDataMapping','scaled');
        % Create colorbar
        colorbar('peer',axes1);
        title(fname2);
        set(axes1,'Units','normalized');
        %get(figure1,'OuterPosition')
        positions=get(axes1,'Position');
        
    end
    i=i+numel(index1);
end