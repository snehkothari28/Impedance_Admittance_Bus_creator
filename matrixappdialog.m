classdef matrixappdialog < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        matrixcreatorUIFigure      matlab.ui.Figure
        UITable                    matlab.ui.control.Table
        AddNextElementButton       matlab.ui.control.Button
        EditField                  matlab.ui.control.EditField
        UITable_prev               matlab.ui.control.Table
        PreviousmatrixLabel        matlab.ui.control.Label
        NewmatrixLabel             matlab.ui.control.Label
        CreatedbySnehKothariLabel  matlab.ui.control.Label
    end

    
    properties (Access = private)
        y % Description
        x
        mainapp
        tbl
        bus_type
        matrix
        counter
        text
        prev
    end
    
    methods (Access = private)
        
        function colorme(app)
            A = app.UITable_prev.Data;
            B = app.UITable.Data;
            
            styleIndices = ones(size(B));
            styleIndices(1:size(A,1),1:size(A,2)) = 0;
            styleIndices(1:size(A,1),1:size(A,2)) = ((A - B(1:size(A,1),1:size(A,2))) ~= 0);
            
            [row,col] = find(styleIndices);
            s = uistyle('BackgroundColor','yellow');
            removeStyle(app.UITable);
            addStyle(app.UITable,s,'cell',[row,col]);
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, tbl, bus)
            app.x = 0.8;
            app.y = 0.8;
            app.tbl = tbl;
            app.bus_type = bus;
            app.counter = 0;
            app.prev = [];
        end

        % Button pushed function: AddNextElementButton
        function AddNextElementButtonPushed(app, event)
            if app.counter < height(app.tbl)
                app.counter = app.counter +1;
            else
                app.AddNextElementButton.Enable = 'off';
            end
            app.UITable_prev.Data = app.matrix;
            app.UITable_prev.RowName = 'numbered';
            if app.bus_type
                [app.matrix, app.text] = ybus(app.tbl(1:app.counter,:));
            else
                [app.matrix, app.text] = zbus(app.tbl(1:app.counter,:));
            end
            app.UITable.Data = app.matrix;
            app.UITable.RowName = 'numbered';
            
            colorme(app);
            
            app.EditField.Value = app.text;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create matrixcreatorUIFigure and hide until all components are created
            app.matrixcreatorUIFigure = uifigure('Visible', 'off');
            app.matrixcreatorUIFigure.Position = [100 100 1089 441];
            app.matrixcreatorUIFigure.Name = 'matrix creator';

            % Create UITable
            app.UITable = uitable(app.matrixcreatorUIFigure);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable.RowName = {};
            app.UITable.Position = [583 43 481 345];

            % Create AddNextElementButton
            app.AddNextElementButton = uibutton(app.matrixcreatorUIFigure, 'push');
            app.AddNextElementButton.ButtonPushedFcn = createCallbackFcn(app, @AddNextElementButtonPushed, true);
            app.AddNextElementButton.Position = [776 11 112 22];
            app.AddNextElementButton.Text = 'Add Next Element';

            % Create EditField
            app.EditField = uieditfield(app.matrixcreatorUIFigure, 'text');
            app.EditField.Editable = 'off';
            app.EditField.HorizontalAlignment = 'center';
            app.EditField.Position = [50 10 708 25];
            app.EditField.Value = 'Press "Add Next Element"';

            % Create UITable_prev
            app.UITable_prev = uitable(app.matrixcreatorUIFigure);
            app.UITable_prev.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable_prev.RowName = {};
            app.UITable_prev.Position = [50 47 510 341];

            % Create PreviousmatrixLabel
            app.PreviousmatrixLabel = uilabel(app.matrixcreatorUIFigure);
            app.PreviousmatrixLabel.HorizontalAlignment = 'center';
            app.PreviousmatrixLabel.FontSize = 18;
            app.PreviousmatrixLabel.Position = [240 401 130 22];
            app.PreviousmatrixLabel.Text = 'Previous matrix';

            % Create NewmatrixLabel
            app.NewmatrixLabel = uilabel(app.matrixcreatorUIFigure);
            app.NewmatrixLabel.HorizontalAlignment = 'center';
            app.NewmatrixLabel.FontSize = 18;
            app.NewmatrixLabel.Position = [776 401 96 22];
            app.NewmatrixLabel.Text = 'New matrix';

            % Create CreatedbySnehKothariLabel
            app.CreatedbySnehKothariLabel = uilabel(app.matrixcreatorUIFigure);
            app.CreatedbySnehKothariLabel.HorizontalAlignment = 'right';
            app.CreatedbySnehKothariLabel.FontSize = 14;
            app.CreatedbySnehKothariLabel.FontWeight = 'bold';
            app.CreatedbySnehKothariLabel.Position = [895 11 169 22];
            app.CreatedbySnehKothariLabel.Text = 'Created by Sneh Kothari';

            % Show the figure after all components are created
            app.matrixcreatorUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = matrixappdialog(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.matrixcreatorUIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.matrixcreatorUIFigure)
        end
    end
end