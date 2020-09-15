function [str] = create_str(robot_paper_set, human_paper_set,num_of_papers)
str_ro = [];
str_hu = [];
for i=1 : num_of_papers
    str_ro = strcat(str_ro, robot_paper_set{i});
    str_hu = strcat(str_hu, human_paper_set{i});
end

str = [];
str = strcat(str,str_ro);
str = strcat(str,str_hu);

str = regexprep(str,' +',' ');
str = regexprep(str,'[^a-zA-Z ]','');
str = lower(str);
end