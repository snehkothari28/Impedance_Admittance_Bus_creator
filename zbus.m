function [zbus_out,text] = zbus(tbl)
inp = table2array(tbl);
bd = inp(:,1:4);
bd(:,4) = bd(:,4) + 1i* inp(:,5);
bus = [0]; %#ok<NBRAK>
zbus_out = [];
for data = 1:size(bd,1)
    if or((bd(data,2) == 0),(bd(data,3) == 0))
        node = bd(data,2) + bd(data,3);
        if ~ismember(node,bus)
            [zbus_out,text] = mod1(zbus_out,node,bd(data,4));
            bus = [bus,node]; %#ok<*AGROW>
        else
            [zbus_out,text] = mod3(zbus_out,node,bd(data,4));
        end
    else
        if any(~ismember(bd(data,2:3),bus),'all')
            if ismember(bd(data,2),bus)
                node = bd(data,2);
                new= bd(data,3);
            else
                node = bd(data,3);
                new= bd(data,2);
            end
            [zbus_out,text] = mod2(zbus_out,node,new,bd(data,4));
            bus = [bus,bd(data,2),bd(data,3)];
        else
            [zbus_out,text] = mod4(zbus_out,bd(data,2),bd(data,3),bd(data,4));
        end
    end
end

    function [zbus_new,text] = mod1(zbus,node,zb)
        diff = node - length(zbus);
        zbus_new = [[zbus; zeros(diff,length(zbus)) ],zeros(length(zbus) + diff,diff)];
        
        zbus_new(node,node) = zb;
        text = "type 1 modification: " + "Connection of new bus " + num2str(node) + " to reference bus" ;
    end

    function [zbus_new,text] = mod2(zbus,old_bus,new,zb)
        if new > length(zbus)
            diff = new - length(zbus);
            zbus_new = [[zbus; zeros(diff,length(zbus)) ],zeros(length(zbus) + diff,diff)];
            zbus_new(new,1:length(zbus)) = zbus(old_bus,:);
            zbus_new(1:length(zbus),new) = zbus(:,old_bus);
            zbus_new(new,new) = zb+zbus(old_bus,old_bus);
        else
            zbus_new(new,1:new) = zbus(old_bus,1:new);
            zbus_new(1:new,new) = zbus(1:new,old_bus);
            zbus_new(new,new) = zb+zbus(old_bus,old_bus);
        end
        
        text = "type 2 modification: " + "Connection of existing bus " + num2str(old_bus) + " to new bus" +num2str(new);
    end

    function [zbus_new,text] = mod3(zbus,old_bus,zb)
        [zbus_new,~] = mod2(zbus,old_bus,length(zbus)+1,zb);
        zbus_new = kron(zbus_new,length(zbus_new));
        text = "type 3 modification: " + "Connection of existing bus " + num2str(old_bus) + " to reference bus";
    end

    function [zbus_new,text] = mod4(zbus,bus1,bus2,zb)
        zbus_new = [[zbus; (zbus(bus1,:) -zbus(bus2,:))],[(zbus(:,bus1) -zbus(:,bus2));0]];
        zbus_new(end,end) = zb+ zbus(bus1,bus1) + zbus(bus2,bus2)-2*zbus(bus1,bus2);
        zbus_new = kron(zbus_new,length(zbus_new));
        text = "type 4 modification: " + "Connection of existing bus " + num2str(bus1) + " to existing bus" +num2str(bus2);
    end

    function zbus_new = kron(zbus,node)
        zbus_new = zeros(size(zbus));
        for row = 1:size(zbus,1)
            for column = 1:size(zbus,2)
                zbus_new(row,column) = zbus(row,column) - zbus(row,node) * zbus(node,column) / zbus(node,node);
            end
        end
        zbus_new(node,:) = [];
        zbus_new(:,node) = [];
    end
    
end

