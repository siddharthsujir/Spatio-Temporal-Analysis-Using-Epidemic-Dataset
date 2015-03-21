clc;
clear;
fclose('all');
[filename,path] = uigetfile;

file=strcat(path,filename);

% Reads the data from the file provided by the user.
arr_DataFile2=xlsread(file,'C2:BA214');

user_choice=input('choose a file.\n Press 1 for Epidemic_word_file \n press 2 for Epidemic_word_file_avg \n press 3 for Epidemic_word_file_diff\n');
% reads the data from connectivity graph
[loc_mat,str,o]=xlsread('C:\Users\siddhu\Documents\1st semester\MWDB\Project\sampledata_P1_F14\sampledata_P1_F14\Graphs\LocationMatrix.xlsx');
[row,col]=size(str);
st2=str(2:row,1:1);
st3=str(1:1,2:col);
states={ 'AK','AL','AR','AZ','CA','CO','CT','DC','DE','FL','GA','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MI','MN','MO','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VA','VT','WA','WI','WV','WY'};

% If the user prefers to find min and max state from Epidemic Word File
if user_choice==1
    [num,str,other]=xlsread('epidemic_word_file.csv');

    count=numel(other);

    strarr=1:count;
    for i=1:1:count
    % reads all the values from epidemic_word_file.csv file
        strarr=strsplit(char(other(i)),' ');
        [a,b]=size(strarr);
        f(i)=strarr(1,1);
        state_arr(i)=strarr(1,2);
        time_arr(i)=strcat(strarr(1,3),strarr(1,4));
        win4(i,:)=str2num(char(strarr(1,5:b)));
        
        %computes the norm of win vector
        win_norm(i)=norm(win4(i,:));
    end

% If the user prefers to find min and max state from Epidemic Word Avg File
elseif user_choice==2
    % reads all the values from epidemic_word_file.csv file
    [num,str,other]=xlsread('epidemic_word_file_avg22.csv');

    count=numel(other);


    strarr=1:count;
    for i=1:1:count
        strarr=strsplit(char(other(i)),' ');
        [a,b]=size(strarr);
         f(i)=strarr(1,1);
        state_arr(i)=strarr(1,2);
        time_arr(i)=strcat(strarr(1,3),strarr(1,4));
        win4(i,:)=str2num(char(strarr(1,5:b)));
        
        %computes the norm of win vector
        win_norm(i)=norm(win4(i,:));
    end
% If the user prefers to find min and max state from Epidemic Word diff File 
elseif user_choice==3
     % reads all the values from epidemic_word_file.csv file
    [num,str,other]=xlsread('epidemic_word_file_diff22.csv');
    count=numel(other);
    strarr=1:count;
    for i=1:1:count
        strarr=strsplit(char(other(i)),' ');
        [a,b]=size(strarr);
        f(i)=strarr(1,1);
        state_arr(i)=strarr(1,2);
        time_arr(i)=strcat(strarr(1,3),strarr(1,4));
        win4(i,:)=str2num(char(strarr(1,4:b)));
        win_norm(i)=norm(win4(i,:));
    end

else
    display('wrong file');
end

%Finds the index of maximum strength state
[a,index]=ismember(max(win_norm),win_norm);

%Finds the index of minimum strength state
[b,index2]=ismember(min(win_norm),win_norm);


%Finds the state name of maximum strength state
max_strength_state=state_arr(index);

%Finds the state name of minimum strength state
min_strength_state=state_arr(index2);

%Finds the index of maximum strength in the connectivity matrix
[a,max_state]=ismember(max_strength_state,st3);

%Finds the index of minimum strength in the connectivity matrix
[b,min_state]=ismember(min_strength_state,st3);

%finds the one hop neighbour of the max strength state
win_max_neighbour=find(loc_mat(max_state,:)==1);

%finds the one hop neighbour of the minimum strength state
win_min_neighbour=find(loc_mat(min_state,:)==1);


%create an array with the maximum strength state along with its neighbours
 for i=1:1:numel(states)

    if(isequal(i,max_state)==1)
        state_axis(i)=st3(i);

    elseif(ismember(i,win_max_neighbour)==1)
        state_axis(i)=st3(i);

%     else
%           state_mat6(i)=' ';
     end
     
 end
 
 %create an array with the minimum strength state along with its neighbours
  for i=1:1:numel(states)

    if(isequal(i,min_state)==1)
        state_axis2(i)=st3(i);

    elseif(ismember(i,win_min_neighbour)==1)
        state_axis2(i)=st3(i);

%     else
%           state_mat6(i)=' ';
     end
     
  end
 
%  Creates a heat map using the image function by interpreting each element in a matrix as an index into the figure's colormap or directly as RGB values
im=image(transpose(arr_DataFile2),'XData',[1 213],'YData',[1 51]);
     
% To display the maximum strength state along with its one hop neighbours
for i = 1:1:numel(state_axis)

                 textHandles(5,i) = text(14,i,state_axis(i),...
                'horizontalAlignment','center','Color','w','FontSize',8);
                    if(ismember(i,win_max_neighbour)==1)
                         %cir=viscircles([10,i],0.5);
                         rect=rectangle('Position',[1,i-0.5,8,1]);
                         set(rect,'EdgeColor','w');
                    elseif(ismember(i,max_state)==1)
                        cir=viscircles([4,i],0.5);
                         rect=rectangle('Position',[1,i-0.5,8,1]);
                         set(rect,'EdgeColor','w');
                    end
    
end

  % To display the minimum strength state along with its one hop neighbours   
for i = 1:1:numel(state_axis2)
    
                 textHandles2(50,i) = text(195,i,state_axis2(i),...
                'horizontalAlignment','center','Color','w','FontSize',8);
            if(ismember(i,win_min_neighbour)==1)
                        
                         rect=rectangle('Position',[200,i-0.5,8,1]);
                         set(rect,'EdgeColor','w');
            elseif(ismember(i,min_state)==1)
                        cir=viscircles([205,i],0.5);
                        rect=rectangle('Position',[200,i-0.5,8,1]);
                         set(rect,'EdgeColor','w');
            end
    
    
end


