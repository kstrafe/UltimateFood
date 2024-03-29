function saveDatabase(cell_array, nutrients )

    fileID = fopen('foods.txt', 'w'); %Change  to desired file
    
    nutrients = transpose(nutrients);

    fprintf(fileID,'%s This is the info text\n', '%');
    fprintf(fileID, '\n');
    nuts_str = '';
    for i=3:length(nutrients)
        if i==3
            nuts_str = [nuts_str, sprintf('%s%s\t', '%', nutrients{i})];
        else
            nuts_str = [nuts_str, sprintf('\t%s', nutrients{i})];
        end
    end
    fprintf(fileID,'%s',nuts_str);

    fprintf(fileID,'\n');
    sizes = size(cell_array);
    cols = sizes(2);
    rows = sizes(1);
    for i=1:rows
        fprintf(fileID,'%s%s\n','%', cell_array{i,1});
        line = '';
        for j=3:cols
            if j==3
                line = strcat(line, sprintf('%.0f\t', cell_array{i,j}));
            else
                 line = strcat(line, sprintf(' %.4f\t', cell_array{i,j}));
            end

        end
        fprintf(fileID,'%s\n',nuts_str);
        fprintf(fileID,'%s\n',line);
    end

    fclose(fileID);

end