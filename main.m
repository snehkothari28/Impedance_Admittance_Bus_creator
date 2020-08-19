classdef main < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        BusimpedanceadmittancematrixUIFigure  matlab.ui.Figure
        UITable             matlab.ui.control.Table
        bus                 matlab.ui.container.ButtonGroup
        ImpedanceButton     matlab.ui.control.RadioButton
        AdmittanceButton    matlab.ui.control.RadioButton
        VerifyMatrixButton  matlab.ui.control.Button
        SetthenumberofelementsinthesystemEditFieldLabel  matlab.ui.control.Label
        components          matlab.ui.control.NumericEditField
        charging            matlab.ui.control.CheckBox
        EditField           matlab.ui.control.EditField
        CreateMatrixButton  matlab.ui.control.Button
        ResetmatrixButton   matlab.ui.control.Button
        ZbusorYbusmatrixCreationtoolbySnehKothariLabel  matlab.ui.control.Label
    end

    
    properties (Access = public)
        tbl % main table
        bus_type %0 for z and 1 for y
        cap %0 if charging cap. is present
        rows %number of elements
        all_ok
        matrixapp
    end
    
    methods (Access = private)
        
        function updateindex(app)
            app.tbl{:,1} = (1:height(app.tbl)).';
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function StartupFcn(app)
            app.components.Value = 6;
            app.rows = 6;
            
            bd = [1 0 0 1.25 0;
                1 2 0 0.25 0;
                2 3 0 0.4 0;
                3 0 0 1.25 0;
                3 4 0 0.2 0;
                4 2 0 0.125 0];
            app.tbl = array2table(bd);
            %updateindex(app);
            app.cap = 0;
            app.UITable.Data = app.tbl(:,1:end-1+app.cap);
            app.UITable.RowName = 'numbered';
            app.all_ok = 0;
        end

        % Value changed function: components
        function componentsValueChanged(app, event)
            value = app.components.Value;
            if value < 1
                app.EditField.Value = 'Only postive number of components allowed';
                app.all_ok = 0;
                app.UITable.Enable = 'off';
                
            else
                app.rows = value;
                app.EditField.Value = 'Everything seems okay!';
                app.all_ok = 1;
                app.UITable.Enable = 'on';
                %updateindex(app);
                if app.rows > height(app.tbl)
                    diff = array2table(zeros(app.rows - height(app.tbl),5));
                    diff.Properties.VariableNames = app.tbl.Properties.VariableNames;
                    app.tbl = [app.tbl; diff];
                    %updateindex(app);
                    app.UITable.Data = app.tbl(:,1:end-1 + app.cap);
                else
                    app.tbl((height(app.tbl)- app.rows+1):end,:) = [];
                    %updateindex(app);
                    app.UITable.Data = app.tbl(:,1:end-1 + app.cap);
                end
            end
        end

        % Button pushed function: VerifyMatrixButton
        function VerifyMatrixButtonPushed(app, event)
            if any((table2array(app.UITable.Data(:,1)) + table2array(app.UITable.Data(:,2))) == 0)
                app.all_ok = 0;
            else
                app.all_ok = 1;
            end
            if app.all_ok == 1
                app.CreateMatrixButton.Enable = 'on';
            else
                app.EditField.Value = "check matrix structure";
            end
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            
            if or((indices(2) == 1),(indices(2) == 2))
                if newData < 0
                    app.EditField.Value = 'Only postive bus allowed';
                    app.all_ok = 1;
                else
                    app.EditField.Value = 'Everything seems okay!';
                    app.all_ok = 1;
                end
            else
                app.EditField.Value = 'Everything seems okay!';
                app.all_ok = 1;
            end
            
        end

        % Value changed function: charging
        function chargingValueChanged(app, event)
            value = app.charging.Value;
            if value
                app.UITable.Data = app.tbl(:,1:end);
                app.cap = 1;
            else
                app.UITable.Data = app.tbl(:,1:end-1);
                app.cap =0;
            end
        end

        % Button pushed function: CreateMatrixButton
        function CreateMatrixButtonPushed(app, event)
            matrixappdialog(app.UITable.Data,app.bus_type);
            
        end

        % Selection changed function: bus
        function busSelectionChanged(app, event)
            if app.ImpedanceButton.Value
                app.bus_type = 0;
                app.charging.Visible = 'off';
            else
                app.bus_type = 1;
                app.charging.Visible = 'on';
            end
        end

        % Button pushed function: ResetmatrixButton
        function ResetmatrixButtonPushed(app, event)
            if app.bus_type
                bd = [1, 2, 0.2, 0.8, 0.02;
                    2, 3, 0.3, 0.9, 0.03;
                    2, 4, 0.25, 1, 0.04;
                    3, 4, 0.2, 0.8, 0.02;
                    1, 3, 0.1, 0.4, 0.01];
            else
                bd = [1 0 0 1.25 0;
                    1 2 0 0.25 0;
                    2 3 0 0.4 0;
                    3 0 0 1.25 0;
                    3 4 0 0.2 0;
                    4 2 0 0.125 0];
            end
            app.tbl = array2table(bd);
            %updateindex(app);
            app.cap = 0;
            app.UITable.Data = app.tbl(:,1:end-1+app.cap);
            app.all_ok = 0;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create BusimpedanceadmittancematrixUIFigure and hide until all components are created
            app.BusimpedanceadmittancematrixUIFigure = uifigure('Visible', 'off');
            app.BusimpedanceadmittancematrixUIFigure.Position = [100 100 640 480];
            app.BusimpedanceadmittancematrixUIFigure.Name = 'Bus impedance/admittance matrix';
            app.BusimpedanceadmittancematrixUIFigure.Scrollable = 'on';

            % Create UITable
            app.UITable = uitable(app.BusimpedanceadmittancematrixUIFigure);
            app.UITable.ColumnName = {'Bus1'; 'Bus2'; 'Resitive Component'; 'Inductive Component'; 'Charging Component'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = [true true true true true true];
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Position = [31 80 580 261];

            % Create bus
            app.bus = uibuttongroup(app.BusimpedanceadmittancematrixUIFigure);
            app.bus.SelectionChangedFcn = createCallbackFcn(app, @busSelectionChanged, true);
            app.bus.Title = 'Data is in which format?';
            app.bus.Position = [400 353 207 72];

            % Create ImpedanceButton
            app.ImpedanceButton = uiradiobutton(app.bus);
            app.ImpedanceButton.Text = 'Impedance';
            app.ImpedanceButton.Position = [11 26 81 22];
            app.ImpedanceButton.Value = true;

            % Create AdmittanceButton
            app.AdmittanceButton = uiradiobutton(app.bus);
            app.AdmittanceButton.Text = 'Admittance';
            app.AdmittanceButton.Position = [11 4 82 22];

            % Create VerifyMatrixButton
            app.VerifyMatrixButton = uibutton(app.BusimpedanceadmittancematrixUIFigure, 'push');
            app.VerifyMatrixButton.ButtonPushedFcn = createCallbackFcn(app, @VerifyMatrixButtonPushed, true);
            app.VerifyMatrixButton.Position = [404 39 100 22];
            app.VerifyMatrixButton.Text = 'Verify Matrix';

            % Create SetthenumberofelementsinthesystemEditFieldLabel
            app.SetthenumberofelementsinthesystemEditFieldLabel = uilabel(app.BusimpedanceadmittancematrixUIFigure);
            app.SetthenumberofelementsinthesystemEditFieldLabel.Position = [31 395 226 22];
            app.SetthenumberofelementsinthesystemEditFieldLabel.Text = 'Set the number of elements in the system';

            % Create components
            app.components = uieditfield(app.BusimpedanceadmittancematrixUIFigure, 'numeric');
            app.components.ValueChangedFcn = createCallbackFcn(app, @componentsValueChanged, true);
            app.components.HorizontalAlignment = 'left';
            app.components.Position = [264 394 38 22];

            % Create charging
            app.charging = uicheckbox(app.BusimpedanceadmittancematrixUIFigure);
            app.charging.ValueChangedFcn = createCallbackFcn(app, @chargingValueChanged, true);
            app.charging.Visible = 'off';
            app.charging.Text = 'Contains Charging component';
            app.charging.Position = [194 355 195 22];

            % Create EditField
            app.EditField = uieditfield(app.BusimpedanceadmittancematrixUIFigure, 'text');
            app.EditField.Editable = 'off';
            app.EditField.HorizontalAlignment = 'center';
            app.EditField.Position = [31 39 344 22];
            app.EditField.Value = 'Everything seems okay!';

            % Create CreateMatrixButton
            app.CreateMatrixButton = uibutton(app.BusimpedanceadmittancematrixUIFigure, 'push');
            app.CreateMatrixButton.ButtonPushedFcn = createCallbackFcn(app, @CreateMatrixButtonPushed, true);
            app.CreateMatrixButton.Enable = 'off';
            app.CreateMatrixButton.Position = [511 39 100 22];
            app.CreateMatrixButton.Text = 'Create Matrix';

            % Create ResetmatrixButton
            app.ResetmatrixButton = uibutton(app.BusimpedanceadmittancematrixUIFigure, 'push');
            app.ResetmatrixButton.ButtonPushedFcn = createCallbackFcn(app, @ResetmatrixButtonPushed, true);
            app.ResetmatrixButton.Position = [31 355 100 22];
            app.ResetmatrixButton.Text = 'Reset matrix';

            % Create ZbusorYbusmatrixCreationtoolbySnehKothariLabel
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel = uilabel(app.BusimpedanceadmittancematrixUIFigure);
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel.HorizontalAlignment = 'center';
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel.FontName = 'Times New Roman';
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel.FontSize = 18;
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel.FontWeight = 'bold';
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel.FontColor = [1 0 0];
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel.Position = [115 439 411 22];
            app.ZbusorYbusmatrixCreationtoolbySnehKothariLabel.Text = 'Zbus or Ybus matrix Creation tool by Sneh Kothari';

            % Show the figure after all components are created
            app.BusimpedanceadmittancematrixUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = main

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.BusimpedanceadmittancematrixUIFigure)

            % Execute the startup function
            runStartupFcn(app, @StartupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.BusimpedanceadmittancematrixUIFigure)
        end
    end
end