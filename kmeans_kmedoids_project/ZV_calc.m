%the func gets T pricurses, chunk Di, k the number of chunk in the doc
%and fricuancy matrix for the doc 
%using spearman_calc for calculate the distance between the chunk to the
%doc
function [r_sum] = ZV_calc(T, Di, k, fr_doc_mat)
    r_sum = 0;
    for r=1:T
        r_sum = r_sum + spearman_calc(Di,fr_doc_mat(k-r,:));
    end
     r_sum = r_sum/T;
end