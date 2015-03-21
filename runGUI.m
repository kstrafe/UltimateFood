
function runGUI()

    [nutrient_names, food_names, food_nutrients] = loadDatabase();

    window = figure('Visible', 'off', 'Name', 'Food Finder', 'MenuBar', 'none', 'DockControls', 'off', 'Position', [500, 250, 1000, 500]);
    
    data = ...
    {...
        'Banana'    true    456.3457        ;...
        'Milk'      true    510.2342     	;...   
        'Apple'     false   658.2           ;...
    };
    
    columnname = {'Food', 'Include', 'Energy (Joule)'};
    columnformat = {'numeric', 'logical', 'bank'};
    food_stuffs = uitable('Data', data,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', [false true false],...
            'ColumnWidth', {60 60 120 'auto'},...
            'RowName', [],...
            'Position', [20 80 500 400]);

    desired_nutrients = ...
    {...
        'Energy'            10000000    'Joule';...
        'Carbohydrates'     0.4         'kg';...
    };
        
    desired = uitable('Data', desired_nutrients,... 
            'ColumnName', {'Resource', 'Amount', 'Unit'},...
            'ColumnFormat', {'numeric', 'numeric', 'bank'},...
            'ColumnEditable', [false true false],...
            'ColumnWidth', {100 80 120 'auto'},...
            'RowName', [],...
            'Position', [540 80 200 400]);
        
    output_table = {};
	result = uitable('Data', output_table,... 
            'ColumnName', {'Food', 'Amount', 'Unit'},...
            'ColumnFormat', {'numeric', 'numeric', 'bank'},...
            'ColumnEditable', [false false false],...
            'ColumnWidth', {120 100 120 'auto'},...
            'RowName', [],...
            'Position', [760 80 220 400]);
        
    btn = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
        'Position', [20 20 70 20],...
        'Callback', @close);       

    compute_button = uicontrol('Style', 'pushbutton', 'String', 'Compute',...
        'Position', [20 40 70 20],...
        'Callback', @compute);
    
    reload_button = uicontrol('Style', 'pushbutton', 'String', 'Reload',...
        'Position', [20 60 70 20],...
        'Callback', @reloadDatabase);
    
    function close(source, callbackdata)
        window.Visible = 'off';
        close(window);
    end

    function setOutputTable(food_amount_array, deviation)
        output_table.Data = food_amount_array;
    end

    function compute(source, callbackdata)
        [ food_amount_array, deviation ] = computeOptimalFood( food_nutrients, desired_nutrients );
        setOutputTable(food_amount_array, deviation);
    end

    function reloadDatabase(source, callbackdata)
        [nutrient_names, food_names, food_nutrients] = loadDatabase();
    end

    window.Visible = 'on';
end

