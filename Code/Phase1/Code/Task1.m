% Clear All Files and variables
clc;
clear;
fclose('all');
delete('epidemic_word_file.csv');

%Initialize the values of mu and sigma. Obtain the values of h, window
%length w and directory from the user.
mu=0.0;
sigma=0.25;
h=input('Enter the shift length h: ');
w=input('Enter the window length w: ');
[filename,path] = uigetfile;
% directory='C:\Users\siddhu\Documents\1st semester\MWDB\Project\SampleData\';

fnames = dir(strcat(path,'*.csv'));
[len,col]=size(fnames);
r=input('Enter the resolution r: ');
% For all the files in the directory, read the data from Input simulation datasets.
for count=1:1:len

arr_DataFile=xlsread(strcat(path,fnames(count).name),'C2:BA214');
[v_rows,v_columns]=size(arr_DataFile);

 [num,states_ini,otherdata]=xlsread(strcat(path,fnames(count).name));
 tm=otherdata(:,2);
states={ 'AK','AL','AR','AZ','CA','CO','CT','DC','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY'};
st=transpose(states);

%find the maximum and the minimum value from the dataset.
%And Normalize the values.
arr_maximum=max(arr_DataFile(:));
arr_minimum=min(arr_DataFile(:));
for i=1:1:v_columns
    for j=1:1:v_rows
        arr_DataFile(j,i)=((arr_DataFile(j,i)-arr_minimum)/(arr_maximum-arr_minimum));
    end
end

%Compute the length of the gaussian band using the given formula.
fun = @(x) exp(-(x-mu).^2/(2*sigma^2))/(sigma*sqrt(2*pi));

length=1:r;
  
for i=1:1:r
length(i)=(integral(fun,(i-1)/r,i/r)/integral(fun,0,1));
end

[temo,count1]=size(length);

%Finds the ranges depending on the length of the band
s=0;
range=0:length:1;
range(1)=s;
for i=2:1:count1+1
    range(i)=range(i-1)+length(i-1);
end

% Quantifies the data in Datasets depending upon the range
count2=numel(range);
mid=1:count2-1;
s=0;
arr=arr_DataFile;
 for i=1:1:v_columns
    for j=1:1:v_rows
        for k=1:1:count2-1
            %computes the mid value of the band
          mid(k)=(range(k)+range(k+1))/2;
            % To use mid value of bank as the representative
            if (arr_DataFile(j,i)>=range(k)) && (arr_DataFile(j,i)<range(k+1))
              arr(j,i)=mid(k);
            end

         end
    end
 end
 rw=1;
 win=1:w;
 x=0;
 
 %open a file to write the contents 
 file=fopen('epidemic_word_file.csv','a');
 index=0;
 index2=1;
 for i=1:1:v_columns
  for j=1:h:v_rows-w+1
      index=index+1;
      for k=1:1:w
          % computes the win value of the window based on the size of
          % window.
          win(k)=arr(j+k-1,i);
      end
           win_mat=num2str(win);
        %finds the corresponding time and state of the vector
       time(index,:)=cellstr(tm(j+1,:));
       state(index)=st(i);
       file_name_arr{index} = [fnames(count).name];
       %writes the idx=(f,s,t) and win value to the epidemice_word_file
       fprintf(file,'%5s %2s %s %s\n', file_name_arr{index},state{index},time{index,:},win_mat);

  end
 end 
end
fclose(file);
