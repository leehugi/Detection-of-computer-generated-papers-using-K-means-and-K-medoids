clc
clear all

%load the data set
load robot_paper_data.mat
load human_set_data.mat

T = 10;
num_of_group = 10; %number of training paper to each group (real and fake)

%divided each paper to parts in size of chunk_size
chunk_size = 1000; % size of each part
chunk_cnt_robot = 0;      
chunk_cnt_human = 0;      
for i = 1 : num_of_group
   [arr_robot_chunk_srt{i}, arr_chunk_cnt_robot{i}] = partition_str(robot_paper_set{i}, chunk_size); 
   chunk_cnt_robot = chunk_cnt_robot + arr_chunk_cnt_robot{i};
   [arr_human_chunk_str{i}, arr_chunk_cnt_human{i}] = partition_str(human_paper_set{i}, chunk_size);
   chunk_cnt_human = chunk_cnt_human + arr_chunk_cnt_human{i};
end

%create the real lable
real_lable(1:chunk_cnt_robot,1) = 1; 
real_lable(chunk_cnt_robot+1:chunk_cnt_human+chunk_cnt_robot - 200,1) = 2;

%create a dictionary to each paper from the training set by N-grams
[str_docs] = create_str(robot_paper_set, human_paper_set,num_of_group);
[subStrings, counts] = n_gram(str_docs,3);
%took just the unique sub-strings to the dictionary
j=1;
for i=1:length(counts)
    if counts(i) > 1000
        dictionary(j,:)=subStrings(i);
        j = j+1;
    end
end

%construct the frequency matrix for using the dictionary
for j=1:num_of_group
    for i=1:arr_chunk_cnt_robot{j}
         fr_mat_robot{j}(i,:) = occur(arr_robot_chunk_srt{j}(i,:),dictionary); 
    end
    for i=1:arr_chunk_cnt_human{j}
        fr_mat_human{j}(i,:) = occur(arr_human_chunk_str{j}(i,:),dictionary);
    end
end

%create DZV matrix of all chuncks
row = 1;
col = 1;
for i=1:num_of_group  %for the robot docs
    for j=1+T:arr_chunk_cnt_robot{i}   %for the chunck in doc i
        for k=1:num_of_group  %for all the other docs
            if i ~= k
                for n=1+T:arr_chunk_cnt_robot{k}   %for the chunck in doc k
                    dzv_matrix(row,col) = DZV(T, fr_mat_robot{i}(j,:), fr_mat_robot{k}(n,:),...
                        j, n, fr_mat_robot{i}, fr_mat_robot{k});
                    col = col+1;
                end
            end
        end
        for k=1:num_of_group  %for all the other docs
            for n=1+T:arr_chunk_cnt_human{k}   %for the chunck in doc k
                dzv_matrix(row,col) = DZV(T, fr_mat_robot{i}(j,:), fr_mat_human{k}(n,:), j, n,...
                     fr_mat_robot{i}, fr_mat_human{k});
                col = col+1;
            end
        end
        col = 1;
        row = row+1;
    end
end

for i=1:num_of_group  %for the human docs
    for j=1+T:arr_chunk_cnt_human{i}   %for the chunck in doc i
        for k=1:num_of_group  %for all the other docs
            if i ~= k
                for n=1+T:arr_chunk_cnt_human{k}   %for the chunck in doc k
                    dzv_matrix(row,col) = DZV(T, fr_mat_human{i}(j,:), fr_mat_human{k}(n,:), j, n,...
                        fr_mat_human{i}, fr_mat_human{k});
                    col = col+1;
                end
            end
        end
        for k=1:num_of_group  %for all the other docs
            for n=1+T:arr_chunk_cnt_robot{k}   %for the chunck in doc k
                dzv_matrix(row,col) = DZV(T, fr_mat_human{i}(j,:), fr_mat_robot{k}(n,:), j, n,...
                     fr_mat_human{i}, fr_mat_robot{k});
                col = col+1;
            end
        end
        col = 1;
        row = row+1;
    end
end

%using k-means and k-medoids
idx_kmeans = kmeans(dzv_matrix,2);
idx_medoids = kmedoids(dzv_matrix,2);

%show the results of k-means
figure;
subplot(1,2,1)
gscatter(dzv_matrix(:,1),dzv_matrix(:,2),idx_kmeans,'bg');
title('{\bf K-means}');
subplot(1,2,2)
gscatter(dzv_matrix(:,1),dzv_matrix(:,2),real_lable, 'bg');
title('{\bf Real labeles}');

%show the results of k-medoids
figure;
subplot(1,2,1)
gscatter(dzv_matrix(:,1),dzv_matrix(:,2),idx_medoids,'bg');
title('{\bf K-medoids}');
subplot(1,2,2)
gscatter(dzv_matrix(:,1),dzv_matrix(:,2),real_lable, 'bg');
title('{\bf Real labeles}');

