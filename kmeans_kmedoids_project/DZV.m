%the funcs gets 2 chunk, Di,Dj of different docs
%using ZV_calc for calculate the diffrence between docs
function [dis_bet_docs] = DZV(T, Di, Dj, i, j, fr_doc_mat_i, fr_doc_mat_j)
    dis_bet_docs = abs(ZV_calc(T, Di, i, fr_doc_mat_i)+ZV_calc(T, Dj, j, fr_doc_mat_j) - ... 
    ZV_calc(T, Di, j, fr_doc_mat_j) - ZV_calc(T, Dj, i, fr_doc_mat_i));
end