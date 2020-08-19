function [matrix,text] = ybus(tbl)
bd = table2array(tbl);
bd = [(1:size(bd,1)).' , bd];
nb = max(bd(:,2:3),[],'all');
matrix = zeros(nb);
xc = size(bd,2)>5;
for row = 1:size(bd,1)
    y = 1/(bd(row,4) + 1i*bd(row,5));
    m = bd(row,2);
    n = bd(row,3);
    
    if any(bd(row,2:3) == 0 )
        if m == 0
            matrix(n,n) = matrix(n,n) + y;
        else
            matrix(m,m) = matrix(m,m) + y;
        end
    else
        if n ~= m
            matrix(m,n) = matrix(m,n) - y;
            matrix(n,m) = matrix(n,m) - y;
        end
        matrix(m,m) = matrix(m,m)  + y;
        matrix(n,n) = matrix(n,n)  + y;
        if xc
            matrix(n,n) = matrix(n,n) + 1i*bd(row,6);
            matrix(m,m) = matrix(m,m) + 1i*bd(row,6);
        end
    end
end
text = "Connection of bus from " + num2str(m)+ " to "+ num2str(n) + " with admittance of " + num2str(y);