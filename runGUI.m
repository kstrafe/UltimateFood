function runGUI()

    [nutrient_names, food_names, food_nutrients] = loadDatabase();
    
    temporary = {};
    food_stuffs = {};
    iterator = 1;
    for i = food_names
        temporary{numel(temporary) + 1} = i{1};
        temporary{numel(temporary) + 1} = true;
        for j = food_nutrients(iterator,:)
            temporary{numel(temporary) + 1} = j(1);
        end
        food_stuffs = [food_stuffs; temporary];

        temporary = {};
        iterator = iterator + 1;
    end
    
    columnname = {'Food', 'Include'};
    
    for i = nutrient_names
        columnname{numel(columnname) + 1} = i{1};
    end
    
    window = figure...
    (...
        'Visible', 'off',...
        'Name', 'Food Finder',...
        'MenuBar', 'none',...
        'DockControls', 'off',...
        'Position', [500, 250, 1000, 500]...
    );
    
    columnformat = {'numeric', 'logical', 'bank'};
    food_stuffs_table = uitable...
    (...
            'Data', food_stuffs,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', [true],...
            'ColumnWidth', {60 60 120 'auto'},...
            'RowName', [],...
            'Position', [20 80 500 400]...
    );

    desired_nutrients = ...
    {...
        'Energy'            10000000    'Joule';...
        'Carbohydrate'      0.4         'kg';...
        'Fat'               0.3         'kg';...
        'Protein'           0.2         'kg';...
        'Fiber'             0.1         'kg';...
        'Cholesterol'       3*10^-4     'kg';...
    };
        
    desired = uitable...
    (...
            'Data', desired_nutrients,... 
            'ColumnName', {'Resource', 'Amount', 'Unit'},...
            'ColumnFormat', {'numeric', 'numeric', 'bank'},...
            'ColumnEditable', [false true false],...
            'ColumnWidth', {100 80 120 'auto'},...
            'RowName', [],...
            'Position', [540 80 200 400],...
            'CellEditCallback', @editCellRequirements...
    );
        
    output_table = {};
	result = uitable...
    (...
            'Data', output_table,... 
            'ColumnName', {'Food', 'Amount', 'Unit'},...
            'ColumnFormat', {'numeric', 'numeric', 'bank'},...
            'ColumnEditable', [false false false],...
            'ColumnWidth', {120 100 120 'auto'},...
            'RowName', [],...
            'Position', [760 80 220 400]...
    );
        
    btn = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'Clear',...
        'Position', [20 20 70 20],...
        'Callback', @close...
    );       

    compute_button = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'Compute',...
        'Position', [20 40 70 20],...
        'Callback', @compute...
    );
    
    reload_button = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'Reload',...
        'Position', [20 60 70 20],...
        'Callback', @reloadDatabase...
    );

    new_entry = uicontrol...
    (...
        'Style', 'pushbutton', 'String', 'New Entry',...
        'Position', [100 60 70 20],...
        'Callback', @createNewFoodEntry...
    );
    
    function close(source, callbackdata)
        window.Visible = 'off';
        close(window);
    end

    function createNewFoodEntry(source, callbackdata)
        new_data = cell(1, numel(food_stuffs_table.Data(1, :)));
        new_data{1} = 'Name';
        new_data{2} = [true];
        
        index = 3;
        number_of_columns = numel(new_data);
        while index <= number_of_columns
            new_data{index} = [0];
            index = index + 1;
        end
        food_stuffs_table.Data = [food_stuffs_table.Data; new_data];
    end

    function editCellNutrients(source, callbackdata)
    end

    function editCellRequirements(source, callbackdata)
        disp(desired.Data(:, 2));
        desired_nutrients(:, 2) = desired.Data(:, 2);
    end

    function setOutputTable(food_amount_array, deviation)
        %deviation = [deviation deviation]
        %format longG;
        %disp(cell2mat(desired_nutrients(:,2)) .* deviation);
        
        output_table = [food_amount_array];
        result.Data = output_table;
    end

    function compute(source, callbackdata)
        column_count = numel(food_stuffs_table.Data(1, :));
        row_count = numel(food_stuffs_table.Data(:, 1));
        input_nutrients = cell2mat(food_stuffs_table.Data(:, 3:column_count));
        required_nutrients = transpose(cell2mat(desired_nutrients(:,2)));
        
        index = 1;
        
        while index <= row_count
            col_index = 1;
            if food_stuffs_table.Data{index, 2}
                for j = required_nutrients
                    input_nutrients(index, col_index) = input_nutrients(index, col_index) / j;
                    col_index = col_index + 1;
                end
            else
                input_nutrients(index, :) = zeros(1, numel(input_nutrients(1, :)));
            end
            index = index + 1;
        end
        
        [ food_amount_array, deviation ] = computeOptimalFood( transpose(input_nutrients), ones(numel(desired_nutrients(:, 1)), 1) );
        setOutputTable(food_amount_array, deviation);
    end

    function reloadDatabase(source, callbackdata)
        [nutrient_names, food_names, food_nutrients] = loadDatabase();
    end

    window.Visible = 'on';
end

